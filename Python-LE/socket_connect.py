import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
def connect():
    try:
        s.connect(("10.200.82.138", 4000))
        return True
    except socket.error:
        return False
        
def send( msg):
    s.send(msg)
def close():
    s.close()
def sendMotionAndUUID(motion,uuid):
    s.send("userAcceleration:%0.10f;peripheral:%s\n" % (motion, uuid))
 

