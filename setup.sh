#!/bin/bash
GLOBAL=false
#continue even if backups already exist for these files, indicating a previous installation
IGNORE_BACKUPS=false


#iterate through cli arguments
for var in "$@"
do
	case $var in
		"--ignore-backups")
			IGNORE_BACKUPS=true
			;;
		"--global")
			GLOBAL=true
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
	filename="$1"
	backup_filename="$2"
	if [ ! -f $backup_filename ]; then 
		if [ -f $filename ]; then 
			sudo mv $filename $backup_filename
		fi
	else
		return 1
	fi
	
}

if [ -f ./vimrc ]
then
	echo "backing up current vimrc's in .bak.name"
	if [[ $(backup /home/$USER/.vimrc /home/$USER/.bak.vimrc) == 1 && !$IGNORE_BACKUPS ]]
	then
		echo "Backup files already exist, exitting"
		exit 1
	fi
	if [[ $GLOBAL ]]
	then
		if [[ $(backup /etc/vim/vimrc /etc/vim/.bak.vimrc) == 1 && !$IGNORE_BACKUPS ]]
		then
			echo "Backup files already exist, exitting"
			exit 1
		fi
	fi
	echo "copying files into place"
	ln -s $(pwd)/vimrc ~/.vimrc
	if [[ $GLOBAL ]]
	then
		sudo ln -s $(pwd)/vimrc /etc/vim/vimrc
	fi
	ls -al /home/$USER/.vimrc
	if [[ $GLOBAL ]]; then
		ls -al /etc/vim/vimrc
	fi
else 
	echo "please execute from within the directory (can't find vimrc)"
fi
