#!/usr/bin/env python

import sys
import lnx

# To use this script, do e.g. ./setfreq.py 1.4 to set it to 1.4 Hz

default_speed = 70
min_speed = 55
max_speed = 90

try:
	speed = int(float(sys.argv[1])*50)
except IndexError:
	print "using default speed ",default_speed
	speed = default_speed

if min_speed > speed or speed > max_speed:
	print>>sys.stderr,"speed %d out of range %d to %d"%(speed,min_speed,max_speed)
	exit(1)

#print lnx.wr('RS')
#print lnx.wr('STOP')
#print ("MC H+ A140 V%d G"%speed)
print lnx.wr('MC H+ A140 V%d G '%speed)
