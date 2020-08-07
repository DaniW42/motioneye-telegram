# motioneye-telegram - WORK IN PROGRESS! DO NOT RUN ANY SCRIPTS WITHOUT CHECKING TWICE (or more...)

@botfather

### Neuen Bot erstellen

    /newbot

"token to access the HTTP API" wird angezeigt --> sichern!

#### Privacy aktivieren (https://core.telegram.org/bots#privacy-mode)
    /setprivacy

### Optionale Befehle:
    /setdescription - change bot description
    /setabouttext - change bot about info
    /setuserpic - change bot profile photo

### Chat_id herausfinden:
Eigenen Bot in Telegram anschreiben (@username)

[https://api.telegram.org/bot<hier api token komplett einfügen>/getUpdates](https://api.telegram.org/bot%3Chier%20api%20token%20komplett%20einf%C3%BCgen%3E/getUpdates) aufrufen

#### Ausgabe im Browser:
"message":{"message_id":1194,"from":{"id":## HIER STEHT DIE CHAT_ID ##,"is_bot":false,"first_name":"## hier steht der name ##","username":"## hier steht der username ##","language_code":"de"}

### Jetzt auf dem pi install-tg.sh ausführen
