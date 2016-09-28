from __future__ import print_function
import sys
import threading
import time
import signal
import socket_connect
import signal_handler
import motion_manager
from struct import *
from bluetooth.ble import GATTRequester
from bluetooth.ble import DiscoveryService

current_milli_time = lambda: int(round(time.time()*1000))
tracked_devices = []
socket_open = False
service = DiscoveryService()

class Reader(object):
    def __init__(self, address):
        self.requester = GATTRequester(address, False)
        self.connect()
	t = threading.Thread(name=address,target=self.periodical_request)
        t.daemon = True
        t.start()

    def connect(self):
        self.requester.connect(True,"random","medium",0,32)
        print ("Connected")

    def request_uuid(self):
        self.uuid = self.requester.read_by_uuid("D6F8BDCC-3885-11E6-AC61-9E71128CAE77")[0]
        print("uuid read:", self.uuid)
        if len(self.uuid) < 37:
            self.uuid = self.uuid + self.requester.read_by_uuid("D6F8BDCC-3885-11E6-AC61-9E71128CAE77")[0]
        print("complete uuid:", self.uuid[0:35])   

    def periodical_request(self):
        tracked_devices.append(threading.current_thread().getName())
        try:
            self.request_uuid()
        except RuntimeError:
            tracked_devices.remove(threading.current_thread().getName())
            return
        count = 0
        while True:
            self.request_data()
            count = count + 1
            print("Count:",count)
            time.sleep(1)
    


    def request_data(self):
        if not self.requester.is_connected():
            print("Reconnecting")
            self.requester.disconnect()
            try:
                self.requester.connect(True,"random","medium",0,32)
            except RuntimeError:
                # End the thread bc cannot reconnect
                if threading.current_thread().getName() in tracked_devices:
                    # should be in the tracked devices list
                    # remove when thread is going to end
                    tracked_devices.remove(threading.current_thread().getName())
                else :
                    print("Error: thread should be tracked")
                print("Encountered error when reconnecting. Now exit thread.")
                sys.exit()
            print("Reconnected")
        try:
            start_time = current_milli_time()
            data = self.requester.read_by_uuid(
                "16864516-21E0-11E6-B67B-9E71128CAE77")[0]
        except RuntimeError as e:
            print("RuntimeError", e)
            self.requester.disconnect()
            return
        try:
            d = decode_string_to_double(data)
            print ("Device name:",self.uuid,"Device motion:", d) 
            if socket_open:
                socket_connect.sendMotionAndUUID(d,self.uuid)
            motion_manager.process_data(self.uuid[0:35], self.uuid[36],d)
        except AttributeError:
            print ("Device name: " + data)

def decode_string_to_double(data):
    intlist = [ord(c) for c in data]
    newstr = "".join(chr(i) for i in intlist)
    return unpack('d', newstr)[0]

def scan_devices():
    try:
        discovered_devices = service.discover(2)
        return discovered_devices.items()
    except RuntimeError:
        print("RuntimeError when scan for devices")
    
def request_device_data(devices):
    if devices == None:
        return
    if len(devices) > 0:
        socket_open = socket_connect.connect()
    for address, name in devices:
        # blacklist some devices in the environment
        if address in ['67:F6:0D:F5:C7:AD','6C:94:F8:D5:08:0E','68:64:4B:38:B3:DF']:
            continue
        # not tracking already tracked devices
        if address in tracked_devices:
            continue
        print("Building connection with ", address)
        try:
            Reader(address)
        except RuntimeError:
            print("Encontered RuntimeError when building connection with address")


def start_le_task():
    motion_manager.startLED()
    while True:
        print ("le task")
        request_device_data(scan_devices())
        time.sleep(15)




    


