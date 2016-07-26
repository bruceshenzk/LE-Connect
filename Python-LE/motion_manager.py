from __future__ import division
import color_alg1
from multiprocessing import Process
import time

current_milli_time = lambda: int(round(time.time()*1000))
motion = dict()
motion_time = dict()

dic = {"0":[0.1,0.2,0.4,0.6],
       "1":[0.5,1,1.5,2],
       "2":[0.5,1,1.5,2],
       "3":[5,10,15,20]}
average = 1

def startLED():
    p = Process(target = color_alg1.main)
    p.start()

def update(key, value):
    global motion
    motion[key] = value
    motion_time[key] = current_milli_time()
    calc_average()
    update_average()

def get(key):
    return motion.get(key, default=1)

def process_data(uuid, m, d):
    c = 0
    for l in dic[m]:
        if d < dic[m][c]:
            update(uuid, c+1)
            return
        c = c+1
    update(uuid, c+1)

def calc_average():
    s = 0
    c = 0
    print "Motion", motion
    print "Values",motion.values()
    for k in motion.keys():
        if current_milli_time() - motion_time[k]< 5000L:
            s = s + motion[k]
            c = c+1
        else:
            del motion[k]
            del motion_time[k]
    if c != 0:
        average = s/c
    else:
        average = 1
    print "Average:", average

def update_average():
    color_alg1.ave_level = average
    
