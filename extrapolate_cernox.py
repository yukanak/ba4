import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

def extrapolate_cernox(loc, res_val, hk_val=None):
    '''
    If the measured Cernox resistance is out of the calibration range, we want
    to predict the temperature by doing a rough exponential extrapolation
    (which is linear on a log-log plot).
    The loc should be either 'uc evap', 'ic evap', 'he4 evap', or 'he4 cond'.
    The argument res_val should be the resistance in Ohms.
    '''
    d = np.genfromtxt(open("ba4_fridge_cernox_data.csv", "rb"), delimiter=",", filling_values=0, skip_header=1)
    if loc == 'uc evap':
        temp = d[:12503,6]
        res = d[:12503,7]
        title = 'UC Evaporator'
        x_interp = np.linspace(0.2, 0.315, 100)
        extrap_max = 4000
        x_interp = np.linspace(0.2, temp[extrap_max], 100)
    elif loc == 'ic evap':
        temp = d[:,4]
        res = d[:,5]
        title = 'IC Evaporator'
        extrap_max = 4000
        x_interp = np.linspace(0.2, temp[extrap_max], 100)
    elif loc == 'he4 evap':
        temp = d[:,2]
        res = d[:,3]
        title = 'He4 Evaporator'
        extrap_max = 4000
        x_interp = np.linspace(0.4, temp[extrap_max], 1000)
    elif loc == 'he4 cond':
        temp = d[:,0]
        res = d[:,1]
        title = 'He4 Condensation Point'
        extrap_max = 8000
        x_interp = np.linspace(3, temp[extrap_max], 1000)
    else:
        raise ValueError("Argument loc must be 'uc evap', 'ic evap', 'he4 evap', or 'he4 cond'")

    # Fit an exponential function, which would look like a line on log-log plot
    if res_val > res[0]:
        popt, pcov = curve_fit(ExpFunc, temp[:extrap_max], res[:extrap_max])
        # Get temperature value for the measured resistance
        temp_val = (res_val/popt[0])**(1/popt[1])
    elif res_val > res[-1]:
        idx = find_nearest(res, res_val)
        popt, pcov = curve_fit(ExpFunc, temp[idx-20:idx+20], res[idx-20:idx+20])
        temp_val = (res_val/popt[0])**(1/popt[1])
        x_interp = np.linspace(temp[idx-20], temp[idx+20], 100)
    else:
        print("Resistance is too small; room temperature!")
        temp_val = np.nan

    plt.loglog(temp, res,'b.', label='Duband Calibration')
    plt.loglog(x_interp, ExpFunc(x_interp, *popt), color='g', linestyle='--', label='Fit Line')
    plt.loglog(temp_val, res_val, 'rx', label=f'{temp_val:.3f} K at {res_val} Ohms')
    if hk_val:
        plt.loglog(hk_val, res_val, color='y', marker='x', linestyle='', label=f'HK Temperature Value: {hk_val:.2f} K')
    plt.xlabel('Temperature [K]')
    plt.ylabel('Resistance [Ohm]')
    plt.title(title)
    plt.legend()
    plt.show()

    return temp_val

def ExpFunc(x, a, b):
    return a * np.power(x, b)

def find_nearest(array, value):
    array = np.asarray(array)
    idx = (np.abs(array - value)).argmin()
    return idx
