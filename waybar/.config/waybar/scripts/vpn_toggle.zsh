#!/usr/bin/zsh

# ~/.config/waybar/scripts/simple_terminal_auth.zsh
# if [[ $? -ne 0 ]]; then
#   exit 1
# fi

if nmcli device status | grep -i japan >/dev/null; then
  nmcli connection down japan
else
  nmcli connection up japan
fi
echo "Done!"
sleep 1
exit 0
