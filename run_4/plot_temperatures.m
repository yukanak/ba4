function plot_temperatures(run,starttime,endtime,basetemp_starttime,basetemp_endtime)
% For run 4.4, run=4, starttime='220211 21:45:00', endtime='220216 18:30:00', basetemp_starttime=[2022,02,16,18,15,00], basetemp_endtime=[2022,02,16,18,30,00]

% Plot temperature curve (all temperatures) for run
% Load data (can test in reduc/bicep3/, data files in arc/)
% To use, go to a directory with access to pipeline, and add this directory to startup.m there; then start MATLAB and type plot_temperatures(args)
d = load_arc(sprintf('/n/home04/yuka/ba4/run_%d/arc/', run), starttime, endtime, {'array.frame.utc', 'antenna0.frame.utc', 'antenna0.hk0.slow_temp'});

% Turn two field UTC into single column modified Julian date
f = make_utc_single_col(d);

% Create user friendly time vector
[y,m,d,h,mm,s] = mjd2date(f.antenna0.frame.utc(:,1));
time = datenum([y,m,d,h,mm,s]);

% Create figure + plot
figure(1);
clf;
setwinsize(gcf,800,600);
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
legend('50K cold head','4K heat strap cold side','4K heat strap warm side','50K heat strap cold side','50K heat strap warm side','4K baseplate','4K tube top','50K tube top', '4K fridge bracket');
xlabel('Date');
ylabel('Temperature [K]');
title(sprintf('BA4 Run %d Temperatures', run));

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print(sprintf('/n/home04/yuka/ba4/run_%d/ba4p%d_cooldown_all_lin', run, run), '-dpng');

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
legend('50K cold head','4K heat strap cold side','4K heat strap warm side','50K heat strap cold side','50K heat strap warm side','4K baseplate','4K tube top','50K tube top', '4K fridge bracket');
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
plot(time, f.antenna0.hk0.slow_temp(:,37), 'Color', [0.9290 0.6940 0.1250]);
legend('4K heat strap cold side','4K heat strap warm side','4K baseplate','4K tube top', '4K fridge bracket');
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
semilogy(time, f.antenna0.hk0.slow_temp(:,37), 'Color', [0.9290 0.6940 0.1250]);
legend('4K heat strap cold side','4K heat strap warm side','4K baseplate','4K tube top', '4K fridge bracket');
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
legend('50K cold head','50K heat strap cold side','50K heat strap warm side','50K tube top');
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
legend('50K cold head','50K heat strap cold side','50K heat strap warm side','50K tube top');
xlabel('Date');
ylabel('Temperature [K]');
title(sprintf('BA4 Run %d 50K Temperatures', run));

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print(sprintf('/n/home04/yuka/ba4/run_%d/ba4p%d_cooldown_50k_log', run, run), '-dpng');

% Get the base temperatures
start_time = datenum(basetemp_starttime);
end_time = datenum(basetemp_endtime);
time_idx = find(time>start_time & time<end_time);

for diode = [29 30 31 32 33 34 35 36 37]
    temp_avg = nanmean(f.antenna0.hk0.slow_temp(time_idx,diode));
    fprintf('Thermometer %d: %.2f K\n', diode, temp_avg);
end

return
