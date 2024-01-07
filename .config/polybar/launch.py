#!/usr/bin/env python3
import time
import subprocess
import os

os.system("killall -q polybar")
os.system("sleep 1")

ls_p = subprocess.Popen(["xrandr"], stdout=subprocess.PIPE, text=True)
grep_p = subprocess.Popen(["grep", " conn"], stdin=ls_p.stdout, stdout=subprocess.PIPE, text=True)
lines, error = grep_p.communicate()

def get_monitors(line):
    items = line.split()
    if len(items) < 3:
        return
    monitor=items[0]
    print("test")
    if items[2] == "primary":
        return "*"+items[0]
    else:
        return items[0]

monitors = []
for line in lines.split("\n"):
    res = get_monitors(line)
    if res:
        monitors.append(res)



for monitor in monitors:
    if monitor.startswith("*"):
        monitor = monitor[1:]
        bar="main"
    else:
        bar="extra"

    os.system(f"MONITOR={monitor} polybar --reload {bar}  &")
