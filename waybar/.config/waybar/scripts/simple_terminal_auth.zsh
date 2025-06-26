#!/usr/bin/zsh

echo "Toggling VPN..."
echo "You have to enter your password to toggle the VPN, continue? [y/N]"
read -r answer
if [[ ! "$answer" =~ ^[Yy]$ ]]; then
  echo "Aborting..."
  sleep 1
  exit 1
fi

