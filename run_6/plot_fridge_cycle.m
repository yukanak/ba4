function plot_fridge_cycle(run, starttime, endtime, basetemp_starttime, basetemp_endtime)
% For first fridge cycle of run 4.6, run=6; starttime='221124 19:00:00'; endtime='221125 8:00:00'; basetemp_starttime=[2022,11,25,07,50,00]; basetemp_endtime=[2022,11,25,08,00,00];
% Second one: run=6; starttime='221128 22:30:00'; endtime='221129 :00:00'; basetemp_starttime=[2022,11,29,,,00]; basetemp_endtime=[2022,11,29,,,00];
% Plot fridge cycle
% Load data (can test in reduc/bicep3/, data files in arc/)
% To use, go to a directory with access to pipeline, and add this directory to startup.m there; then start MATLAB and type plot_fridge_cycle
d = load_arc(sprintf('/n/home04/yuka/ba4/run_%d/arc/', run), starttime, endtime, {'array.frame.utc', 'antenna0.frame.utc', 'antenna0.hk0.slow_temp'});

% Turn two field UTC into single column modified Julian date
f = make_utc_single_col(d);

% Create user friendly time vector
[y,m,d,h,mm,s] = mjd2date(f.antenna0.frame.utc(:,1));
time = datenum([y,m,d,h,mm,s]);

% Get the base temperatures; average over about 10 minutes
base_temps = [];
start_time = datenum(basetemp_starttime);
end_time = datenum(basetemp_endtime);
time_idx = find(time>start_time & time<end_time);

for therm = [1 2 3 4 5 6 7 8]
    base_temp = nanmean(f.antenna0.hk0.slow_temp(time_idx,therm));
    base_temps(therm) = base_temp;
    fprintf('Thermometer %d: %.2f K\n', therm, base_temp);
end

cycle_date = starttime(1:6)

% Create figure + plot
figure(1);
clf;
setwinsize(gcf,800,600);
plot(time, f.antenna0.hk0.slow_temp(:,1), 'k-');
hold on;
plot(time, f.antenna0.hk0.slow_temp(:,2), 'r-');
plot(time, f.antenna0.hk0.slow_temp(:,3), 'y-');
plot(time, f.antenna0.hk0.slow_temp(:,4), 'g-');
plot(time, f.antenna0.hk0.slow_temp(:,5), 'c-');
plot(time, f.antenna0.hk0.slow_temp(:,6), 'b-');
plot(time, f.antenna0.hk0.slow_temp(:,7), 'm-');
plot(time, f.antenna0.hk0.slow_temp(:,8), 'Color', [0.4940 0.1840 0.5560]);
legend(sprintf('He4 Pump (%.2f K)',base_temps(1)),sprintf('He3 Pump (%.2f K)',base_temps(2)),sprintf('He4 Switch (%.2f K)',base_temps(3)),sprintf('He3 Switch (%.2f K)',base_temps(4)),sprintf('He4 Condensation Point (%.2f K)',base_temps(5)),sprintf('He4 Evaporator (%.2f K)',base_temps(6)),sprintf('IC Evaporator (%.2f K)',base_temps(7)),sprintf('UC Evaporator (%.2f K)',base_temps(8)), 'Location', 'northeast');
xlabel('Time');
ylabel('Temperature [K]');
title(sprintf('BA4 Run %d %s Fridge Cycle Temperatures', run, cycle_date));

% Change x display to user friendly UTC
datetick('x', 'HH:MM', 'keeplimits');

% Save
print(sprintf('/n/home04/yuka/ba4/run_%d/ba4p%d_fridge_cycle_%s', run, run, cycle_date), '-dpng');

% Create figure + plot
figure(2);
clf;
setwinsize(gcf,800,600);
semilogy(time, f.antenna0.hk0.slow_temp(:,1), 'k-');
hold on;
semilogy(time, f.antenna0.hk0.slow_temp(:,2), 'r-');
semilogy(time, f.antenna0.hk0.slow_temp(:,3), 'y-');
semilogy(time, f.antenna0.hk0.slow_temp(:,4), 'g-');
semilogy(time, f.antenna0.hk0.slow_temp(:,5), 'c-');
semilogy(time, f.antenna0.hk0.slow_temp(:,6), 'b-');
semilogy(time, f.antenna0.hk0.slow_temp(:,7), 'm-');
semilogy(time, f.antenna0.hk0.slow_temp(:,8), 'Color', [0.4940 0.1840 0.5560]);
legend(sprintf('He4 Pump (%.2f K)',base_temps(1)),sprintf('He3 Pump (%.2f K)',base_temps(2)),sprintf('He4 Switch (%.2f K)',base_temps(3)),sprintf('He3 Switch (%.2f K)',base_temps(4)),sprintf('He4 Condensation Point (%.2f K)',base_temps(5)),sprintf('He4 Evaporator (%.2f K)',base_temps(6)),sprintf('IC Evaporator (%.2f K)',base_temps(7)),sprintf('UC Evaporator (%.2f K)',base_temps(8)), 'Location', 'southwest');
xlabel('Time');
ylabel('Temperature [K]');
title(sprintf('BA4 Run %d %s Fridge Cycle Temperatures', run, cycle_date));

% Change x display to user friendly UTC
datetick('x', 'HH:MM', 'keeplimits');

% Save
print(sprintf('/n/home04/yuka/ba4/run_%d/ba4p%d_fridge_cycle_%s_log', run, run, cycle_date), '-dpng');

return
