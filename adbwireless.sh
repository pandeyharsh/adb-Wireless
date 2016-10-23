#!/bin/bash

# port used to establish the TCP IP connection
PORT=5555

# number of android devices currently connected
NUM_DEVICES=$(($(adb devices -l | wc -l) - 2))

# displays a list of all currently connected devices
printDevices ()
{
	DEVICE_LIST=($(adb devices -l | grep "model" | cut -d':' -f 4 | sed 's/device//'))
	
	for ((i=0; i<$NUM_DEVICES; i++)); do
  		 echo -e "\t$(($i+1)) ${DEVICE_LIST[$i]}"
	done
}

# allows user to pick a device if multiple devices are connected
selectDevice ()
{
	while true; do
		read -p "Select a device[1-$NUM_DEVICES]: " SELECTION
		if [[ $SELECTION -gt 0 && $SELECTION -le NUM_DEVICES ]]
		then
			break
		elif [ "$SELECTION" == "e"  ]
		then
			exit			
		else
			echo "Please enter a number within range. Or enter 'e' to exit."
		fi
	done

	DEVICE_NAME=${DEVICE_LIST[(($SELECTION - 1))]}
	SERIAL_NO=`adb devices -l | grep "model:$DEVICE_NAME" | awk '{ print $1 }'`
}

# decide if you want to connect to the selected device
decide ()
{
	while true; do
    		read -p "Connect to $DEVICE_NAME [y/n]:" yn
    		case $yn in
        		[Yy]* ) connectDevice; exit;;
        		[Nn]* ) exit;;
        		* ) echo "Please answer yes or no.";;
    		esac
	done
}

# connect to the selected device
connectDevice ()
{
	IP_ADDRESS=`adb -s $SERIAL_NO shell ifconfig wlan0 | grep "inet addr:" | cut -d':' -f 2 | awk '{ print $1 }'`
	SUCCESS_MESSAGE="connected to $IP_ADDRESS:$PORT"	

	adb tcpip $PORT
	TRY_CONN=`adb connect $IP_ADDRESS:$PORT`

	if [ "$TRY_CONN" == "$SUCCESS_MESSAGE" ]
	then
		echo "Successfully connected to $DEVICE_NAME. You may disconnect your usb cable now."
	else
		echo "Connection failed: $TRY_CONN"
	fi
}

case "$NUM_DEVICES" in
    0)
        echo "No android device found"	
	exit
        ;;
         
    1)	
        DEVICE_NAME=`adb devices -l | grep "model" | cut -d':' -f 4 | sed 's/device//'`
	SERIAL_NO=`adb get-serialno`

	decide       
	;;
         
    *)
        echo "Multiple Devices found"
	printDevices
	selectDevice 
	decide 
	;;
esac
