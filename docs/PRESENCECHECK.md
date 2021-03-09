This is a very basic explanation and needs to be improved. even though it should answer some questions and solve problems.

#### So.. What is this "presencecheck" thing?

Imagine you are at home, moving in front of the camera and get a notification everytime you walk by. It will spam you to death...

We had the same problem and got very annoyed pretty fast. This is why we created the presencecheck. It will ping your personal devices, or even those of your beloved ones on a regular basis. As soon as a single ping is successful, presence check will update your telegram.conf. The variable var_deviceAvailable will be set to 'true' and the next time the script is called by motioneye it will check this particular variable and won't send you any message.

Sometimes your phone (or any other device) will leave your wifi coverage or loose connection. presencecheck will now push var_pingFail by 1. as soon as var_pingFail is 3 or higher, presencecheck will set var_deviceAvailable to 'false' and start sending you notifications (media files) again. As the cronjob is set to be run every minute (feel free to change this), you will get notified again, three minutes after you or your device left the wifi.

Some things to consider:
- your pi and your "ping-device" needs to be on the same network, or must be able to ping each other. (in most cases, it should be enough to be able to ping your "ping-device")
- some devices go to sleep after a while and won't answer to pings. you will obviously get messages again after this happens. we had some struggle to get around this, if you have any idea - feel free to get in contact with us or even create a pull request
- if you don't want to use this functionality, just leave ip adresses empty in the install script
- you could also fill in your loopback adress 127.0.0.1 to never get notified again
