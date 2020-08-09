#!/bin/bash

## get my current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

## Functions
func_getGitHubConf () {
	## Get fresh config file from github and save as...
	wget -q https://raw.githubusercontent.com/DaniW42/motioneye-telegram/master/telegram.conf.original -O $1
}

func_readLocalConf () {
	source $DIR/telegram.conf
}

## Read Configuration-File so we have the variables available
func_readLocalConf

## Clear Screen
printf "\033c\n"

printf '%s\n' ""
printf '%s\n' "################################################################################################"
printf '%s\n' "################################################################################################"
printf '%s\n' ""

## Check for config file, if not found wget it from github, if found check version and ask user to update
if [ ! -f "telegram.conf" ]
then
	printf '%s\n' "I was unable to find telegram.conf file!"
	printf '%s\n' "This is why I decided to get you a new one from github ;-)"
	func_getGitHubConf telegram.conf
	func_readLocalConf
else
	printf '%s\n' "Found telegram.conf, checking version."
	var_GitConfVersion="$(curl --silent https://raw.githubusercontent.com/DaniW42/motioneye-telegram/master/telegram.conf.original | grep ConfVersion | cut -d '=' -f 2)"
	if [[ "$var_GitConfVersion" == "$var_ConfVersion" ]]
	then
		printf '%s\n' "- Local Config-File Version matches GitHub Version, nothing to update."
	else
		printf '%s\n' "- Config-File Version mismatch, local version: $var_ConfVersion => GitHub version: $var_GitConfVersion."
		printf '%s\n' "- So we have to update your config file. If you want to do this now we have to go through the 'whole process'."
		printf '%s\n' ""
		
		var_defaultNewConf="y"
		read -p "Create new telegram.conf? [Y/n]: " var_NewConf
		: ${var_NewConf:=$var_defaultNewConf}

		## [y] create new config file or [n] simply quit.
		if [ $var_NewConf = "n" ]
		then
			printf '%s\n' "You selected to not create an updated config file now."
			printf '%s\n' "That is Ok, but you have to download it or make yours to work on your own. See ya!"
			exit 1
		else
			printf '%s\n' "Ok, getting clean config file from GitHub and start to process values from 'old' config."
			func_getGitHubConf telegram.conf
		fi
	fi
fi

## Check if var_botApiKey is set in config, if not fill with example
if [ -n "$var_botApiKey" ]
then
	var_TEMPbotApiKey=$var_botApiKey
	printf '%s\n' "- Looks good, I found an HTTP API Token."
else
	var_TEMPbotApiKey="eg. 123456:ABCDEF1234ghIklzyx57W2v1u123ew11"
	printf '%s\n' "- Unfortunately, no HTTP API Token was found."
	printf '%s\n' "  Please get one by following the tutorial."
fi

## Check if var_chatId is set in config, if not fill with example
if [ -n "$var_chatId" ]
then
    var_TEMPchatId=$var_chatId
	printf '%s\n' "- I found something that could be a Chat_id."
else
    var_TEMPchatId="eg. 321654987"
	printf '%s\n' "- No Chat_id was found."
	printf '%s\n' "  Please get one by following the tutorial."
fi

printf '%s\n' ""
printf '%s\n' "Let's see if we can send a test message to your Telegram."
printf '%s\n' "Therefor we will check the values above. Values in brackets are either yours or examples."
printf '%s\n' "If you just press enter, it will accepte the value in the brackets."
printf '%s\n' ""

## loop until the user has entered a HTTP API Token
while [ "$var_TEMPbotApiKey" = "eg. 123456:ABCDEF1234ghIklzyx57W2v1u123ew11" ]
do
	defaultapi=$var_TEMPbotApiKey
	read -p "Enter your HTTP API Token [$defaultapi]: " var_TEMPbotApiKey
	: ${var_TEMPbotApiKey:=$defaultapi}
done
printf '%s\n' "Will use: <$var_TEMPbotApiKey> as HTTP API Token."

## loop until user has entered a chat_id
while [ "$var_TEMPchatId" = "eg. 321654987" ]
do
	defaultid=$var_TEMPchatId
	read -p "Enter your Chat_id [$defaultid]: " var_TEMPchatId
	: ${var_TEMPchatId:=$defaultid}
done
printf '%s\n' "Will use: <$var_TEMPchatId> as Chat_id."

## send test message to the user
curl -s -X POST \
     -H 'Content-Type: application/json' \
     -d '{"chat_id": '$var_TEMPchatId', "text": "This is a test from you Raspberry Pi", "disable_notification": true}' \
     https://api.telegram.org/bot$var_TEMPbotApiKey/sendMessage > /dev/null

printf '%s\n' "You should have recieved a test message in Telegram."

## ask user if we should save the variables to the config file
var_defaultSave="y"
read -p "Save your HTTP API Token and Chat_id to your telegram.conf? [Y/n]: " var_confSave
: ${var_confSave:=$var_defaultSave}

## [y] save the variables to the config file or [n] simply quit
if [ $var_confSave = "y" ]
then
	printf '%s\n' "Ok, saving current configuration, bye."
	sed -i "s/var_botApiKey=.*$/var_botApiKey='$var_TEMPbotApiKey'/" telegram.conf
	sed -i "s/var_chatId=.*$/var_chatId='$var_TEMPchatId'/" telegram.conf
	sed -i "s/LastConfigSave=.*$/LastConfigSave='$(date)'/" telegram.conf
elif [ $var_confSave = "n" ]
then
	printf '%s\n' "Ok, not saving current configuration."
else
	printf '%s\n' "Something went wrong!"
fi


printf '%s\n' ""
printf '%s\n' "################################################################################################"
printf '%s\n' "################################################################################################"
printf '%s\n' ""

exit 0