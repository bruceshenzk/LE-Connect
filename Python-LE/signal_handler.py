import signal
import sys
def signal_handler(signal, frame):
    print('You press Ctrl+C!')
    sys.exit(0)
signal.signal(signal.SIGINT, signal_handler)

    
