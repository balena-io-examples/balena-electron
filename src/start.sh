#!/usr/bin/env bash

# Run balena base image entrypoint script. This will allow udev devices (mouse, etc) to be mounted
/usr/bin/entry.sh echo "Running balena base image entrypoint..."

# This stops the CPU performance scaling down
echo "Setting CPU Scaling Governor to 'performance'"
echo 'performance' > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 

# We are using root to run --no-sandbox for chrome, partially because of this issue: https://github.com/electron/electron/issues/17972

/opt/node_modules/.bin/electron --no-sandbox /opt/index.js
