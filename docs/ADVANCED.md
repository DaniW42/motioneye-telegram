### Advanced message relaying with [integromat.com](https://www.integromat.com/?pc=motioneyetelegram)

![Header Image](/assets/integromatcom-scenario.png)

For a more advanced usage of the motion notification you could also use integromat using a webhook. This way you could for example:

*    send a photo or video file to google drive, onedrive etc.
*    send a notification to your browser using pushbullet
*    send a photo or video file via email

You could also seperate the messages being sent by splitting them up. For example:

*    send notification message to pushbullet and telegram,
*    send a picture via email and
*    save the video file to google drive, onedrive etc.

By using the router you could try to eg. only send pushbullet notifications during working hours or do a lot of other conditional stuff.
Integromat offers different plans, the free version is fine if you only send notifications and a few pictures or small videos. It allows up to 5MB/100MB per file/in total per month.

To use these methods you have to become familiar with integromat and follow the steps below. The integromat links provided are afiliate links, by using them you support the development of motioneye-telegram. If you do not want to support us you could simply go to integromat.com and follow the manual as usual.

#### 1. customize integromat scenario
*    create an account at [integromat.com](https://www.integromat.com/?pc=motioneyetelegram)
*    create a new scenario and add/connect the services you want to use.
![Webhhok Image](/assets/integromatcom-webhook.png)

#### 2. edit [tg-sendPhoto.py](bin/tg-sendPhoto.py) and [tg-sendVideo.py](bin/tg-sendVideo.py)

in motion-send.sh replace
````diff
-curl -s -X POST "https://api.telegram.org/bot"$1"/sendPhoto" -F chat_id="$2" -F photo="@$3" -F caption="$4"
+curl -s -X POST "WEBHOOK URL HERE" -F photo="@$3" -F caption="$4"
````
in motion-send.sh replace
````diff
-curl -s -X POST "https://api.telegram.org/bot"$1"/sendVideo" -F chat_id="$2" -F video="@$3" -F caption="$4"
+curl -s -X POST "WEBHOOK URL HERE" -F video="@$3" -F caption="$4"
````

Please note: As soon as you update motioneye-telegram via git pull or install-tg.sh your changes are gone and you have to re-do step 2.

#### 3. test your scenario

*    after configuring your webhook and editing the tg-send* files click on "Re-determine the data structure"
*    now force motioneye to run motioneye-telegram. as soon as the script runs integromat will get the data structure.
*    next configure your actions by adding eg. telegram, email, pushbullet etc. you will see the date types which are sent by motioneye-telegram.

Telegram             |  Google Drive
:-------------------------:|:-------------------------:
![Webhhok Image](/assets/integromatcom-telegram.png)  |  ![Webhhok Image](/assets/integromatcom-googledrive.png)
