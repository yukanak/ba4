% Plot UC load curve
% Edit in the start time and end time
% In UTC!
d = load_arc('/n/holylfs04/LABS/kovac_lab/bicep_array/ba4daq/arc/', '230511 18:00:00', '230512 04:15:00', {'array.frame.utc', 'antenna0.frame.utc', 'antenna0.hk0.slow_temp'});

resistance = 100000;
input_voltages = [0, 1.39, 1.96, 2.40, 2.77, 2.65, 1.70, 1.00, 0.50];
% Use current for power calculation because significant resistance in cables
input_powers = input_voltages.^2./resistance;
% Start times and end times of averaging for each input power
% Average over 1 minute once temperature is steady
start_times = [datenum([2023,05,11,18,15,00]), ...
               datenum([2023,05,11,19,12,00]), ...
               datenum([2023,05,11,21,04,00]), ...
               datenum([2023,05,11,21,55,00]), ...
               datenum([2023,05,11,22,39,00]), ...
               datenum([2023,05,11,23,56,00]), ...
               datenum([2023,05,12,01,08,00]), ...
               datenum([2023,05,12,02,58,00]), ...
               datenum([2023,05,12,04,14,00]), ...
               ];
end_times = [datenum([2023,05,11,18,16,00]), ...
             datenum([2023,05,11,19,13,00]), ...
             datenum([2023,05,11,21,05,00]), ... 
             datenum([2023,05,11,21,56,00]), ... 
             datenum([2023,05,11,22,40,00]), ... 
             datenum([2023,05,11,23,57,00]), ...
             datenum([2023,05,12,01,09,00]), ...
             datenum([2023,05,12,02,59,00]), ...
             datenum([2023,05,12,04,15,00]), ...
             ];

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
% UC plate center
plot(time, f.antenna0.hk0.slow_temp(:,18), 'r-');
hold on;
% UC strap dirty
%plot(time, f.antenna0.hk0.slow_temp(:,20), 'b-');
% UC evap
plot(time, f.antenna0.hk0.slow_temp(:,8), 'b-');
for ii = 1:length(start_times)
    time_i = start_times(ii);
    time_f = end_times(ii);
    time_idx = find(time>time_i & time<time_f);
    plot(time(time_idx), f.antenna0.hk0.slow_temp(time_idx,18), 'g-');
end
for ii = 1:length(start_times)
    time_i = start_times(ii);
    time_f = end_times(ii);
    time_idx = find(time>time_i & time<time_f);
    %plot(time(time_idx), f.antenna0.hk0.slow_temp(time_idx,20), 'g-');
    plot(time(time_idx), f.antenna0.hk0.slow_temp(time_idx,8), 'g-');
end
%legend('UC plate center','UC strap dirty', 'Location', 'northwest');
legend('UC plate center','UC evap', 'Location', 'northwest');
xlabel('Time');
ylabel('Temperature [K]');
title('BA4 Run 8 UC Load Curve Temperatures');

% Change x display to user friendly UTC
datetick('x', 'mm/dd HH:MM', 'keeplimits');

% Save
%print('/n/home04/yuka/ba4/run_8/ba4_run8_uc_load_curve_temp_uc_strap_dirty', '-dpng');
print('/n/home04/yuka/ba4/run_8/ba4_run8_uc_load_curve_temp_uc_evap', '-dpng');

% Now make the power fitting plots
delta_t_squared = zeros(size(input_powers));
for ii = 1:length(start_times)
    time_i = start_times(ii);
    time_f = end_times(ii);
    time_idx = find(time>time_i & time<time_f);
    t_warm_avg = mean(f.antenna0.hk0.slow_temp(time_idx,18));
    %t_cold_avg = mean(f.antenna0.hk0.slow_temp(time_idx,20));
    t_cold_avg = mean(f.antenna0.hk0.slow_temp(time_idx,8));
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
legend('BA 4.8 Data', sprintf('Fit: K_0 = %.2f W/K^2, Base Loading %.2f W', k_0, base_loading));
xlabel('T_H^2-T_C^2 [K^2]');
ylabel('Applied Power [W]');
title(sprintf('BA4 Run 8 UC Load Curve: Conductance G = %.2f W/K @ 4K', g));

% Save
%print('/n/home04/yuka/ba4/run_8/ba4_run8_uc_load_curve_fit_uc_strap_dirty', '-dpng');
print('/n/home04/yuka/ba4/run_8/ba4_run8_uc_load_curve_fit_uc_evap', '-dpng');
