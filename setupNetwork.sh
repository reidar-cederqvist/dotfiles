#!/bin/bash

vconfig add enp5s0 400
vconfig add enp5s0 401
vconfig add enp5s0 402
ip link set enp5s0.400 up
dhclient enp5s0.400
