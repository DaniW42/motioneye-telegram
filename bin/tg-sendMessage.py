curl -s -X POST "https://api.telegram.org/bot"$1"/sendMessage" -F chat_id="$2" -F text="$3"
