#File from Caltech

# CONFIGURATION SETTINGS UNCERTAIN
#Moxa box serial settings
# Baud rate 9600
# Data bits 8
# Stop bits 1
# Parity None
# Flow control None
# FIFO Enable
# Interface RS-232

import serial

end_cmd = '\n'

# Do dmesg | tail to figure out what dev should be

dev = '/dev/ttyUSB2'
#dev = '/dev/ttyS0'

ser = serial.Serial(dev,timeout=1.0)

def w(x):
	ser.write(x.upper()+end_cmd)
def r():
	str = ""
	while 1:
		c = ser.read(1)
		if c == '\n': return str
		if c == '': return False
		str += c
	return str
def wr(x):
	w(x)
	return r()
