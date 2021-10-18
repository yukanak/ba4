% Plot temperature curve (all temperatures) for run 4.3
% Load data (can test in reduc/bicep3/, data files in arc/)
d = load_arc('/n/home04/yuka/ba4/run_3/arc/', '211018 18:30:00', '2110XX XX:XX:XX', {'array.frame.utc', 'antenna0.frame.utc', 'antenna0.hk0.slow_temp'});

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
legend('50K cold head','4K heat strap cold side','4K heat strap warm side','50K heat strap cold side','50K heat strap warm side','4K baseplate','4K tube top','50K tube top');
xlabel('Date');
ylabel('Temperature [K]');
title('BA4 Run 3 Temperatures');

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print('/n/home04/yuka/ba4/run_3/ba4p3_cooldown_all_lin', '-dpng');

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
legend('50K cold head','4K heat strap cold side','4K heat strap warm side','50K heat strap cold side','50K heat strap warm side','4K baseplate','4K tube top','50K tube top');
xlabel('Date');
ylabel('Temperature [K]');
title('BA4 Run 3 Temperatures');

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print('/n/home04/yuka/ba4/run_3/ba4p3_cooldown_all_log', '-dpng');

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
title('BA4 Run 3 4K Temperatures');

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print('/n/home04/yuka/ba4/run_3/ba4p3_cooldown_4k_lin', '-dpng');

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
title('BA4 Run 3 4K Temperatures');

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print('/n/home04/yuka/ba4/run_3/ba4p3_cooldown_4k_log', '-dpng');

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
title('BA4 Run 3 50K Temperatures');

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print('/n/home04/yuka/ba4/run_3/ba4p3_cooldown_50k_lin', '-dpng');

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
title('BA4 Run 3 50K Temperatures');

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print('/n/home04/yuka/ba4/run_3/ba4p3_cooldown_50k_log', '-dpng');

% Get the base temperatures
start_time = datenum([2021,09,01,16,00,00]); % TODO
end_time = datenum([2021,09,01,16,30,00]); % TODO
time_idx = find(time>start_time & time<end_time);

for diode = [29 30 31 32 33 34 35 36]
    temp_avg = nanmean(f.antenna0.hk0.slow_temp(time_idx,diode));
    fprintf('Thermometer %d: %.2f K\n', diode, temp_avg);
end
