#!/bin/bash

if [[ $USER == "root" ]]; then 
	echo "This script must not be run as root" 
	exit 1
fi 

if [ -f ./vimrc ]
then
	echo "backing up current vimrc's in .bak.name"
	if [ ! -f ~/.bak.vimrc ]; then 
		if [ -f ~/.vimrc ]; then 
			mv ~/.vimrc ~/.bak.vimrc
		fi
	else
		echo "backups already exist, exitting"
		exit 1
	fi
	if [ ! -f /etc/vim/.bak.vimrc ]; then 
		if [ -f /etc/vim/vimrc ]; then 
			sudo mv /etc/vim/vimrc /etc/vim/.bak.vimrc
		fi
	else
		echo "backups already exist, exitting"
		exit 1
	fi
	if [ ! -f /root/.bak.vimrc ]; then 
		if [ -f /root/vimrc ]; then 
			sudo mv /root/vimrc /root/.bak.vimrc
		fi
	else
		echo "backups already exist, exitting"
		exit 1
	fi
	echo "copying files into place"
	sudo ln -s $(pwd)/vimrc ~/.vimrc
	sudo ln -s $(pwd)/vimrc /etc/vim/vimrc
	sudo ln -s ./vimrc /root/vimrc
else 
	echo "please execute from within the directory (can't find vimrc)"
fi
