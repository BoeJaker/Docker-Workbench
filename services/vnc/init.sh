#!/bin/bash

# Start VNC server
vncserver "$DISPLAY" -geometry ${DIMENSIONS} -depth ${DEPTH}

# Start Fluxbox window manager
fluxbox &

./switch_display.sh

# Keep the container running
tail -f /dev/null