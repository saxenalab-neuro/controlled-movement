clear;clc;close all;

warning('off', 'Control:tuning:TuningWarning1')

doIgraph = true;
sysChars = false;
displayControllers = false;


savedir = "loops/";

% Check if directory exists, if not, mkdir
if not(isfolder(savedir))
    mkdir(savedir)
end


orders = 10:10; % For single order: just change to something like 13:13

for order=orders

% Load transfer functions
tffilename = "../systems/sys_" + num2str(order) + "_tf.mat";
sys_tf = load(tffilename).sys_tf;
Ts = sys_tf.Ts;


% Optional system characteristics
if (sysChars == true)
    ssfilename = "../systems/sys_" + num2str(order) + "_ss.mat";
    sys_ss = load(ssfilename).sys_ss;

    A = sys_ss.A;
    B = sys_ss.B;
    C = sys_ss.C;
    D = sys_ss.D;

    poles = eig(A);

    if (doIgraph == true)
        figure(1)
        pzmap(sys_ss);
        figure(2)
        pzmap(sys_tf);
    end

    fprintf("System Characteristics:\n");

    if (rank(ctrb(A,B)) == size(sys_ss.A, 1))
        fprintf("The system is controllable\n");
    else
        fprintf("The system is NOT controllable!\n");
    end

    if (rank(obsv(A,C)) == size(sys_ss.A, 1))
        fprintf("The system is observable\n");
    else
        fprintf("The system is NOT observable!\n");
    end
    fprintf("\n");

end 


% --- CREATE TUNER --- %


G = sys_tf; % PLANT
G.OutputName = 'y';

numinputs = size(G.InputName, 1);
numoutputs = size(G.OutputName, 1);


%r = cellfun(@(c)['desired_' c],G.OutputName,'uni',false); % Desired Reference signal aliases
%y = G.OutputName; % PLANT Output signal aliases
%e = cellfun(@(c)['e_' c],G.OutputName,'uni',false); % Error signal aliases


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
S = sumblk('e = r - y',2); % Error = Reference - Plant Output


% Connect the system and controller components together
C0 = connect(controllers{:},D,S,{'r','y'},G.InputName);


% Tune the control system
wc = [50 500]; % TAG: [TODO] fix 
[G,C,gam,Info] = looptune(G,C0,wc);


% Display the tuned controller parameters
if (displayControllers == true)
    showTunable(C);
end


% Construct a closed-loop model of the tuned control system
T = connect(G,C,'r','y');


% --- EVALUATE SYSTEM --- %

if (doIgraph == true)
    % Check the time-domain response for the control system with the tuned coefficients. Plot the step response from reference to output
    figure('Name','Time-Domain Response','NumberTitle','off')
    step(T)
    S = stepinfo(T, 'SettlingTimeThreshold', 0.05);
    risetime = S.RiseTime
    settlingtime = S.SettlingTime
    overshoot = S.Overshoot

    % Examine the frequency-domain response of the tuned result as an alternative method for validating the tuned controller
    figure('Name','Frequency-Domain Response','Position',[100,100,800,800],'NumberTitle','off')
    loopview(G,C,Info)
end


% --- SAVE RESULTS --- %

% Save closed loop
closedloopfilename = savedir + "closedloop_" + num2str(order) + ".mat";
save(closedloopfilename, 'T');


% Save Decoupler and Controllers
Blocks_cell = struct2cell(T.Blocks);
controllers = cell(1,numel(Blocks_cell)-1);

for i=2:numel(Blocks_cell)
    controllers{i-1} = pid(Blocks_cell{i});
end

% Get gain values
Kp = zeros(numel(controllers),1);
Ki = zeros(numel(controllers),1);
Kd = zeros(numel(controllers),1);

for i=1:numel(controllers)
    Kp(i) = controllers{i}.Kp;
    Ki(i) = controllers{i}.Ki;
    Kd(i) = controllers{i}.Kd;
end


gain.D = T.Blocks.Decoupler.Gain.Value;
gain.controllers = controllers;
gain.Kp = Kp;
gain.Ki = Ki;
gain.Kd = Kd;

controllersfilename = savedir + "controllers_" + num2str(order) + ".mat";
save(controllersfilename, 'gain');

end

if (doIgraph == false)
    close all
end
