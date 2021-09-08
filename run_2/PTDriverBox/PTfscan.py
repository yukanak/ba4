#!/usr/bin/python

#original file from caltech


import numpy as np
import datetime
import os, time



mycmd = 'python setfreq.py'

nstep = 2

npoints = range(72,55, -nstep)

waittime = 3600 #seconds

print(str(datetime.datetime.now()))
os.system(mycmd+' '+str(float(npoints[0])/50))


for ii in npoints:

    print(str(datetime.datetime.now()))
    print('Setting value '+str(float(ii)/50))

    os.system(mycmd+' '+str(float(ii)/50))

    time.sleep(waittime)


# os.system(mycmd+' '+str(1.34))
