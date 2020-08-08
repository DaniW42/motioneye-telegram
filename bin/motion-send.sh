#!/bin/bash

## get my current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

## Read Configuration-File so we have the variables available
source $DIR/../telegram.conf

## Get the name of the camera which detected a motion (done by parameter %$ in motioneye webinterface command)
var_cameraName=$1

## Functions
func_writeLog () {
   printf "$1\n" >> $var_gitDir/motion-send.log
}

func_sendPhoto () {
   $var_gitDir/bin/tg-sendPhoto.py $var_botApiKey $var_chatId $1 $2
}

func_sendVideo () {
   $var_gitDir/bin/tg-sendVideo.py $var_botApiKey $var_chatId $1 $2
}

func_writeLog "========================================================="
func_writeLog "$(date) - MOTION DETECTED by Camera $var_cameraName."

if ping -c 3 -W 2 $var_pingAddress > /dev/null

then
	func_writeLog "$(date) - Device available, end script."
	func_writeLog "========================================================="
	func_writeLog ""
else
	func_writeLog "$(date) - Device NOT available, RUN script."

	lastsnap=$(tree -ftri "$var_mediaDir" | grep .jpg | head -n1)
	lastvideo=$(tree -ftri "$var_mediaDir" | grep -v thumb | grep .mp4 | head -n1)
	func_writeLog "$(date) - \$lastsnap is $lastsnap"
	func_writeLog "$(date) - \$lastvideo is $lastvideo"

	func_writeLog "$(date) - BEGIN tg-sendPhoto.py:"
	$var_gitDir/bin/tg-sendPhoto.py $var_botApiKey $var_chatId $lastsnap "$var_cameraName - ${lastsnap: -23:19}"
	func_writeLog "$(date) - BEGIN tg-sendVideo.py:"
	$var_gitDir/bin/tg-sendVideo.py $var_botApiKey $var_chatId $lastvideo "$var_cameraName - ${lastsnap: -23:19}"
	
	func_writeLog "========================================================="
	func_writeLog ""
fi

exit 0