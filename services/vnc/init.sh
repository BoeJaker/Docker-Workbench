#!/bin/bash

# Start VNC server
vncserver "$DISPLAY" -geometry 1280x720 -depth ${DEPTH}

# Start Fluxbox window manager
fluxbox &

# ./switch_display.sh

# Keep the container running
tail -f /dev/null