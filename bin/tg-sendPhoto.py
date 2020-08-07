curl -s -X POST "https://api.telegram.org/bot"$1"/sendPhoto" -F chat_id="$2" -F photo="@$3" -F caption="$4"

