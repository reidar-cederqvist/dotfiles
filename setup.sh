#!/usr/bin/expect
set timeout 30
spawn sh /home/reidar/gs.sh
expect "Password"
send "<passwd here>\r"
interact
