% Plot 4K load curve
% Edit in the start time and end time
% In UTC!
d = load_arc('/n/home04/yuka/ba4/run_2/arc/', '210901 20:00:00', '210902 00:30:00', {'array.frame.utc', 'antenna0.frame.utc', 'antenna0.hk0.slow_temp'}); %TODO

resistance = 200;
input_currents = [0, 0.022, 0.032, 0.039, 0.045, 0.050]; %TODO
% Use current for power calculation because significant resistance in cables
input_powers = input_currents.^2.*resistance;
% Start times and end times of averaging for each input power
% Average over 10 minutes once temperature is steady
start_times = [datenum([2021,09,01,20,15,00]), ...
               datenum([2021,09,01,21,00,00]), ...
               datenum([2021,09,01,21,45,00]), ...
               datenum([2021,09,01,22,30,00]), ...
               datenum([2021,09,01,23,15,00]), ...
               datenum([2021,09,02,00,00,00])]; %TODO
end_times = [datenum([2021,09,01,20,25,00]), ...
             datenum([2021,09,01,21,10,00]), ...
             datenum([2021,09,01,21,55,00]), ... 
             datenum([2021,09,01,22,40,00]), ... 
             datenum([2021,09,01,23,25,00]), ... 
             datenum([2021,09,02,00,10,00])]; %TODO

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
for ii = 1:length(start_times)
    time_i = start_times(ii);
    time_f = end_times(ii);
    time_idx = find(time>time_i & time<time_f);
    plot(time_idx, f.antenna0.hk0.slow_temp(time_idx,31), 'Color', [0.8500 0.3250 0.0980]);
end
plot(time, f.antenna0.hk0.slow_temp(:,30), 'b-');
for ii = 1:length(start_times)
    time_i = start_times(ii);
    time_f = end_times(ii);
    time_idx = find(time>time_i & time<time_f);
    plot(time_idx, f.antenna0.hk0.slow_temp(time_idx,30), 'Color', [0.8500 0.3250 0.0980]);
end
legend('4K heat strap warm side','4K heat strap cold side');
xlabel('Time');
ylabel('Temperature [K]');
title('BA4 Run 2 4K Load Curve Temperatures');

% Change x display to user friendly UTC
datetick('x', 'mm/dd HH:MM', 'keeplimits');

% Save
print('/n/home04/yuka/ba4/run_2/ba4_run2_4k_load_curve_temp', '-dpng');

% Now make the power fitting plots
delta_t_squared = zeros(size(input_powers));
for ii = 1:length(start_times)
    time_i = start_times(ii);
    time_f = end_times(ii);
    time_idx = find(time>time_i & time<time_f);
    t_warm_avg = mean(f.antenna0.hk0.slow_temp(time_idx,31));
    t_cold_avg = mean(f.antenna0.hk0.slow_temp(time_idx,30));
    delta_t_squared(ii) = t_warm_avg.^2 - t_cold_avg.^2;
end

% Linear fit
p = polyfit(delta_t_squared, input_powers, 1);
m = p(1);
b = p(2);
fit_line = m*delta_t_squared+b;

% Get the numbers
p_0 = -1*b;
k_0 = 2*m;
g = k_0*4;
base_loading = (delta_t_squared(1) - input_powers(1)./m) * m;

% Plot
figure(2);
clf;
setwinsize(gcf,600,600);
plot(delta_t_squared, input_powers, 'k.');
hold on;
plot(delta_t_squared, fit_line, 'b-');
legend('BA 4.2 Data', sprintf('Fit: K_0 = %.2f W/K^2, Base Loading %.2f W', k_0, base_loading));
xlabel('T_H^2-T_C^2 [K^2]');
ylabel('Applied Power [W]');
title(sprintf('BA4 Run 2 4K Load Curve: Conductance G = %.2f W/K @ 4K', g));

% Save
print('/n/home04/yuka/ba4/run_2/ba4_run2_4k_load_curve_fit', '-dpng');
