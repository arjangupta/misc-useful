#!/bin/sh

sudo systemctl stop NetworkManager # stop the NetworkManager service

sudo mmcli -G DEBUG # set logging level

mmcli -M & # search for modems in background
PID=$! # get process if for modem search
sleep 2 # wait for 2 seconds
kill $PID # kill the modem search

modem_idx=$(mmcli -L | grep Modem | python get_mmcli_index.py) # get the index of the modem that was found

if [$modem_idx = "101" || $modem_idx = "102"]
then
    echo "No valid modem path found"
    return 100
fi

sudo mmcli -m $modem_idx -e # enable the detected modem
sudo mmcli -m $modem_idx --simple-connect="apn=intelli.gw10.vzwentp" # connect to our APN

bearer_idx=$(mmcli -m $modem_idx | grep Bearer | python get_mmcli_index.py -b)

if [$bearer_idx = "101" || $bearer_idx = "102"]
then
    echo "No valid bearer path found"
    return 100
fi