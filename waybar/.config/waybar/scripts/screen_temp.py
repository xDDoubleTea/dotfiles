#!/usr/bin/python
from datetime import datetime, timedelta
import subprocess
import re
import json

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

daytime_temp = "identity"
nighttime_temp = "4500"

if to_sunset >= delta_t and from_sunrise < delta_t:
    # subprocess.run(
    #     ["hyprctl", "hyprsunset", daytime_temp], check=True, capture_output=True
    # )
    print(json.dumps({"text": " ", "tooltip": "Day time"}))
else:
    subprocess.run(
        ["hyprctl", "hyprsunset", "temperature", nighttime_temp],
        check=True,
        capture_output=True,
    )
    print(json.dumps({"text": "󰖔 ", "tooltip": "Night time"}))
