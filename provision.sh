#!/bin/bash

# assign variables
ACTION=${1}
VERSION="1.0.0"

function consume_action() {

case "$ACTION" in
	-r|--remove)
		remove_system
		;;
	-h|--help)
		display_help
		;;
	-v|--version)
		show_version
		;;
	*)
	echo "Usage ${0} {<no option>|-r|-h|-v}"
	exit 1
esac
}

function provision_system() {
# action == <nothing>

# delete this
echo $ACTION

# update all system packages
sudo yum update -y

# install the Nginx software package
sudo amazon-linux-extras install nginx1.12 -y

# configure Nginx to automatically start at system boot up
sudo chkconfig nginx on

# copy the website documents from s3 to the web document root directory
sudo aws s3 cp s3://friedmanellen-ex1-webserver/ /usr/share/nginx/html/ --recursive

# start the Nginx service
sudo service nginx start
}

function remove_system() {
# action == r

# stop the Nginx system
sudo service nginx stop

sudo rm /usr/share/nginx/html/*

# uninstall Ngixn software package
sudo yum remove nginx -y
}

function show_version() {

cat << EOF
Version $VERSION
EOF
}

function display_help() {

cat << EOF
Usage: ${0} {-c|--create|-d|--delete|-h|--help|-v|--version} <filename>

OPTIONS:
	no options	Update the software packages, install Nginx, and copy files into the website document root directly.
	-r | --remove	Stop Nginx service, delete files in the website document root directoy, and uninstall Nginx.
	-h | --help	Display the command help
	-v | --version	Display the version of the script

Examples:
	Provision the system:
		$ ${0} 
	
	Stop and uninstall Nginx:
		$ ${0} -r

	Display help:
		$ ${0} -h

	Display script version:
		$ ${0} -v

EOF
}

if [ -z "$1" ]
	then
		provision_system
	else
		consume_action
fi



