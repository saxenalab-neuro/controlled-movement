clear;clc;close all

doIplot = true;

elbow_ic = 30;

ti = 0; % TAG: [HARDCODED]
t_ic = 0.1;
tf = 10; % TAG: [HARDCODED]
Ts = 0.001; % TAG: [HARDCODED]

% Output Parameters
t = ti:Ts:tf; % Set time array
shoulder = zeros(1,numel(t)); % Set shoulder values

% Create motiondata struct
signal.ti = ti;
signal.tf = tf;
signal.Ts = Ts;
signal.t = t;

numsignals = 10;

addpath("C:\Users\Jaxton\OneDrive\controlled-movement\HPGM\scripts")

if doIplot == true
    figure('Name','States')
end

% ----- CREATE THE MOTION FILE ----- %

rng(tic/10000)

for number = 1:numsignals
    % Create Motion Data and store it
    [error, elbow] = modfuncmaker(randi([(tf-ti), (tf-ti)*3]), ti, tf-t_ic, Ts, true, 30);
    
    % Keep going till we get good functions
    while error == 1
        [error, elbow] = modfuncmaker(randi([(tf-ti), (tf-ti)*3]), ti, tf-t_ic, Ts, true, 30);
    end
    
    % Position
    pos_ic = repmat(elbow_ic, 1 , t_ic/Ts);
    pos = [pos_ic, elbow];
    pos = transpose(smooth(pos, 40));
    
    % Velocity
    vel = diff([30, pos]) / Ts; %  Added an extra point at the beginning since real IC is 30, makes the vectors the same length.
    
    if doIplot == true
        subplot(1,2,1)
        plot(t, pos)
        xlabel('Time (s)')
        ylabel('Position (deg)')
        hold on
        
        subplot(1,2,2)
        plot(t, vel)
        xlabel('Time (s)')
        ylabel('Velocity (deg/s)')
        hold on
    end
    
    signal.data = [pos; vel];
    
    % --- Save as motion file ---- %
    % Motion File directory and filename
    signaldir = "C:/Users/Jaxton/OneDrive/controlled-movement/Control System/input_signals/";
    signalfilename = signaldir + "sig_" + num2str(number) + ".mat";
    
    save(signalfilename, 'signal');
end

legend('1','2','3','4','5')
hold off