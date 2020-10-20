![Header Image](/assets/repository-open-graph.png)

# motioneye-telegram

### Contribute! :heart:
We noticed that people are really using motioneye-telegram, that is awesome. If you encounter any problems or can't find something you are searching for, feel free to contact us (of course) via [Telegram](https://t.me/daniw42) or by adding an [issue](https://github.com/DaniW42/motioneye-telegram/issues). Any ideas are welcome!

### WORK IN PROGRESS! - Check every script twice

The project is based on motioneye by [ccrisan - github](https://github.com/ccrisan/motioneye/wiki/Installation)
motioneye-telegram checks whether your device is available in your wifi or not and sends a message to your telegram-bot if motion was detected.

### Features
*   send latest snapshot and video via telegram
*   presence-check (you are not at home by pinging one or more eg. smartphones)
*   no port forwardings or open ports required (443 outbound must be possible)
*   no telegram-bot installation required
*   ! currently there are some problems with wifi-devices in energy saving mode, any help appreciated.

### Prerequisites

For these scripts to run, you have to ensure that your environment meets the follwing prerequisites:
*   Minimum, by motioneye supported, Raspberry Pi (SBC)
*   Raspberry Pi OS Version Buster (Debian 10)
*   latest [motioneye](https://github.com/ccrisan/motioneye/wiki/Installation) installed
*   tested with motion Version 4.2.2 and motionEye Version 0.42.1
*   somehow fixed IP Adress for your smartphone(s) or other devices

----------

### Bot-Creation

##### create a new telegram-bot
*   look for [@botfather](https://t.me/botfather) in telegram and open a chat
*	enter the following command and follow the wizard for creation
    ```
    /newbot
    ```
*   write down your HTTP API KEY 

##### get your chat-id:
*   start a conversation with [@jsondumpbot](https://t.me/jsondumpbot).
*   this will return a json-styled message to you which includes your chat-id:
*   for example:
    ````
    "chat": {
      "id": <your chat id, eg. 321654987>,
      (... some more content ...)
    },
    ````
*   take note of your chat-id and save it alongside your http api key

##### privacy activation 
*   details can be found [here](https://core.telegram.org/bots#privacy-mode)
*   send the following command to @botfather to use some more privacy  
    ```
    /setprivacy
    ```

##### more telegram commands:
*   you can enter these into telegram if you want to
    ```
    /setdescription - changes the bot-description
	/setabouttext - changes the bot-about-description
	/setuserpic - changes the photo in your bot-profile
    ```

----------

### installation of motioneye-telegram
*   go to your home directory on your raspberry pi
*   download all the files from github 
    ```sh
    git clone https://github.com/DaniW42/motioneye-telegram.git
    ```
*   install arping and tree
    ```sh
    sudo apt install -y arping tree
    ```
*   start the installation script
    ```sh
    cd motioneye-telegram
    ./install-tg.sh
    ```

##### install the cronjob for presence check
   to install the cronjob for presence check we have to run install-cron.sh as root (using sudo).
   
   as we should never run unknown scripts as root, we kindly invite you to take a sneek peak at [install-cron.sh](https://github.com/DaniW42/motioneye-telegram/blob/testing/install-cron.sh) before continuing.
   to install the cronjob (which runs [bin/presencecheck.sh](https://github.com/DaniW42/motioneye-telegram/blob/testing/bin/presencecheck.sh) every minute):
*   start the installation script and carefully read the instructions given
    ```sh
    sudo ./install-cron.sh
    ```

### using motioneye-telegram as motioneye notification 

*   look for your script path and enter it in motioneye ("run an end command" in "motion notification")
	e.g. ```/home/pi/motioneye-telegram/bin/motion-send.sh %$ %t```
*   ```%$``` important because it passes the camera name to the script
*   ```%t``` important because it passes the camera id to the script
