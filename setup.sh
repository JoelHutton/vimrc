#!/bin/bash
GLOBAL=false;

#iterate through cli arguments
for var in "$@"
do
	case $var in
		"--global")
			GLOBAL= true
			;;
		*)
			echo "unrecognised flag $var"
			exit 1
			;;
	esac
done
if [[ $USER == "root" ]]; then 
	echo "This script must not be run as root" 
	exit 1
fi 

#backup file, unless backup already present, in which case return 1
backup(){
	filename= "$1"
	backup_filename= "$2"
	if [ ! -f $backup_filename ]; then 
		if [ -f $filename ]; then 
			sudo mv $filename $backup_filename
		fi
	else
		exit 1
	fi
	
}

if [ -f ./vimrc ]
then
	echo "backing up current vimrc's in .bak.name"
	backup /home/$USER/.vimrc /home/$USER/.bak.vimrc
	if [[ $GLOBAL ]]
	then
		backup /etc/vim/vimrc /etc/vim/.bak.vimrc
		backup /root/vimrc /root/.bak.vimrc
	fi
	echo "copying files into place"
	ln -s $(pwd)/vimrc ~/.vimrc
	if [[ $GLOBAL ]]
	then
		sudo ln -s $(pwd)/vimrc /etc/vim/vimrc
		sudo ln -s $(pwd)/vimrc /root/vimrc
	fi
else 
	echo "please execute from within the directory (can't find vimrc)"
fi
