# motioneye-telegram

### WORK IN PROGRESS! - Check every script twice

The project is based on motioneye by [ccrisan - github](https://github.com/ccrisan/motioneye/wiki/Installation)
motioneye-telegram checks whether your device is available in your wifi or not and sends a message to your telegram-bot if motion was detected.

### Bot-Creation

##### create a new telegram-bot
*   look for [@botfather](https://t.me/botfather) in telegram and open a chat
*	enter the following command and follow the the wizard for creation
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


### installation of motioneye-telegram
*   go to your home directory on your raspberry pi
*   download all the files from github 
    ```sh
    git clone https://github.com/DaniW42/motioneye-telegram.git
    ```
*   start the installation script
    ```sh
    cd motioneye-telegram
    ./install-tg.sh
    ```

### using motioneye-telegram as motioneye notification 

*   look for your script path and enter it in motioneye ("run an end command" in "motion notification")
	e.g. ```/home/pi/motioneye-telegram/bin/motion-send.sh %$ %t```
*   ```%$``` important because it passes the camera name to the script
*   ```%t``` important because it passes the camera id to the script
