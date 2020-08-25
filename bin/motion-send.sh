#!/bin/bash

## Get the name of the camera which detected a motion (done by parameter %$ in motioneye webinterface command)
var_cameraName=$1

## Get the id of the camera which detected a motion (done by parameter %t in motioneye webinterface command)
var_cameraId=$2

## get my current directory
var_binDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

## Get the name of the motioneye-telegram project directory
var_projectDir="$var_binDir"/..

var_mediaDir="$(dirname $(grep target_dir /etc/motioneye/camera-$var_cameraId.conf | cut -d ' ' -f 2))"
var_mediaCameraDir="$var_mediaDir/$var_cameraName"

## Read Configuration-File so we have the variables available
source $var_projectDir/telegram.conf

## Functions
func_writeLog () {
   printf "$1\n" >> $var_projectDir/motion-send.log
}

func_sendPhoto () {
   $var_binDir/tg-sendPhoto.py $var_botApiKey $var_chatId $1 $2
}

func_sendVideo () {
   $var_binDir/tg-sendVideo.py $var_botApiKey $var_chatId $1 $2
}

func_writeLog "========================================================="
func_writeLog "$(date) - MOTION DETECTED by Camera $var_cameraName."

if $var_deviceAvailable -eq "true"

then
	func_writeLog "$(date) - Device available, end script."
	func_writeLog "========================================================="
	func_writeLog ""
else
	func_writeLog "$(date) - Device NOT available, RUN script."

	lastsnap=$(tree -ftri "$var_mediaCameraDir" | grep .jpg | head -n1)
	lastvideo=$(tree -ftri "$var_mediaCameraDir" | grep -v thumb | grep .mp4 | head -n1)
	func_writeLog "$(date) - \$lastsnap is $lastsnap"
	func_writeLog "$(date) - \$lastvideo is $lastvideo"

	func_writeLog "$(date) - BEGIN tg-sendPhoto.py:"
	$var_binDir/tg-sendPhoto.py $var_botApiKey $var_chatId $lastsnap "$var_cameraName - ${lastsnap: -23:19}"
	func_writeLog "$(date) - BEGIN tg-sendVideo.py:"
	$var_binDir/tg-sendVideo.py $var_botApiKey $var_chatId $lastvideo "$var_cameraName - ${lastsnap: -23:19}"

	func_writeLog "========================================================="
	func_writeLog ""
fi

exit 0
