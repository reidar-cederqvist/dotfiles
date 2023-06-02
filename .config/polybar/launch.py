#!/usr/bin/env python3
import time
import subprocess
import os

# os.system(f"echo \"test\" >>/home/reidar/polybar.log")
time.sleep(2)
os.system("killall -q polybar")
# os.system(f"echo \"test2\" >>/home/reidar/polybar.log")
monitors = subprocess.run(["xrandr", "--listactivemonitors"], capture_output=True, text=True)
# os.system(f"echo \"{monitors.stdout}\" >>/home/reidar/polybar.log")
monitors = [ i[1:] for i in monitors.stdout.split() if i.startswith("+") ]

for monitor in monitors:
    # os.system(f"echo \"{monitor}\" >>/home/reidar/polybar.log")
    if monitor.startswith("*"):
        monitor = monitor[1:]
        bar="main"
    else:
        bar="extra"

    # os.system(f"echo \"{monitor} {bar}\" >>/home/reidar/polybar.log")
    os.system(f"MONITOR={monitor} polybar --reload {bar}  &")
