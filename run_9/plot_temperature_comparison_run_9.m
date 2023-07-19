function plot_temperature_comparison_run_9()
s1 = '230718 02:07:00';
e1 = '230719 02:07:00';
s2 = '230427 23:36:00'; % run 4.8
e2 = '230428 23:36:00';

% Plot temperature curve (all temperatures) for run
% Load data (can test in reduc/bicep3/, data files in arc/)
% To use, go to a directory with access to pipeline, and add this directory to startup.m there; then start MATLAB and type plot_temperatures(args)
d1 = load_arc('/n/home04/yuka/holylfs/bicep_array/ba4daq/arc', s1, e1, {'array.frame.utc', 'antenna0.frame.utc', 'antenna0.hk0.slow_temp'});
d2 = load_arc('/n/home04/yuka/holylfs/bicep_array/ba4daq/arc', s2, e2, {'array.frame.utc', 'antenna0.frame.utc', 'antenna0.hk0.slow_temp'});

% Turn two field UTC into single column modified Julian date
f1 = make_utc_single_col(d1);
f2 = make_utc_single_col(d2);

% Create user friendly time vector
[y1,m1,d1,h1,mm1,s1] = mjd2date(f1.antenna0.frame.utc(:,1));
time1 = datenum([y1,m1,d1,h1,mm1,s1]);

% Create figure + plot
figure(1);
clf;
setwinsize(gcf,800,600);
plot(time1, f1.antenna0.hk0.slow_temp(:,26), 'r-');
hold on;
plot(time1, f1.antenna0.hk0.slow_temp(:,33), 'm-');
plot(time1, f1.antenna0.hk0.slow_temp(:,37), 'b-');
plot(time1, f1.antenna0.hk0.slow_temp(:,32), 'g-');
plot(time1, f2.antenna0.hk0.slow_temp(:,26), 'r--');
plot(time1, f2.antenna0.hk0.slow_temp(:,33), 'm--');
plot(time1, f2.antenna0.hk0.slow_temp(:,37), 'b--');
plot(time1, f2.antenna0.hk0.slow_temp(:,32), 'g--');
legend('4K baseplate','4K tube top','50K cold head', '50K tube top');
xlabel('Date');
ylabel('Temperature [K]');
title('BA4 Run 9 vs BA4 Run 8 Temperatures');

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print('/n/home04/yuka/ba4/run_9/ba4r9_cooldown_comparison', '-dpng');

% Log plot now
figure(2);
clf;
setwinsize(gcf,800,600);
semilogy(time1, f1.antenna0.hk0.slow_temp(:,26), 'r-');
hold on;
semilogy(time1, f1.antenna0.hk0.slow_temp(:,33), 'm-');
semilogy(time1, f1.antenna0.hk0.slow_temp(:,37), 'b-');
semilogy(time1, f1.antenna0.hk0.slow_temp(:,32), 'g-');
semilogy(time1, f2.antenna0.hk0.slow_temp(:,26), 'r--');
semilogy(time1, f2.antenna0.hk0.slow_temp(:,33), 'm--');
semilogy(time1, f2.antenna0.hk0.slow_temp(:,37), 'b--');
semilogy(time1, f2.antenna0.hk0.slow_temp(:,32), 'g--');
legend('4K baseplate','4K tube top','50K cold head', '50K tube top');
xlabel('Date');
ylabel('Temperature [K]');
title('BA4 Run 9 vs BA4 Run 8 Temperatures');

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print('/n/home04/yuka/ba4/run_9/ba4r9_cooldown_comparison_log', '-dpng');

% Get the last temperatures
basetemp_starttime=[2023,07,19,02,06,50]; basetemp_endtime=[2023,07,19,02,07,00];
start_time = datenum(basetemp_starttime);
end_time = datenum(basetemp_endtime);
time_idx = find(time>start_time & time<end_time);
for diode = [26 33 37 32]
    temp_avg = nanmean(f1.antenna0.hk0.slow_temp(time_idx,diode));
    fprintf('Run 9 Thermometer %d: %.2f K\n', diode, temp_avg);
end

basetemp_starttime=[2023,04,28,23,35,50]; basetemp_endtime=[2023,04,28,23,36,00];
start_time = datenum(basetemp_starttime);
end_time = datenum(basetemp_endtime);
time_idx = find(time>start_time & time<end_time);
for diode = [26 33 37 32]
    temp_avg = nanmean(f1.antenna0.hk0.slow_temp(time_idx,diode));
    fprintf('Run 8 Thermometer %d: %.2f K\n', diode, temp_avg);
end

return
