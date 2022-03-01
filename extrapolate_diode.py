import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import linregress

def extrapolate_diode(loc, vol_low, vol_high, hk_val_low=None, hk_val_high=None):
    '''
    We want
    to predict the temperature by doing a rough exponential extrapolation
    (which is linear on a log-log plot).
    The loc should be e.g. 'C2' for 4K heat strap cold of run 4.
    The argument vol_low and vol_high should be the voltage in V.
    '''
    if loc == 'C2':
        filename = 'thermometers/D6100125.dat'
        title = '4K Heat Strap Cold'
    elif loc == 'C3':
        filename = 'thermometers/D6102156.dat'
        title = '4K Heat Strap Warm'
    elif loc == 'C4':
        filename = 'thermometers/D6102161.dat'
        title = '50K Heat Strap Cold'
    elif loc == 'C5':
        filename = 'thermometers/D6101190.dat'
        title = '50K Heat Strap Warm'
    elif loc == 'C6':
        filename = 'thermometers/D6102546.dat'
        title = '4K Baseplate'
    elif loc == 'C7':
        filename = 'thermometers/D6103115.dat'
        title = '4K Tube Top'
    elif loc == 'C8':
        filename = 'thermometers/D6102691.dat'
        title = '50K Tube Top'
    else:
        raise ValueError("Argument loc must be between 'C2' to 'C8'")
    name = filename[13:-4]

    d = np.genfromtxt(open(filename, "rb"), delimiter=" ")
    temp = d[:,1]
    vol = d[:,0]

    # Fit an exponential function, which would look like a line on log-log plot
    if vol_high < vol[-1] and vol_low > vol[0]:
        idx_high = find_nearest(vol, vol_high)
        idx_low = find_nearest(vol, vol_low)
        m, b, r, p, se = linregress(temp[idx_low-20:idx_high+20], vol[idx_low-20:idx_high+20])
        temp_low = (vol_high-b)/m
        temp_high = (vol_low-b)/m
        x_interp = np.linspace(temp[idx_low-20], temp[idx_high+20], 100)
    else:
        print("Resistance is out of range!")
        temp_high = np.nan
        temp_low = np.nan

    plt.plot(temp, vol, 'b.', label=f'Diode {name} Calibration')
    plt.plot(x_interp, m*x_interp+b, color='g', linestyle='--', label='Fit Line')
    plt.plot(temp_low, vol_high, 'rx', label=f'{temp_low:.2f} K at {vol_high:.4} V')
    if vol_low != vol_high:
        plt.plot(temp_high, vol_low, 'rx', label=f'{temp_high:.2f} K at {vol_low:.4} V')
    if hk_val_low:
        plt.plot(hk_val_low, vol_high, color='y', marker='x', linestyle='', label=f'HK Temperature Value: {hk_val_low:.2f} K')
        if hk_val_low != hk_val_high:
            plt.plot(hk_val_high, vol_low, color='y', marker='x', linestyle='', label=f'HK Temperature Value: {hk_val_high:.2f} K')
    plt.xlabel('Temperature [K]')
    plt.ylabel('Voltage [V]')
    plt.title(title)
    plt.legend()
    #plt.xlim(2,5)
    #plt.ylim(1.5,1.7)
    plt.xlim(40,50)
    plt.ylim(1,1.2)
    plt.show()

    return temp_low, temp_high

def ExpFunc(x, a, b):
    return a * np.power(x, b)

def find_nearest(array, value):
    array = np.asarray(array)
    idx = (np.abs(array - value)).argmin()
    return idx
