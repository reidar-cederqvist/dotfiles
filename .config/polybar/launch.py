#!/usr/bin/env python3
import time
import subprocess
import os

os.system("killall -q polybar")
os.system("sleep 1")
monitors = subprocess.run(["xrandr", "--listactivemonitors"], capture_output=True, text=True)
monitors = [ i[1:] for i in monitors.stdout.split() if i.startswith("+") ]

for monitor in monitors:
    if monitor.startswith("*"):
        monitor = monitor[1:]
        bar="main"
    else:
        bar="extra"

    os.system(f"MONITOR={monitor} polybar --reload {bar}  &")
