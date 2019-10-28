#!/bin/sh

sudo systemctl stop NetworkManager
sudo mmcli -G DEBUG # set logging level
mmcli -M & # search for modems in background
PID=$! # get process if for modem search
sleep 2 # wait for 2 seconds
kill $PID # kill the modem search
modem_idx=$(mmcli -L | grep Modem | python modem_index.py) # get the index of the modem that was found
if [ $modem_idx = "101" || $modem_idx = "102" ]