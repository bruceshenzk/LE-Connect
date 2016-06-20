from __future__ import print_function

import sys
from struct import *
from bluetooth.ble import GATTRequester
from bluetooth.ble import DiscoveryService


class Reader(object):
    def __init__(self, address):
        self.requester = GATTRequester(address, False)
        self.connect()
        self.request_data()

    def connect(self):
        print("Connecting...", end=' ')
        sys.stdout.flush()

        
        self.requester.connect(True,"random","high",0,0)
        print("OK!")

    def request_data(self):
        data = self.requester.read_by_uuid(
                "16864516-21E0-11E6-B67B-9E71128CAE77")[0]
        try:
            str = "".join("\\x{:02x}".format(ord(c)) for c in data)
            print("Device motion: ", str, " ",len(str) )
            intlist = [ord(c) for c in data]
            print(intlist)
            newstr = "".join(chr(i) for i in intlist)
            print(unpack('d', newstr))
        except AttributeError:
            print("Device name: " + data)


service = DiscoveryService()
devices = service.discover(2)

for address, name in devices.items():
    print("name: {}, address: {}".format(name, address))
    if address == '67:F6:0D:F5:C7:AD':
        continue
    elif address == '6C:94:F8:D5:08:0E':
        continue
    elif address == '68:64:4B:38:B3:DF':
        continue
    try:
        Reader(address)
    except RuntimeError:
        print("RuntimeError")
print("Done.")    






