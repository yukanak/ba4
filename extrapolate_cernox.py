import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

def extrapolate_cernox(loc, res_val):
    '''
    If the measured Cernox resistance is out of the calibration range, we want
    to predict the temperature by doing a rough exponential extrapolation
    (which is linear on a log-log plot).
    The loc should be either 'uc evap', 'ic evap', 'he4 evap', or 'he4 cond'.
    The argument res_val should be the resistance in Ohms.
    '''
    temp, res, title, x_interp, extrap_max = get_cernox_data(loc)
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
    return popt, temp_val

def plot_extrapolation(loc, res_val, hk_val=None):
    popt, temp_val = extrapolate_cernox(loc, res_val)
    temp, res, title, x_interp, extrap_max = get_cernox_data(loc)
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

def get_cernox_data(loc):
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
    elif loc == 'extrapolated uc evap':
        d = np.genfromtxt(open("thermometers/R2T_X120258.interp", "rb"), delimiter="    ", filling_values=0)
        temp = d[:,1]
        res = d[:,0]
        title = 'UC Evaporator (Extrapolated)'
        x_interp = None
        extrap_max = None
    elif loc == 'S1':
        d = np.genfromtxt(open("thermometers/R2T_X154084.interp", "rb"), delimiter=" ", filling_values=0)
        temp = d[:,1]
        res = d[:,0]
        title = 'S1'
        extrap_max = 500
        x_interp = np.linspace(0.2, temp[extrap_max], 100)
    elif loc == 'S3':
        d = np.genfromtxt(open("thermometers/R2T_X154088.interp", "rb"), delimiter=" ", filling_values=0)
        temp = d[:,1]
        res = d[:,0]
        title = 'S1'
        extrap_max = 500
        x_interp = np.linspace(0.2, temp[extrap_max], 100)
    else:
        raise ValueError("Argument loc must be 'uc evap', 'ic evap', 'he4 evap', 'he4 cond', 'extrapolated uc evap', 'S1', or 'S3'")
    return temp, res, title, x_interp, extrap_max

def plot_uc_duband_vs_extrapolated():
    temp, res, title, x_interp, extrap_max = get_cernox_data('uc evap')
    t, r, tit, x_int, ex_max = get_cernox_data('extrapolated uc evap')
    plt.loglog(temp, res,'b.', label='Duband Calibration')
    plt.loglog(t, r,'r.', label='Extrapolated Calibration in GCP')
    plt.xlabel('Temperature [K]')
    plt.ylabel('Resistance [Ohm]')
    plt.title('Duband vs GCP UC Calibration Curve')
    plt.legend()
    plt.show()

def plot_bias_power(bias_voltages=[10e-6,3e-6,30e-6,100e-6,300e-6,1e-3,3e-3,10e-3,30e-3], 
                    locations=['ic evap','uc evap','S1','S3'],
                    r=[[6500,6500,6500,6500,6490,6366,5595,3733,2301],
                       [1800,1800,1800,1799,1798,1788,1723,1416,1027],
                       [1856,1856,1854,1850,1851,1843,1781,1473,1060],
                       [1490,1500,1490,1485,1483,1478,1441,1228,908]]):
    t = np.zeros_like(r).astype(float)
    for i, loc in enumerate(locations):
        for j, res_val in enumerate(r[i]):
            popt, temp_val = extrapolate_cernox(loc, res_val)
            t[i,j] = temp_val
            print(f'Doing {loc}, {res_val}, got {temp_val} K')
    cernox_res = 2000
    bias_powers = np.array(bias_voltages)**2 / cernox_res
    print(bias_powers)
    for i, loc in enumerate(locations):
        plt.plot(bias_powers, t[i,:], 'x', label=loc)
    plt.ylabel('Temperature [K]')
    plt.xlabel('Bias Power [W]')
    plt.xscale('log')
    plt.legend()
    plt.show()

def ExpFunc(x, a, b):
    return a * np.power(x, b)

def find_nearest(array, value):
    array = np.asarray(array)
    idx = (np.abs(array - value)).argmin()
    return idx
