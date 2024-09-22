#!/usr/bin/env python

import numpy as np
import datetime
import os, time

mycmd = 'python setfreq.py'

# By default, 72/50 = 1.44 Hz to 1.1 Hz in 0.04 Hz steps
#nstep = 2
#npoints = range(72,55,-nstep)
#waittime = 3600 # seconds (1 hour)

# 1.8 Hz to 1.1 Hz in steps of 0.1 Hz, wait time 40 min
npoints = range(90,54,-5)
waittime = 2400

print(str(datetime.datetime.now()))
os.system(mycmd+' '+str(float(npoints[0])/50))

for ii in npoints:

    print(str(datetime.datetime.now()))
    print('Setting value '+str(float(ii)/50))

    os.system(mycmd+' '+str(float(ii)/50))

    time.sleep(waittime)

