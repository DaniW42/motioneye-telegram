#!/bin/bash

## Get the name of the camera which detected a motion (done by parameter %$ in motioneye webinterface command)
var_cameraName=$1

## Get the id of the camera which detected a motion (done by parameter %t in motioneye webinterface command)
var_cameraId=$2

var_forceSend='false'
[[ $@ == *"force"* ]] && var_forceSend="true"

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

func_sendMessage () {
## Currently not used
   curl -s -X POST "https://api.telegram.org/bot"$var_botApiKey"/sendMessage" -F chat_id="$var_chatId" -F text="$1" | tee -a $var_projectDir/motion-send.log
}

func_sendPhoto () {
   curl -s -X POST "https://api.telegram.org/bot"$var_botApiKey"/sendPhoto" -F chat_id="$var_chatId" -F photo="@$1" -F caption="$2" | tee -a $var_projectDir/motion-send.log
}

func_sendVideo () {
   curl -s -X POST "https://api.telegram.org/bot"$var_botApiKey"/sendVideo" -F chat_id="$var_chatId" -F video="@$1" -F caption="$2" | tee -a $var_projectDir/motion-send.log
}

func_checkForceSendTrue () {
    [ $var_forceSend == "true" ] && var_deviceAvailable="false"
}

func_createSnapArray () {
    i = 0
    while read line
    do
        snapArray[ $i ]="$line"
        (( i++ ))
    done < <(tree -ftri "$var_mediaCameraDir" | grep .jpg | head -n"$var_picCount")
}


func_writeLog "========================================================="
func_writeLog "$(date) - MOTION DETECTED by Camera $var_cameraName."

func_checkForceSendTrue

if $var_deviceAvailable -eq "true" 

then
	func_writeLog "$(date) - Device available, end script."
	func_writeLog "========================================================="
	func_writeLog ""
else
	func_writeLog "$(date) - Device NOT available, RUN script."

	lastvideo=$(tree -ftri "$var_mediaCameraDir" | grep -v thumb | grep .mp4 | head -n1)
        func_writeLog "$(date) - \$lastvideo is $lastvideo"
        func_writeLog "$(date) - BEGIN sendVideo:"
        func_sendVideo $lastvideo "$var_cameraName - ${lastsnap: -23:19}"

        func_createSnapArray
        j=0
        for i in "${snapArray[@]}"
        do
                func_writeLog "$(date) - snap is ${snapArray[$j]}"
                func_writeLog "$(date) - BEGIN sendPhoto:"
                var_tmp="${snapArray[$j]}"
                func_sendPhoto $i "$var_cameraName - ${var_tmp: -23:19}"
        done

	func_writeLog "========================================================="
	func_writeLog ""
fi

exit 0
