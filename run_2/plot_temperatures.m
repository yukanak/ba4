% Plot temperature curve (all temperatures) for run 4.2
% Load data (can test in reduc/bicep3/, data files in arc/)
d = load_arc('/n/home04/yuka/ba4/run_2/arc/', '210826 16:35:00', '21xxxx xx:xx:xx'); %TODO

% Turn two field UTC into single column modified Julian date
f = make_utc_single_col(d);

% Create user friendly time vector
[y,m,d,h,mm,s] = mjd2date(f.antenna0.frame.utc(:,1));
time = datenum([y,m,d,h,mm,s]);

% Create figure + plot
figure(1);
clf;
setwinsize(gcf,800,600);
plot(time, f.antenna0.hk0.slow_temp(:,28), 'k-');
hold on;
plot(time, f.antenna0.hk0.slow_temp(:,29), 'r-');
plot(time, f.antenna0.hk0.slow_temp(:,30), 'y-');
plot(time, f.antenna0.hk0.slow_temp(:,31), 'g-');
plot(time, f.antenna0.hk0.slow_temp(:,32), 'c-');
plot(time, f.antenna0.hk0.slow_temp(:,33), 'b-');
plot(time, f.antenna0.hk0.slow_temp(:,34), 'm-');
plot(time, f.antenna0.hk0.slow_temp(:,35), 'Color', [0.4940 0.1840 0.5560]);
legend('50K cold head','4K heat strap cold side','4K heat strap warm side','50K heat strap cold side','50K heat strap warm side','4K baseplate','4K tube top','50K tube top');
xlabel('Date');
ylabel('Temperature [K]');
title('BA4 Run 2 Temperatures');

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print('ba4_run2_temp', '-dpng');
