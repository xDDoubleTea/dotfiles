#!/usr/bin/python3
import sys
import subprocess


def main():
    mode = input("Select a mode (video, audio), aliases = (v, a)\n")

    if mode == "video":
        mode = "v"
    elif mode == "audio":
        mode = "a"
    elif mode not in ["v", "a"]:
        print("Invalid mode selected. Exiting.")
        sys.exit(1)
    mode_config = {"v": "video.txt", "a": "audio.txt"}

    url = input("Input the url\n")
    cmd = [
        "yt-dlp",
        "--config-locations",
        f"/home/susamogus/.config/yt-dlp/{mode_config[mode]}",
        url,
    ]
    subprocess.run(cmd)


if __name__ == "__main__":
    main()
