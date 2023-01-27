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
calibrated_cernox_id = 'X154090';
cernoxes_uncal = [13 14 16 17]; % S10 (15) has no daughter card, as with S3 (10); note S4 (11) is acting weird so I'm taking it out
cernoxes_uncal_id = {'X148294' 'X148364' 'X148362' 'X148365'};
%dc_cal_G_calibrated = 200.325; % S5 has daughter card C10B
%dc_cal_V0_calibrated = 0.00208
dc_cal_G = [200.432,402.281,199.941,400.314]; % S4 has C10A, S8 has C11B, S9 has C35B, S11 has C11A, S12 has C35A
dc_cal_V0 = [0.00144,-0.00014,0.00147,0.00324];
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
legend('Duband UC', 'S5', 'S8', 'S9', 'S11', 'S12')
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
    %[unique_temp, ia, ic] = unique(sorted_new_cal(:,2));
    %final_new_cal = [accumarray(ic,sorted_new_cal(:,1),[],@mean), unique_temp];

    % Average together every 0.5 mK
    tempstart = sorted_new_cal(1,2);
    tempend = sorted_new_cal(length(uncalibrated_res),2);
    num = floor((tempend - tempstart)/0.0005 + 1);
    temp_bin_edges = linspace(tempstart, tempend, num);
    spacing = (tempend - tempstart)/(num - 1);
    temp_bin_centers = temp_bin_edges(1:length(temp_bin_edges)-1) + spacing/2;
    final_new_cal = zeros(length(temp_bin_centers),2);
    final_new_cal(:,2) = temp_bin_centers;
    for j = 1:length(temp_bin_centers)
        idx_bin = find(sorted_new_cal(:,2) >= temp_bin_edges(j) & sorted_new_cal(:,2) < temp_bin_edges(j+1));
        final_new_cal(j,1) = mean(sorted_new_cal(idx_bin, 1));
    end

    %figure(2);
    %clf;
    %loglog(final_new_cal(:,2), final_new_cal(:,1))
    %xlabel('Temperature')
    %ylabel('Resistance')

    % Make monotonic
    while ~all(diff(final_new_cal(:,1)) <= 0)
        disp(sprintf('%i points where Cernox %i is not monotonically decreasing in resistance...', length(find(diff(final_new_cal(:,1)) > 0)), c))
        throw_away_temps = final_new_cal(find(diff(final_new_cal(:,1)) > 0)+1, 2);
        disp(sprintf('Temperature %.3f is the smallest non-monotonic points', throw_away_temps(1)))
        idx_good = find(diff(final_new_cal(:,1)) <= 0)+1;
        final_new_cal = final_new_cal(idx_good, :);
    end

    % Save
    final_new_cal = transpose(final_new_cal);
    filepath = sprintf('/n/home04/yuka/ba4/thermometers/R2T_%s_calibrated_with_%s.interp', char(cernoxes_uncal_id(i)), calibrated_cernox_id);
    formatSpec = '%.6f %.6f\n';
    fileID = fopen(filepath,'w');
    fprintf(fileID, formatSpec, final_new_cal);
    fclose(fileID);
end

return
