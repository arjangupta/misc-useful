#!/bin/sh

modem_idx=101 #global var for modem index

modem_search() {
    mmcli -M & # search for modems in background
    PID=$! # get process if for modem search
    sleep $1 # wait for given number of seconds
    kill $PID # kill the modem search

    modem_idx=$(mmcli -L | grep Modem | python3 get_mmcli_index.py) # get the index of the modem that was found
}

modem_network_interface=$(ip addr | grep wwan0)

if [ -z $modem_network_interface ]
then
    echo "wwan0 network interface was not found."
    return 102
fi

sudo systemctl stop NetworkManager # stop the NetworkManager service

sudo mmcli -G DEBUG # set logging level

modem_search 3

# check modem index, retry if failed
loop_idx=0
while [ $modem_idx = "101" || $modem_idx = "102" &&  loop_idx -lt 3 ]
do
    echo "No valid modem path found, will retry 3 times. Retry #$(($loop_index+1))..."
    modem_search 30
    loop_index=$(($loop_index+1))
done

# check modem index a final time
if [ $modem_idx = "101" || $modem_idx = "102" ]
then
    echo "No valid modem path found, quitting."
    return 100
fi

sudo mmcli -m $modem_idx -e # enable the detected modem
sudo mmcli -m $modem_idx --simple-connect="apn=intelli.gw10.vzwentp" # connect to our APN

bearer_idx=$(mmcli -m $modem_idx | grep Bearer | python3 get_mmcli_index.py -b) # get the index of the bearer that was found

# check output
if [ $bearer_idx = "101" || $bearer_idx = "102" ]
then
    echo "No valid bearer path found, simple connect probably failed"
    return 101
fi

# take note of ipv4 config
ip_address=$(mmcli -m $modem_idx -b $bearer_idx | grep address | python get_ip_config_param.py address)
network_prefix=$(mmcli -m $modem_idx -b $bearer_idx | grep prefix | python get_ip_config_param.py prefix)
default_gateway=$(mmcli -m $modem_idx -b $bearer_idx | grep gateway | python get_ip_config_param.py gateway)
dns_server=$(mmcli -m $modem_idx -b $bearer_idx | grep dns | python get_ip_config_param.py dns)