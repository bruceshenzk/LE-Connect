# le-connect
RPi-iOS-BLE

This program is created for the purpose of connecting Raspberry pi 3 and iOS devices via Bluetooth Low Energy

The iOS device need to be deploied on a iOS 7 later device and set up as BLE peripheral which sending its motion data (averaged acceleration in 5 seconds)

The Raspberry Pi 3 need to install pybluez and corresponding libraries. Then run 'sudo python lescan.python'


Steps to install gattlib
'''
sudo apt-get update
sudo apt-get install libboost-python-dev libboost-thread-dev libbluetooth-dev libglib2.0-dev python-dev
'''

Steps to install pybluez
'''
sudo apt-get install python-pip python-dev ipython

sudo apt-get install bluetooth libbluetooth-dev
sudo pip install pybluez
'''

