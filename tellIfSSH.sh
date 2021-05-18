#! /bin/zsh

command="ss | grep ssh"

eval $command

if [[ $(eval $command) ]] then 
	echo SSH is connected
	notify-send "SSH is connected"
else
	echo SSH not detected
	notify-send "SSH is not connected"
fi
