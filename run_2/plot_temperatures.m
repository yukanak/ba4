% Plot temperature curve (all temperatures) for run 4.2
% Load data (can test in reduc/bicep3/, data files in arc/)
d = load_arc('~/ba4/run_2/', '210801 00:00:00', '210801 06:00:00');

% Turn two field UTC into single column modified Julian date
f = make_utc_single_col(d);

% Create user friendly time vector
[y,m,d,h,mm,s] = mjd2date(f.antenna0.frame.utc(:,1));
time = datenum([y,m,d,h,mm,s]);

% Create figure + plot
figure(1);
clf;
% antenna0.hk0.slow_temp[28] is the 50K cold head
% antenna0.hk0.slow_temp[29] is the 4K heat strap (cold side)
% antenna0.hk0.slow_temp[30] is the 4K heat strap (warm side)
% antenna0.hk0.slow_temp[31] is the 50K heat strap (cold side)
% antenna0.hk0.slow_temp[32] is the 50K heat strap (warm side)
% antenna0.hk0.slow_temp[33] is the 4K baseplate
% antenna0.hk0.slow_temp[34] is the 4K tube (top)
% antenna0.hk0.slow_temp[35] is the 50K tube (top)
plot(time, f.antenna0.hk0.slow_temp[28]);
hold on;
plot(time, f.antenna0.hk0.slow_temp[29]);
plot(time, f.antenna0.hk0.slow_temp[30]);
plot(time, f.antenna0.hk0.slow_temp[31]);
plot(time, f.antenna0.hk0.slow_temp[32]);
plot(time, f.antenna0.hk0.slow_temp[33]);
plot(time, f.antenna0.hk0.slow_temp[34]);
plot(time, f.antenna0.hk0.slow_temp[35]);
legend('50K cold head','4K heat strap (cold side)','4K heat strap (warm side)',
       '50K heat strap (cold side)','50K heat strap (warm side)','4K baseplate',
       '4K tube (top)','50K tube (top)');
xlabel('Time');
ylabel('Temperature [K]');
title('BA4 Run 2 Temperatures');

% Change x display to user friendly UTC
datetick('x', 'HH:MM', 'keeplimits');

% Save
print('ba4_run2_temp', '-dpng');
