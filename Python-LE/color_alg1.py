import RPi.GPIO as GPIO
import math
import time
from multiprocessing import Value

LED1 = 18
LED2 = 23
LED3 = 24
r = 0
g = 0
b = 0
last_color = (0, 0, 0)
next_color = (0, 0, 0)
current_r = 0.0
increasing_r = True
ave_level = Value('d',1.0)
shifting_stage = 0

def update_ave_level(level):
    #global ave_level
    #print "update value"
    ave_level.value = level.value
    #print ave_level, level
    #ave_level = level
    

def setup():
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(LED1, GPIO.OUT)
    GPIO.setup(LED2, GPIO.OUT)
    GPIO.setup(LED3, GPIO.OUT)
    global pwm1, pwm2, pwm3
    pwm1 = GPIO.PWM(LED1, 1000)
    pwm2 = GPIO.PWM(LED2, 1000)
    pwm3 = GPIO.PWM(LED3, 1000)
    pwm1.start(100)
    pwm2.start(100)
    pwm3.start(100)

def calculate_color():
    return (abs(math.cos(current_r/10*math.pi*(3+ave_level.value)/8)),
            abs(math.sin(current_r/10*math.pi*(3+ave_level.value)/8)),
            abs(math.sin(ave_level.value/10*math.pi*(3+current_r)/8)))
def start():
    global last_color, next_color
    color = calculate_color()
    set_color(color)
    last_color = color
    next_r()
    next_color = calculate_color()
    while True:
        if not start_shifting():
            time.sleep(0.05)
            break
    while True:
        another_shifting()
        time.sleep(0.05)
        
        
def start_shifting():
    global shifting_stage
    shifting_stage = shifting_stage + 1
    set_color(get_stage_color())
    if shifting_stage == 8:
        shifting_stage = 0
        #ask for new shift
        return False
    return True;

def another_shifting():
    global last_color, next_color
    last_color = next_color
    next_r()
    next_color = calculate_color()
    start_shifting()
    
def get_stage_color():
    return((next_color[0]-last_color[0])*shifting_stage/8.0+ last_color[0],
           (next_color[1]-last_color[1])*shifting_stage/8.0+ last_color[1],
           (next_color[2]-last_color[2])*shifting_stage/8.0+ last_color[2])

def next_r():
    global increasing_r, current_r
    if increasing_r and current_r == 4:
        current_r = 3.5
        increasing_r = False
    elif not increasing_r and current_r == 0:
        current_r = 0.5
        increasing_r = True
    elif increasing_r:
        current_r = current_r + 0.5
    else:
        current_r = current_r - 0.5

    
    
def set_color(tp):
    c1 = tp[0]
    c2 = tp[1]
    c3 = tp[2]
    set_color_3(c1, c2, c3)

def set_color_3(ar, ag, ab):
    global r, g, b
    r = ar
    g = ag
    b = ab
    set_LED()

def set_LED():
    global r, g, b
    #print(r, g, b)
    c1 = (1-r) * 100
    c2 = (1-g) * 100
    c3 = (1-b) * 100
    pwm1.ChangeDutyCycle(c1)
    pwm2.ChangeDutyCycle(c2)
    pwm3.ChangeDutyCycle(c3)

    
def main():
    try:
        setup()
        start()
        
    except SystemExit:
        print "SystemExit"
    finally:
        GPIO.cleanup()
