# adb-Wireless

Script that displays a list of all android devices currently connected via usb, and lets you establish a TCP/IP connection with them for wireless debugging. No root access required.

Usage:
 - Connect the device via usb to the computer. Make sure that the device and the computer are connected to a common WiFi network.
 - Run the script. From the list of connected devices displayed, select the device you wish to establish a TCP/IP connection with.
 - Disconnect the usb cable.
 - To confirm an active connection, run `$ adb devices`.
 
To return to usb mode, run `$ adb usb`.
