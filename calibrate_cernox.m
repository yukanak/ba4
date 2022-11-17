function calibrate_cernox(run,starttime,endtime)
% For example, run=5; starttime='220423 01:00:00'; endtime='220427 14:00:00';

% Plot temperature curve (all temperatures) for run
% Load data (can test in reduc/bicep3/, data files in arc/)
% To use, go to a directory with access to pipeline, and add this directory to startup.m there; then start MATLAB and type plot_temperatures(args)
d = load_arc(sprintf('/n/home04/yuka/ba4/run_%d/arc/', run), starttime, endtime, {'antenna0.frame.utc', 'antenna0.hk0.slow_temp', 'antenna0.hk0.slow_voltage'});

% Turn two field UTC into single column modified Julian date
f = make_utc_single_col(d);

% Create user friendly time vector
[y,m,d,h,mm,s] = mjd2date(f.antenna0.frame.utc(:,1));
time = datenum([y,m,d,h,mm,s]);

%%%%%%%%%% EDIT BELOW %%%%%%%%%%
calibrated_cernox = 1; % Index for slow_temp
cernoxes_uncal = [2 3 4];
cooldown_starttime = datenum([2022,04,27,13,50,00]);
cooldown_endtime = 
fridgecycle_starttime = 
fridgecycle_endtime = 
ucexpiration_starttime = 
ucexpiration_endtime = 
heater_starttime = 
heater_endtime = 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cooldown_time_idx = find(time>cooldown_starttime & time<cooldown_endtime);
fridgecycle_time_idx = find(time>fridgecycle_starttime & time<fridgecycle_endtime);
ucexpiration_time_idx = find(time>ucexpiration_starttime & time<ucexpiration_endtime);
heater_time_idx = find(time>heater_startime & time<heater_endtime);

% Try plotting
figure(1);
clf;
setwinsize(gcf,800,600);
plot(time(cooldown_time_idx), f.antenna0.hk0.slow_temp(cooldown_time_idx, calibrated_cernox), 'k-');
hold on;
plot(time(cooldown_time_idx), f.antenna0.hk0.slow_temp(cooldown_time_idx, cernox_uncal(1)), 'r-');
legend('S1 (calibrated)', 'S2')
xlabel('Date');
ylabel('Temperature [K]');
title(sprintf('BA4 Run %d Temperatures', run));
% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');
% Save
%print(sprintf('/n/home04/yuka/ba4/run_%d/ba4p%d_cernoxtemps_cooldown', run, run), '-dpng');

% Merge all the time indices for the parts that we want for calibration
cal_time_idx = cat(1, cooldown_time_idx, ucexpiration_time_idx, heater_time_idx);

% Calibration
new_temps = zeros(length(cernoxes_uncal), length(cal_time_idx));
%calibrated_cernox_voltages = f.antenna0.hk0.slow_voltage(cal_time_idx, calibrated_cernox);
calibrated_cernox_temps = f.antenna0.hk0.slow_temp(cal_time_idx, calibrated_cernox);
for i = 1:length(cernoxes_uncal)
    c = cernoxes_uncal(i);
    new_temps(i,:) = 



    for j = 1:length(cal_time_idx)
        voltage = f.antenna0.hk0.slow_voltage(cal_time_idx(j), c);
        % Find closest voltage value in the calibrated Cernox data and assign the corresponding temperature value
        [closest_voltage_diff closest_voltage_idx] = min(abs(calibrated_cernox_voltages-voltage));
        new_temps(i,j) = calibrated_cernox_temps(closest_voltage_idx);
    end
end

% Make it monotonic
[sorted_T, sorted_T_idx] = sort(new_temps,2);



%TODO: need to convert it to resistance... using daca parameters?



% Plot it
figure(2);
clf;
setwinsize(gcf,800,600);
plot(


for diode = [29 30 31 32 33 34 35 36 37]
    temp_avg = nanmean(f.antenna0.hk0.slow_temp(time_idx,diode));
    fprintf('Thermometer %d: %.2f K\n', diode, temp_avg);
end

plot(time, f.antenna0.hk0.slow_temp(:,29), 'k-');
hold on;
plot(time, f.antenna0.hk0.slow_temp(:,30), 'r-');
plot(time, f.antenna0.hk0.slow_temp(:,31), 'y-');
plot(time, f.antenna0.hk0.slow_temp(:,32), 'g-');
plot(time, f.antenna0.hk0.slow_temp(:,33), 'c-');
plot(time, f.antenna0.hk0.slow_temp(:,34), 'b-');
plot(time, f.antenna0.hk0.slow_temp(:,35), 'm-');
plot(time, f.antenna0.hk0.slow_temp(:,36), 'Color', [0.4940 0.1840 0.5560]);
plot(time, f.antenna0.hk0.slow_temp(:,37), 'Color', [0.9290 0.6940 0.1250]);
legend('50K cold head','4K heat strap cold side','4K heat strap warm side','50K heat strap cold side','50K heat strap warm side','4K baseplate','4K tube top','50K tube top', '50K filter');

% Log plot now
figure(2);
clf;
setwinsize(gcf,800,600);
semilogy(time, f.antenna0.hk0.slow_temp(:,29), 'k-');
hold on;
semilogy(time, f.antenna0.hk0.slow_temp(:,30), 'r-');
semilogy(time, f.antenna0.hk0.slow_temp(:,31), 'y-');
semilogy(time, f.antenna0.hk0.slow_temp(:,32), 'g-');
semilogy(time, f.antenna0.hk0.slow_temp(:,33), 'c-');
semilogy(time, f.antenna0.hk0.slow_temp(:,34), 'b-');
semilogy(time, f.antenna0.hk0.slow_temp(:,35), 'm-');
semilogy(time, f.antenna0.hk0.slow_temp(:,36), 'Color', [0.4940 0.1840 0.5560]);
semilogy(time, f.antenna0.hk0.slow_temp(:,37), 'Color', [0.9290 0.6940 0.1250]);
legend('50K cold head','4K heat strap cold side','4K heat strap warm side','50K heat strap cold side','50K heat strap warm side','4K baseplate','4K tube top','50K tube top', '50K filter');
xlabel('Date');
ylabel('Temperature [K]');
title(sprintf('BA4 Run %d Temperatures', run));

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print(sprintf('/n/home04/yuka/ba4/run_%d/ba4p%d_cooldown_all_log', run, run), '-dpng');

% Repeat for 4K only
% Linear plot
figure(3);
clf;
setwinsize(gcf,800,600);
plot(time, f.antenna0.hk0.slow_temp(:,30), 'r-');
hold on;
plot(time, f.antenna0.hk0.slow_temp(:,31), 'y-');
plot(time, f.antenna0.hk0.slow_temp(:,34), 'b-');
plot(time, f.antenna0.hk0.slow_temp(:,35), 'm-');
legend('4K heat strap cold side','4K heat strap warm side','4K baseplate','4K tube top');
xlabel('Date');
ylabel('Temperature [K]');
title(sprintf('BA4 Run %d 4K Temperatures', run));

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print(sprintf('/n/home04/yuka/ba4/run_%d/ba4p%d_cooldown_4k_lin', run, run), '-dpng');

% Log plot now
figure(4);
clf;
setwinsize(gcf,800,600);
semilogy(time, f.antenna0.hk0.slow_temp(:,30), 'r-');
hold on;
semilogy(time, f.antenna0.hk0.slow_temp(:,31), 'y-');
semilogy(time, f.antenna0.hk0.slow_temp(:,34), 'b-');
semilogy(time, f.antenna0.hk0.slow_temp(:,35), 'm-');
legend('4K heat strap cold side','4K heat strap warm side','4K baseplate','4K tube top');
xlabel('Date');
ylabel('Temperature [K]');
title(sprintf('BA4 Run %d 4K Temperatures', run));

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print(sprintf('/n/home04/yuka/ba4/run_%d/ba4p%d_cooldown_4k_log', run, run), '-dpng');

% Repeat for 50K only
% Linear plot
figure(5);
clf;
setwinsize(gcf,800,600);
plot(time, f.antenna0.hk0.slow_temp(:,29), 'k-');
hold on;
plot(time, f.antenna0.hk0.slow_temp(:,32), 'g-');
plot(time, f.antenna0.hk0.slow_temp(:,33), 'c-');
plot(time, f.antenna0.hk0.slow_temp(:,36), 'Color', [0.4940 0.1840 0.5560]);
plot(time, f.antenna0.hk0.slow_temp(:,37), 'Color', [0.9290 0.6940 0.1250]);
legend('50K cold head','50K heat strap cold side','50K heat strap warm side','50K tube top','50K filter');
xlabel('Date');
ylabel('Temperature [K]');
title(sprintf('BA4 Run %d 50K Temperatures', run));

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print(sprintf('/n/home04/yuka/ba4/run_%d/ba4p%d_cooldown_50k_lin', run, run), '-dpng');

% Log plot now
figure(6);
clf;
setwinsize(gcf,800,600);
semilogy(time, f.antenna0.hk0.slow_temp(:,29), 'k-');
hold on;
semilogy(time, f.antenna0.hk0.slow_temp(:,32), 'g-');
semilogy(time, f.antenna0.hk0.slow_temp(:,33), 'c-');
semilogy(time, f.antenna0.hk0.slow_temp(:,36), 'Color', [0.4940 0.1840 0.5560]);
semilogy(time, f.antenna0.hk0.slow_temp(:,37), 'Color', [0.9290 0.6940 0.1250]);
legend('50K cold head','50K heat strap cold side','50K heat strap warm side','50K tube top','50K filter');
xlabel('Date');
ylabel('Temperature [K]');
title(sprintf('BA4 Run %d 50K Temperatures', run));

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print(sprintf('/n/home04/yuka/ba4/run_%d/ba4p%d_cooldown_50k_log', run, run), '-dpng');

return
