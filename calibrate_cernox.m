function calibrate_cernox(run,starttime,endtime)
% For example, run=6; starttime='230103 22:00:00'; endtime='230105 23:30:00';
% Or run=6; starttime='230104 15:15:00'; endtime='230105 16:00:00';

% Load data (can test in reduc/bicep3/, data files in arc/)
% To use, go to a directory with access to pipeline, and add this directory to startup.m there; then start MATLAB and type plot_temperatures(args)
d = load_arc(sprintf('/n/home04/yuka/ba4/run_%d/arc', run), starttime, endtime, {'antenna0.frame.utc', 'antenna0.hk0.slow_temp', 'antenna0.hk0.slow_voltage'});

% Turn two field UTC into single column modified Julian date
f = make_utc_single_col(d);

% Create user friendly time vector
[y,m,d,h,mm,s] = mjd2date(f.antenna0.frame.utc(:,1));
time = datenum([y,m,d,h,mm,s]);

%%%%%%%%%% EDIT BELOW %%%%%%%%%%
calibrated_cernox = 12; % Index of calibrated Cernox; for run 6, the Duband Cernox was 8 and David's fully calibrated ones were 10, 11, 12
cernoxes_uncal = [11 13 14 16 17]; % S10 (15) has no daughter card, as with S3 (10); note S4 (11) is acting weird
%dc_cal_G_calibrated = 200.325; % S5 has daughter card C10B
%dc_cal_V0_calibrated = 0.00208
dc_cal_G = [199.689,200.432,402.281,199.941,400.314]; % S4 has C10A, S8 has C11B, S9 has C35B, S11 has C11A, S12 has C35A
dc_cal_V0 = [0.00314,0.00144,-0.00014,0.00147,0.00324];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

starttime = datenum(strcat('20',starttime(1:2),'-',starttime(3:4),'-',starttime(5:end)));
endtime = datenum(strcat('20',endtime(1:2),'-',endtime(3:4),'-',endtime(5:end)));
% Try plotting
figure(1);
setwinsize(gcf,800,600);
clf
plot(time, f.antenna0.hk0.slow_temp(:, 8));
hold all;
plot(time, f.antenna0.hk0.slow_temp(:, calibrated_cernox));
for i = cernoxes_uncal
    plot(time, f.antenna0.hk0.slow_temp(:,i));
end
% Change x display to user friendly UTC
datetick('x', 'mm/dd HH:MM', 'keeplimits');
xlabel('Time');
ylabel('Temperature [K]');
title(sprintf('BA4 Run %d Cernox Temperatures', run));
%% Edit this too %%
legend('Duband UC', 'S5', 'S4', 'S8', 'S9', 'S11', 'S12')
% Save
print(sprintf('/n/home04/yuka/ba4/run_%d/ba4p%d_cernoxtemps', run, run), '-dpng');
%%%%%%%%%%%%%%%%%%%

% Smooth before calibrating (average every couple data points)
calibrated_temp = smooth(f.antenna0.hk0.slow_temp(:,calibrated_cernox), 10);
% Calibration
for i = 1:length(cernoxes_uncal)
    c = cernoxes_uncal(i);
    % Account for daughter card calibrations
    G = dc_cal_G(i);
    V0 = dc_cal_V0(i);
    uncalibrated_voltage = smooth(f.antenna0.hk0.slow_voltage(:,c), 10);
    uncalibrated_res = G ./ (uncalibrated_voltage - V0); % V = G/R + V0
    new_cal = [uncalibrated_res, calibrated_temp];
    % Sort in ascending temperature order
    sorted_new_cal = sortrows(new_cal, 2);
    % Make it non-redundant
    % https://www.mathworks.com/matlabcentral/answers/116969-how-to-average-a-column-based-on-another-column
    [unique_temp, ia, ic] = unique(sorted_new_cal(:,2));
    final_new_cal = [accumarray(ic,sorted_new_cal(:,1),[],@mean), unique_temp];

    %figure(2);
    %clf;
    %plot(



    a = 0;
    % Check if resistance is monotonically decreasing
    for j = 1:length(final_new_cal)-1
        if final_new_cal(j,1) > final_new_cal(j+1,1)
            a = a+1;
            %disp(sprintf('NOT MONOTONICALLY DESCREASING FOR CERNOX %i at index %i', c, j))
        end
    end
    disp(a)
    % Save
    
end



return
