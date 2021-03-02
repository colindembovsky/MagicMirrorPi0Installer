#!/bin/sh
export DISPLAY=:0
unclutter &
chromium-browser --start-fullscreen --noerrdialogs --incognito --kiosk http://localhost:8080