curl -s -X POST "https://api.telegram.org/bot"$1"/sendVideo" -F chat_id="$2" -F video="@$3" -F caption="$4"

