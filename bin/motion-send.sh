#!/bin/bash
printf "=========================================================\n" >> /home/pi/motion-send.log
printf "$(date) - MOTION DETECTED.\n" >> /home/pi/motion-send.log

if ping -c 3 -W 1000 192.168.0.210 > /dev/null

then
	printf "$(date) - OP6T available, end script.\n" >> /home/pi/motion-send.log
	printf "=========================================================\n" >> /home/pi/motion-send.log
	printf " \n" >> /home/pi/motion-send.log
else
	printf "$(date) - OP6T NOT available, RUN script.\n" >> /home/pi/motion-send.log

	lastsnap=$(tree -ftri /mnt/hdd/shared/motioneye/ | grep .jpg | head -n1)
	lastvideo=$(tree -ftri /mnt/hdd/shared/motioneye/ | grep -v thumb | grep .mp4 | head -n1)

	printf "$(date) - \$lastsnap is $lastsnap\n" >> /home/pi/motion-send.log
	printf "$(date) - \$lastvideo is $lastvideo\n" >> /home/pi/motion-send.log
	printf "$(date) - BEGIN tg-sendphoto.py:\n" >> /home/pi/motion-send.log
	printf " \n" >> /home/pi/motion-send.log

	/bin/tg-sendPhoto.py $lastsnap "Bewegung erkannt! - ${lastsnap: -23:19}" >> /home/pi/motion-send.log
	/bin/tg-sendVideo.py $lastvideo "Bewegung erkannt! - ${lastvideo: -23:19}" >> /home/pi/motion-send.log

	printf " \n" >> /home/pi/motion-send.log
	printf " \n" >> /home/pi/motion-send.log
	printf "$(date) - END tg-sendphoto.py.\n" >> /home/pi/motion-send.log
	printf "=========================================================\n" >> /home/pi/motion-send.log
	printf " \n" >> /home/pi/motion-send.log
fi
