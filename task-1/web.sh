#!/bin/sh
# author: Steven Huang
# date: 07/22/2021
# filename: web.sh
# cmd: ./web.sh
# func: This shell will install Hugo, generate a site first, then create a new post with random post content (via fortune), then generate the static content of the website and git commmit changes and push it to upstream repo

SITE="mysite"

GIT="https://github.com/p4s2wd/wiredcraft.git"

# define a func and install the Hugo online
function install_hugo()
{
URL="https://github.com/gohugoio/hugo/releases/download/v0.86.0/hugo_0.86.0_Linux-64bit.tar.gz"
   if [ ! -f /usr/local/bin/hugo ]; then
    cd /tmp
    # download the Hugo online
    wget ${URL}
    tar zxvf hugo_0.86.0_Linux-64bit.tar.gz
    sudo cp hugo /usr/local/bin
   fi
}

# define a func and generate a basic site
function init_site()
{
    cd ~/
    if [ -d ${SITE} ]; then
	    rm -rf ${SITE}
    fi
	   mkdir -p ${SITE}
    cd ${SITE}
    # init a site named quickstart
    hugo new site quickstart
}

# define a func and add a Theme into the site
function add_theme()
{
THEME="https://github.com/theNewDynamic/gohugo-theme-ananke/archive/master.zip"
    cd ~/${SITE}/quickstart
    # download the THEME from online
    wget ${THEME}
    unzip master.zip
    mv gohugo-theme-ananke-master ananke
    mv ananke themes/
    # add the theme to the site configuration
    echo theme = \"ananke\" >> config.toml
}

# define a func and add a post
function add_post()
{
    cd ~/${SITE}/quickstart
    hugo new posts/new-post.md
    fortune >> content/posts/new-post.md
    # update the draft from true to false
    sed -i "s/draft: true/draft: false/g" content/posts/new-post.md
    # generate the static content of the website
    hugo -D
}

# define the func and add the static content of the website into upstream repo via git
function git_commit()
{
    cd ~/${SITE}/quickstart
    mv public task-1
    git init
    git remote add origin ${GIT}
    git add task-1
    git commit -m "Add the static content of the website"
    git push -u origin master
}

# define the main func here
function main()
{
    install_hugo
    init_site
    add_theme
    add_post
    git_commit
}

# start the shell from here
main