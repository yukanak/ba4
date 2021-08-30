% Plot 50K load curve
% Edit in the start time and end time
% In UTC!
d = load_arc('/n/home04/yuka/ba4/run_2/arc/', '210801 00:00:00', '210801 00:00:00'); %TODO

% First, just plot timestream
% Turn two field UTC into single column modified Julian date
f = make_utc_single_col(d);

% Create user friendly time vector
[y,m,d,h,mm,s] = mjd2date(f.antenna0.frame.utc(:,1));
time = datenum([y,m,d,h,mm,s]);

% Create figure + plot
figure(1);
clf;
setwinsize(gcf,800,600);
plot(time, f.antenna0.hk0.slow_temp(:,31), 'r-');
hold on;
plot(time, f.antenna0.hk0.slow_temp(:,32), 'b-');
legend('50K heat strap cold side','50K heat strap warm side');
xlabel('Time');
ylabel('Temperature [K]');
title('BA4 Run 2 50K Load Curve Temperatures');

% Change x display to user friendly UTC
datetick('x', 'mm/dd HH:MM', 'keeplimits');

% Save
print('/n/home04/yuka/ba4/run_2/ba4_run2_50k_load_curve_temp', '-dpng');

% Now make the power fitting plots
% Edit below
resistance = 200;
input_voltages = []; %TODO
input_powers = input_voltages.^2/resistance;
% Start times and end times of averaging for each input power
% Average over 10 minutes once temperature is steady
start_times = [datenum([2019,04,29,14,42,00]), ...
               datenum([2019,04,29,15,02,00])]; %TODO
end_times = [datenum([2019,04,29,14,52,00]), ...
               datenum([2019,04,29,15,12,00])]; %TODO

delta_t_inv = zeros(size(input_powers));
for ii = 1:length(start_times)
    time_i = start_times(ii);
    time_f = end_times(ii);
    time_idx = find(time>time_i & time<time_f);
    t_warm_avg = mean(f.antenna0.hk0.slow_temp(time_idx,32));
    t_cold_avg = mean(f.antenna0.hk0.slow_temp(time_idx,31));
    delta_t_inv(ii) = 1./t_cold_avg - 1./t_warm_avg;
end

% Linear fit
p = polyfit(delta_t_inv, input_powers, 1);
m = p(1);
b = p(2);
fit_line = m*delta_t_inv+b;

% Get the numbers
p_0 = -1*b;
k_0 = m;
g = k_0./(50.^2);
base_loading = (delta_t_inv(1) - input_powers(1)./m) * m;

% Plot
figure(2);
clf;
setwinsize(gcf,600,600);
plot(delta_t_inv, input_powers, 'k.');
hold on;
plot(delta_t_inv, fit_line, 'b-');
legend('BA 4.2 Data', sprintf('Fit: K_0 = %.2f W x K, Base Loading %.2f W', k_0, base_loading));
xlabel('1/T_C-1/T_H [1/K]');
ylabel('Applied Power [W]');
title(sprintf('BA4 Run 2 50K Load Curve: Conductance G = %.2f W/K @ 50K', g));

% Save
print('/n/home04/yuka/ba4/run_2/ba4_run2_50k_load_curve_fit', '-dpng');
