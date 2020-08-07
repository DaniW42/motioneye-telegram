#!/bin/bash

## Read Configuration-File so we have the variables available
source ../telegram.conf

printf "=========================================================\n" >> $var_gitDir/motion-send.log
printf "$(date) - MOTION DETECTED.\n" >> $var_gitDir/motion-send.log

if ping -c 3 -W 2 $var_pingAddress > /dev/null

then
	printf "$(date) - Device available, end script.\n" >> $var_gitDir/motion-send.log
	printf "=========================================================\n" >> $var_gitDir/motion-send.log
	printf " \n" >> $var_gitDir/motion-send.log
else
	printf "$(date) - Device NOT available, RUN script.\n" >> $var_gitDir/motion-send.log

	lastsnap=$(tree -ftri "$var_mediaDir" | grep .jpg | head -n1)
	lastvideo=$(tree -ftri "$var_mediaDir" | grep -v thumb | grep .mp4 | head -n1)

	printf "$(date) - \$lastsnap is $lastsnap\n" >> $var_gitDir/motion-send.log
	printf "$(date) - \$lastvideo is $lastvideo\n" >> $var_gitDir/motion-send.log

	printf "$(date) - BEGIN tg-sendphoto.py:\n" >> $var_gitDir/motion-send.log
	printf " \n" >> $var_gitDir/motion-send.log
	$var_gitDir/bin/tg-sendPhoto.py $var_botApiKey $var_chatId $lastsnap "Bewegung erkannt! - ${lastsnap: -23:19}" >> $var_gitDir/motion-send.log
	printf " \n" >> $var_gitDir/motion-send.log
	printf " \n" >> $var_gitDir/motion-send.log
	printf "$(date) - END tg-sendphoto.py.\n" >> $var_gitDir/motion-send.log

	printf "$(date) - BEGIN tg-sendVideo.py:\n" >> $var_gitDir/motion-send.log
	printf " \n" >> $var_gitDir/motion-send.log
	$var_gitDir/bin/tg-sendVideo.py $var_botApiKey $var_chatId $lastvideo "Bewegung erkannt! - ${lastvideo: -23:19}" >> $var_gitDir/motion-send.log
	printf " \n" >> $var_gitDir/motion-send.log
	printf " \n" >> $var_gitDir/motion-send.log
	printf "$(date) - END tg-sendVideo.py.\n" >> $var_gitDir/motion-send.log

	printf "=========================================================\n" >> $var_gitDir/motion-send.log
	printf " \n" >> $var_gitDir/motion-send.log
fi
