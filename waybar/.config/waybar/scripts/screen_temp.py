#!/usr/bin/python
from datetime import datetime, timedelta
import subprocess
import re
import json
import os

stdout = subprocess.run(["daylight", "--short"], check=True, capture_output=True).stdout
stdout_str = stdout.decode()
sunrisetime_str, sunsettime_str = re.findall(r"\d+:\d+", stdout_str)

current_time = datetime.strptime(datetime.now().strftime("%H:%M"), "%H:%M")
# current_time = datetime.strptime("22:00", "%H:%M")
sunrisetime = datetime.strptime(sunrisetime_str, "%H:%M")
sunsettime = datetime.strptime(sunsettime_str, "%H:%M")

to_sunset = sunsettime - current_time
from_sunrise = sunrisetime - current_time

delta_t = timedelta(seconds=0)

daytime_temp = ["identity"]
nighttime_temp = ["temperature", "4500"]
temp_conf = {"day": daytime_temp, "night": nighttime_temp}

home_dir = os.getenv("HOME")


def set_screen_temp(temp: str):
    with open(f"{home_dir}/.config/waybar/scripts/last_screen_temp.txt", "r") as f:
        state = f.readlines()[0].rstrip("\n")
        if state == temp:
            return
    with open(f"{home_dir}/.config/waybar/scripts/last_screen_temp.txt", "w") as f:
        subprocess.run(
            ["hyprctl", "hyprsunset"] + temp_conf[temp], check=True, capture_output=True
        )
        f.write(temp)


if to_sunset >= delta_t and from_sunrise < delta_t:
    set_screen_temp("day")
    print(json.dumps({"text": " ", "tooltip": "Day time"}))
else:
    set_screen_temp("night")
    print(json.dumps({"text": "󰖔 ", "tooltip": "Night time"}))
