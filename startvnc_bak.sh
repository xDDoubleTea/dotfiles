export WLR_BACKENDS=headless
export WLR_LIBINPUT_NO_DEVICES=1
export WAYLAND_DISPLAY=wayland-1
wayvnc -v -r -p 0.0.0.0 5901
