# The Goal of LE-Connect 

The goal of hte project is to develop a real time monitoring system that can capture the motion of devices inside a room within a range of 20 meters. The intent is that the system will be able to trigger music and lights in response to the motion of the devices. This system could then be used in a theatrical performance. 

## Design
The user end devices chosen for motion tracking are cellphones on both the iOS and the Android platform. The central device that receives motion data from the cellphones is a Raspberry Pi 3. The devices communicate by the means of BLE, also known as Bluetooth Smart or Bluetooth 4.0. When connected to a WIFI environment, the Raspberry Pi can use a socket connection to forward the raw acceleration data from the cellphones to a computer working as a multimedia server. The computer is able to quickly process data to generating sound and light is response to user motion. 


# Things You Will Need
* Raspberry Pi, and accessories
* Multimedia Server (Any computer that can run Java SE)
* Router
* Phones (Android phone with Bluetooth Smart/iPhone with iOS 7 or later)


# How to Setup the Environment
## Router
As usual router setup. Raspberry Pi and Multimedia server will be connected to this router.
You would like to assign an fixed IP address for multimedia server.

## Multimedia Server
Connect to the router
Download the project from git
```
https://github.com/bruceshenzk/LE-Connect.git
```
Open the project in IntelliJ 
Configure the main class to com.bruceshen.socketIos.Main and run

## Raspberry Pi
Install necessary libraries
Connect to the router
Download the project from git
```
https://github.com/bruceshenzk/LE-Connect.git
```

You may need to change the IP address for multimedia server in socket_connect.py for connecting to the server.

## Phones 
The source codes for phones (Android and iOS) are in folder ***Android-Beacon*** and ***iOS-Beacon***.
You can use IDEs like Android Studio and Xcode to compile and run the beacon program on you phone devices.

# How to Make it Work (Finally!)
Again, make sure the raspberry pi and multimedia server are on the same router.
1. On multimedia server, open ***LE-Connect/SocketListener*** folder in IntelliJ, and run the main class.
2. On Raspberry Pi, go to ***LE-Connect/Python-LE*** folder
```
sudo python main.py
```
The running of the program requires root privilege because it uses GPIO and BLE stack.
3. On phones, open the applications installed on them.
   iPhone application can be put into background and still running, while Android cannot for this build.
4. Watch the result on multimedia server output.




Steps to install gattlib

```
sudo apt-get update
sudo apt-get install libboost-python-dev libboost-thread-dev libbluetooth-dev libglib2.0-dev python-dev
```

Steps to install pybluez

```
sudo apt-get install python-pip python-dev ipython

sudo apt-get install bluetooth libbluetooth-dev
sudo pip install pybluez
```

