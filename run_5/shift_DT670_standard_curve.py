import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import linregress

def shift(V=[1.0272,0.5747], T=[77.34,293.55], onepoint=True, plot=True, standard_curve_location='DT670_standard_curve.txt'):
    '''
    V and T are vectors (in V and K) containing the measured data points.
    These will be plotted, and if onepoint is True, only the first point would
    be used to shift the standard curve in the V direction.
    '''
    d = np.genfromtxt(open(standard_curve_location, "rb"), delimiter="   ")
    temp = d[:,0]
    vol = d[:,1]
    if onepoint:
        # Only trust the first (liquid nitrogen) value
        V_cal = np.interp(T[0], temp, vol)
        v0 = V[0] - V_cal
    else:
        V_cal = np.interp(T, temp, vol)
        v0 = np.mean(V) - np.mean(V_cal)
    new_temp = temp
    new_vol = vol+v0
    if plot:
        plt.plot(vol, temp, 'k-', label='DT670 Standard Curve')
        plt.plot(new_vol, new_temp, 'r--', label='Shifted Calibration Curve')
        plt.plot(V, T, color='b', marker='x', linestyle='', label=f'Data Points')
        plt.legend()
        plt.ylabel('T [K]')
        plt.xlabel('V [V]')
        plt.show()
    print(f'Shifted by {v0} V')
    new_data = np.array((new_temp, new_vol)).T
    #np.savetxt('shifted_diode_cal.dat', new_data, delimiter='   ')
    new_data_2 = np.array((new_vol[::-1], new_temp[::-1])).T
    np.savetxt('D60067854.dat', new_data_2, delimiter=' ')
    
