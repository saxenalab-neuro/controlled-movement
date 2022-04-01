clear;clc; close all

warning('off', 'Control:tuning:TuningWarning1')


order = 10;


% Load transfer functions
tffilename = "../systems/sys_" + num2str(order) + "_tf.mat";
sys_tf = load(tffilename).sys_tf;
Ts = sys_tf.Ts;

G = sys_tf; % PLANT
G.OutputName = 'y';

numinputs = size(G.InputName, 1);
numoutputs = size(G.OutputName, 1);


% Separate inputs to pass through controllers
D = tunableGain('Decoupler', numinputs, numoutputs); % Decoup Gain
D.Ts = Ts;
D.InputName = 'e'; % Error -> Decoup Gain
D.OutputName = 'p'; % Decoup Gain -> Controller


% Make all the controllers
controllers = cell(numinputs,1); % Controller(s)

for i = 1:numinputs
    tmpPI = tunablePID("PI" + int2str(i), 'PI');
    tmpPI.Ts = Ts;
    tmpPI.InputName = D.OutputName{i}; % Decoup Gain -> Controller
    tmpPI.OutputName = G.InputName{i}; % Controller -> Plant
    controllers{i} = tmpPI;
end


% Create a summing block for the reference, error, and output signals
sum = sumblk('e = r - y',2); % Error = Reference - Plant Output


% Connect the system and controller components together
C0 = connect(controllers{:},D,sum,{'r','y'},G.InputName);

fprintf("Completed system setup\n\n");


% wc
% Vector specifying target crossover region [wcmin,wcmax].
% The looptune command attempts to tune all loops in the control system
% so that the open-loop gain crosses 0 dB within the target crossover region.
% A scalar wc specifies the target crossover region [wc/2,2*wc].




% Create range of crossover frequencies
lower = 1 * 10^-3;
upper = 5 * 10^2; % 500 = Nyquist frequency = 1/2 * sampling rate = 1/2 * 1000
range = zeros(16*10,1);
k = 1;

while lower < upper
    
    % Increment magnitude of lower
    for mag = 1:9
        if lower*mag >= upper
            break
        end
        
        range(k) = lower*mag;
        k = k + 1;
    end
    
    % Increment decade of lower if we can
    if lower*10 >= upper
        break
    else
        % Increment decade of lower
        lower = lower*10;
    end
end

range = range(range~=0); % Remove any additional zeros


names = ["Rise Time", "Settling Time", "Overshoot", "Peak"];

peaks = zeros(numel(range), numel(range), numel(names));

% Plot data in 3D plot
for i = 1:numel(range)
    for j = 1:numel(range)
        % j should never be less than i for the frequency crossover values
        if (j < i)
            continue
        end
        
        % Tune system
        wc = [range(i), range(j)];
        [G,C,gam,Info] = looptune(G,C0,wc);
        T = connect(G,C,'r','y');
        
        fprintf("Tested wc = [%g %g]\n", range(i), range(j));
        
        % Get step data
        S = stepinfo(T);
        peaks(i,j,1) = S.RiseTime;
        peaks(i,j,2) = S.SettlingTime;
        peaks(i,j,3) = S.Overshoot;
        peaks(i,j,4) = S.Peak;
        
    end
end

fprintf("\nEND\n");

%surf(range, range, peaks(:,:,1))
%set(gca,'XScale','log','YScale','log')




