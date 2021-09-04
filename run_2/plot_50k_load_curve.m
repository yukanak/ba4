% Plot 50K load curve
% Edit in the start time and end time
% In UTC!
d = load_arc('/n/home04/yuka/ba4/run_2/arc/', '210902 01:15:00', '210904 00:15:00',{'array.frame.utc', 'antenna0.frame.utc', 'antenna0.hk0.slow_temp'}); %TODO

resistance = 200;
input_currents = [0, 0.071, 0.099]; %TODO
input_powers = input_currents.^2.*resistance;
% Start times and end times of averaging for each input power
% Average over once temperature is steady
start_times = [datenum([2021,09,02,01,20,00]), ...
               datenum([2021,09,02,19,40,00]), ...
               datenum([2021,09,03,23,40,00])]; %TODO
end_times = [datenum([2021,09,02,01,30,00]), ...
             datenum([2021,09,02,19,50,00]), ...
             datenum([2021,09,03,23,50,00])]; %TODO

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
plot(time, f.antenna0.hk0.slow_temp(:,33), 'r-');
hold on;
plot(time, f.antenna0.hk0.slow_temp(:,32), 'b-');
for ii = 1:length(start_times)
    time_i = start_times(ii); 
    time_f = end_times(ii); 
    time_idx = find(time>time_i & time<time_f);
    plot(time(time_idx), f.antenna0.hk0.slow_temp(time_idx,33), 'g-');
end
plot(time, f.antenna0.hk0.slow_temp(:,32), 'b-');
for ii = 1:length(start_times)
    time_i = start_times(ii); 
    time_f = end_times(ii); 
    time_idx = find(time>time_i & time<time_f);
    plot(time(time_idx), f.antenna0.hk0.slow_temp(time_idx,32), 'g-');
end
legend('50K heat strap warm side','50K heat strap cold side', 'Location', 'northwest');
xlabel('Time');
ylabel('Temperature [K]');
title('BA4 Run 2 50K Load Curve Temperatures');

% Change x display to user friendly UTC
datetick('x', 'mm/dd', 'keeplimits');

% Save
print('/n/home04/yuka/ba4/run_2/ba4_run2_50k_load_curve_temp', '-dpng');

% Now make the power fitting plots
delta_t_inv = zeros(size(input_powers));
for ii = 1:length(start_times)
    time_i = start_times(ii);
    time_f = end_times(ii);
    time_idx = find(time>time_i & time<time_f);
    t_warm_avg = mean(f.antenna0.hk0.slow_temp(time_idx,33));
    t_cold_avg = mean(f.antenna0.hk0.slow_temp(time_idx,32));
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
legend('BA 4.2 Data', sprintf('Fit: K_0 = %.2f W x K, Base Loading %.2f W', k_0, base_loading), 'Location', 'southeast');
xlabel('1/T_C-1/T_H [1/K]');
ylabel('Applied Power [W]');
title(sprintf('BA4 Run 2 50K Load Curve: Conductance G = %.2f W/K @ 50K', g));

% Save
print('/n/home04/yuka/ba4/run_2/ba4_run2_50k_load_curve_fit', '-dpng');
