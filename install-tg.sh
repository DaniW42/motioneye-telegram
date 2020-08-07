#!/bin/bash

## Clear Screen
printf "\033c"

## Check for config, if not found wget it from github
if [ ! -f "telegram.conf" ]
then
	echo "I was unable to find telegram.conf file!"
	echo "This is why I decided to get you a new one from github ;-)"
	wget -q https://raw.githubusercontent.com/DaniW42/motioneye-telegram/master/telegram.conf.original?token=AFA6X6Q435L26KBKXPFJHA27FVXFK -O telegram.conf
else
	printf "Found telegram.conf\n"
fi

## Read Configuration-File so we have the variables available
printf "Now reading telegram.conf..."
. telegram.conf

printf "\n\n"
printf "################################################################################################\n"
printf "################################################################################################\n"
printf "\n"
printf "Let's start by checking if there is an valid telegram.conf file available...\n"

## Check if var_botApiKey is set in config, if not fill with example
if [ -n "$var_botApiKey" ]
then
	var_TEMPbotApiKey=$var_botApiKey
	printf '%s\n' "- Looks good, I found an HTTP API Token."
else
	var_TEMPbotApiKey="eg. 123456:ABCDEF1234ghIklzyx57W2v1u123ew11"
	printf '%s\n' "- Unfortunately, no HTTP API Token was found."
	printf "  Please get one by following the tutorial.\n"
fi

## Check if var_chatId is set in config, if not fill with example
if [ -n "$var_chatId" ]
then
    var_TEMPchatId=$var_chatId
	printf '%s\n' "- I found something that could be a Chat_id."
else
    var_TEMPchatId="eg. 321654987"
	printf '%s\n' "- No Chat_id was found."
	printf "  Please get one by following the tutorial.\n"
fi

printf "\n"
printf "Let's see if we can send a test message to your Telegram.\n"
printf "Therefor we will check the values above. Values in brackets are either yours or examples.\n"
printf "If you just press enter, it will accepte the value in the brackets.\n"
printf "\n"

## loop until the user has entered a HTTP API Token
while [ "$var_TEMPbotApiKey" = "eg. 123456:ABCDEF1234ghIklzyx57W2v1u123ew11" ]
do
	defaultapi=$var_TEMPbotApiKey
	read -p "Enter your HTTP API Token [$defaultapi]: " var_TEMPbotApiKey
	: ${var_TEMPbotApiKey:=$defaultapi}
done
echo "Will use: <$var_TEMPbotApiKey> as HTTP API Token."

## loop until user has entered a chat_id
while [ "$var_TEMPchatId" = "eg. 321654987" ]
do
	defaultid=$var_TEMPchatId
	read -p "Enter your Chat_id [$defaultid]: " var_TEMPchatId
	: ${var_TEMPchatId:=$defaultid}
done
echo "Will use: <$var_TEMPchatId> as Chat_id."

## send test message to the user
curl -s -X POST \
     -H 'Content-Type: application/json' \
     -d '{"chat_id": '$var_TEMPchatId', "text": "This is a test from you Raspberry Pi", "disable_notification": true}' \
     https://api.telegram.org/bot$var_TEMPbotApiKey/sendMessage > /dev/null

echo "You should have recieved a test message in Telegram."

## ask user if we should save the variables to the config file
var_defaultSave="y"
read -p "Save your HTTP API Token and Chat_id to your telegram.conf? [Y/n]: " var_confSave
: ${var_confSave:=$var_defaultSave}

## [y] save the variables to the config file or [n] simply quit
if [ $var_confSave = "y" ]
then
	sed -i "s/var_botApiKey=.*$/var_botApiKey='$var_TEMPbotApiKey'/" telegram.conf
	sed -i "s/var_chatId=.*$/var_chatId='$var_TEMPchatId'/" telegram.conf
	sed -i "s/LastConfigSave=.*$/LastConfigSave='$(date)'/" telegram.conf
elif [ $var_confSave = "n" ]
then
	echo "Ok, not saving current configuration."
else
	echo "Something went wrong!"
fi


printf "\n\n"
printf "################################################################################################\n"
printf "################################################################################################\n"
printf "\n"

exit 0

## For further tests by sending an picture file
#wget -q https://upload.wikimedia.org/wikipedia/commons/1/13/Red_squirrel_%28Sciurus_vulgaris%29.jpg -O /tmp/oachkatzl.jpg