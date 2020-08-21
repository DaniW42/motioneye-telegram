# motioneye-telegram

### WORK IN PROGRESS! - Check every script twice

The project is based on motioneye by [ccrisan - github](https://github.com/ccrisan/motioneye/wiki/Installation)
motioneye-telegram checks wether your device is available in your WLAN or not and sends a message to your telegram-bot if motion was detected.
	
### Bot-Creation

##### create a new telegram-bot
*   look for @botfather in telegram and open the chat
*	enter the following command and follow the the @botfather for creation
    ```sh
    /newbot
    ```
*   write your HTTP APY KEY down 

##### privacy activation 
*   details can be found [here](https://core.telegram.org/bots#privacy-mode) nachsehen
*   enter the following command into telegram to use some more privacy  
    ```
    /setprivacy
    ```
	
##### more telegram commands:
*   you can enter these into telegram if you want
    ```
    /setdescription - changes the bot-description
	/setabouttext - changes the bot-about-description
	/setuserpic - changes the photo in your bot-profile
    ```

##### note your chat-id:
*   write to your telegram-bot - maybe twice (@<YOUR_BOT_USERNAME>)
*   open the link with your API KEY in it
    ```
    https://api.telegram.org/bot<ENTER_YOUR_COMPLETE_API_KEY>/getUpdates
    ```
*   browser output:
	```
	"message":{"message_id":1194,"from":{"id":<YOUR_CHAT_ID>,"is_bot":false,"first_name":"<YOUT_NAME>","username":"<YOUR_USER_NAME>","language_code":"de"}
	```
*   look for your chat-id and write it down


### installation of motioneye-telegram
*   go to your home directory on your raspberry pi
*   download all the files from github 
*   start the installion script
    ```
    ./install-tg.sh
    ```

### connecting with motioneye

*   look for your script path and enter it in motioneye ("run an end command" in "motion notification")
	e.g. ```bash /home/pi/motioneye-telegram/bint/motion-send.sh %$ %t```
*   ```%$``` important because it passes the camera name to the script
*   ```%t``` important because it passes the camera id to the script
	
