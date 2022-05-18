clear;clc;close all

% Poster Grapher


% data = [r_deg; y_deg; e_deg; u];
% save("Simulation 5 Data.mat", 'data')



% test = load("Simulation 5 Data.mat").data;

% Load DATA
data = zeros(14,10001,5);
data(:,:,1) = load("Simulation 4 Data.mat").data;
data(:,:,2) = load("Simulation 5 Data.mat").data;
data(:,:,3) = load("Simulation 1 Data.mat").data;
data(:,:,4) = load("Simulation 2 Data.mat").data;
data(:,:,5) = load("Simulation 3 Data.mat").data;

% Add end bit of data so it looks alright
for i = 1:5
    data(:,9981:10001,i) = repmat(data(:,9980,i),1,21);
end

data(6,:,1) = data(6,:,1) - (60 - data(6,:,1));
data(6,:,2) = data(6,:,2) - (130 - data(6,:,2));


% From Control Loop
ti = 0;
tf = 10;
Ts = 0.001; % Sampling time
t = ti:Ts:tf;


fig = figure('Name', 'Trajectory Tracking');
tlayout = tiledlayout(3,5, 'Padding', 'none');

% plot all positions 1 3 5
for i = 1:5
    % ax(i) = subplot(3,5,i);
    ax(i) = nexttile;
    
    % Reference, Output, Error
    plot(t, data(1,:,i), t, data(3,:,i), t, data(5,:,i), 'LineWidth', 2)
    yline(0,'k--')
end


% plot all velocities 2 4 6
for i = 1:5
    % ax(i+5) = subplot(3,5,i+5);
    ax(i+5) = nexttile;
    
    % Reference, Output, Error - But error is bad so don't plot it
    plot(t, data(2,:,i), t, data(4,:,i), 'LineWidth', 2)
    
    if i <= 2
        yline(0, '-', 'Color', [0, 0.4470, 0.7410], 'LineWidth', 2);
    end
    
    if i > 2
        yline(0,'k--')
    end
end


% plot all muscle excitations 7-14
for i = 1:5
    % ax(i+10) = subplot(3,5,i+10);
    ax(i+10) = nexttile;
    
    for j = 7:14
        plot(t, data(j,:,i), 'LineWidth', 2)
        hold on
    end
    
    yline(0,'k--')
    hold off
end

% X
linkaxes(ax(:),'x')
col1 = ax(1);
col1.XLim = [0 10];

% Pos Y
linkaxes(ax(1:5),'y')
row1 = ax(1);
row1.YLim = [-50 150];

% Vel Y
linkaxes(ax(6:10),'y')
row2 = ax(6);
row2.YLim = [-100 100];

% Exc Y
linkaxes(ax(11:15),'y')
row3 = ax(11);
row3.YLim = [-1 1];



%%%% FORMATTING %%%%

fontsize = 18; % 9 is default

leg1 = legend(ax(1), 'Reference', 'Output', 'Error');
leg2 = legend(ax(6), 'Reference', 'Output');
leg3 = legend(ax(11), 'TRI Long', 'TRI Lat', 'TRI Med', 'BIC Long', 'BIC Short', 'BRA', 'Shoulder Res', 'Elbow Res');


set(leg1, 'Location', 'south', 'Orientation', 'horizontal', 'FontSize', fontsize);
set(leg2, 'Location', 'south', 'Orientation', 'horizontal', 'FontSize', fontsize);
set(leg3, 'Location', 'south', 'Orientation', 'vertical', 'NumColumns', 3, 'FontSize', fontsize);


% [Line Dot] Change length so it's not absurdly long
leg1.ItemTokenSize = [10, 10];
leg2.ItemTokenSize = [10, 10];
leg3.ItemTokenSize = [10, 10];

%axpos = get(ax, 'Position');

row1_label = ylabel(ax(1), 'Elbow Position (deg)', 'FontWeight', 'bold', 'FontSize', fontsize);
row2_label = ylabel(ax(6), 'Elbow Velocity (deg/s)', 'FontWeight', 'bold', 'FontSize', fontsize);
row3_label = ylabel(ax(11), 'Muscle Excitations', 'FontWeight', 'bold', 'FontSize', fontsize);

%figax = axes(fig, 'Visible', 'off');
time_label = xlabel(ax(13), 'Time (s)', 'FontWeight', 'bold', 'FontSize', fontsize);

set(ax, 'FontSize', fontsize)



fprintf("WOW! All done!\n");