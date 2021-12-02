#!/usr/bin/env bash

# We are going to wait for the UNIX socket to be mounted before trying to start the application. This will prevent us from going into a crash loop before xserver is ready. See more info here: https://github.com/balenablocks/xserver#waiting-for-xserver-to-start
while [ ! -e /tmp/.X11-unix/X${DISPLAY#*:} ]; do sleep 0.5; done

# Run balena base image entrypoint script. We also specified UDEV=1 in the Dockerfile. This will allow udev devices (mouse, etc) to be mounted
/usr/bin/entry.sh echo "Running balena base image entrypoint..."

# This stops the CPU performance scaling down
echo "Setting CPU Scaling Governor to 'performance'"
echo 'performance' > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 

# We are using root to run --no-sandbox for chrome, partially because of this issue: https://github.com/electron/electron/issues/17972

/opt/node_modules/.bin/electron --no-sandbox /opt/index.js
