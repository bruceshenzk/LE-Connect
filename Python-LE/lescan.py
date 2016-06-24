from __future__ import print_function

import sys
import threading
import time
import socket_connect
from struct import *
from bluetooth.ble import GATTRequester
from bluetooth.ble import DiscoveryService


class Reader(object):
    def __init__(self, address, socket_open):
        self.requester = GATTRequester(address, False)
        self.socket_enable = socket_open
        self.connect()
        t = threading.Thread(name=address,target=self.periodical_request)
        t.start()

    def connect(self):
        print ("Connecting...", end=' ')
        sys.stdout.flush()
        
        self.requester.connect(True,"random","medium",0,0)
        print ("OK!")

    def request_uuid(self):
        try:
            self.uuid = self.requester.read_by_uuid("D6F8BDCC-3885-11E6-AC61-9E71128CAE77")[0]
            print("uuid:", self.uuid)
        except RuntimeError:
            print("request uuid error")
            self.uuid = ""    

    def periodical_request(self):
        try:
            self.request_uuid()
        except Error:
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
            self.requester.connect(True,"random","medium",0,0)
            print("Reconnected")
        try:
            data = self.requester.read_by_uuid(
                "16864516-21E0-11E6-B67B-9E71128CAE77")[0]
        except RuntimeError:
            print("RuntimeError")
            return
        try:
            d = decode_string_to_double(data)
            print ("Device name:",self.uuid,"Device motion:", d) 
            if self.socket_enable:
                socket_connect.sendMotionAndUUID(d,self.uuid)
        except AttributeError:
            print ("Device name: " + data)

def decode_string_to_double(data):
    intlist = [ord(c) for c in data]
    newstr = "".join(chr(i) for i in intlist)
    return unpack('d', newstr)[0]
        
service = DiscoveryService()
devices = service.discover(2)
socket_open = False
if len(devices.items()) > 0:
    socket_open = socket_connect.connect()
for address, name in devices.items():
    if address in ['67:F6:0D:F5:C7:AD','6C:94:F8:D5:08:0E','68:64:4B:38:B3:DF']:
        continue
    print ("Adress: ", address, " Name: ", name)
    try:
        Reader(address, socket_open)
    except RuntimeError:
        print ("RuntimeError")
print ("Done.")    






