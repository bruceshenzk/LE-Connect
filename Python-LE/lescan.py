from __future__ import print_function

import sys
import threading
import time
from struct import *
from bluetooth.ble import GATTRequester
from bluetooth.ble import DiscoveryService


class Reader(object):
    def __init__(self, address):
        self.requester = GATTRequester(address, False)
        self.connect()
        t = threading.Thread(name=address,target=self.periodical_request)
        t.start()

    def connect(self):
        print ("Connecting...", end=' ')
        sys.stdout.flush()

        
        self.requester.connect(True,"random","high",0,0)
        print ("OK!")
    
    def periodical_request(self):
        while True:
            try:
                self.request_data()
            except RuntimeError:
                break
            time.sleep(1)


    def request_data(self):
        data = self.requester.read_by_uuid(
                "16864516-21E0-11E6-B67B-9E71128CAE77")[0]
        try:
            str = "".join("\\x{:02x}".format(ord(c)) for c in data)
            intlist = [ord(c) for c in data]
            newstr = "".join(chr(i) for i in intlist)
            print ("Device name:",threading.currentThread().getName(),"Device motion:", unpack('d', newstr)[0]) 
        except AttributeError:
            print ("Device name: " + data)


service = DiscoveryService()
devices = service.discover(2)

for address, name in devices.items():
    if address in ['67:F6:0D:F5:C7:AD','6C:94:F8:D5:08:0E','68:64:4B:38:B3:DF']:
        continue
    print ("Adress: ", address, " Name: ", name)
    try:
        Reader(address)
    except RuntimeError:
        print ("RuntimeError")
print ("Done.")    






