# LE-Connect

This program is created for the purpose of connecting Raspberry pi 3 and iOS devices via Bluetooth Low Energy(Bluetooth Smart)

The iOS device need to be deploied on a iOS 7 later device with BLE feature. It will be set up as a BLE peripheral which sends its motion data (averaged acceleration in 5 seconds) to BLE central (RPi)

The Raspberry Pi 3 need to install pybluez and corresponding libraries. Then in the root directory of the project, run `sudo python Python-LE/lescan.python`


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

