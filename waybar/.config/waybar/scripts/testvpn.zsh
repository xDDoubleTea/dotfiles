#!/usr/bin/zsh
if nmcli device status | grep -i japan >/dev/null; then
	echo {\"alt\": \"connected\", \"tooltip\": \"VPN is connected\"}
else
	echo {\"alt\": \"disconnected\", \"tooltip\": \"VPN is disconnected\"}
fi
exit 0
