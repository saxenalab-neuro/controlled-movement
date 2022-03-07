clear;clc;close all;


order = 4;


% Load ss, tf, and ss data
ssfilename = "sys_" + num2str(order) + "_ss.mat";
tffilename = "sys_" + num2str(order) + "_tf.mat";


sys_ss = load(ssfilename).sys_ss;
sys_tf = load(tffilename).sys_tf;

sys_ss.OutputName = 'y';
sys_tf.OutputName = 'y';


A = sys_ss.A;
B = sys_ss.B;
C = sys_ss.C;
D = sys_ss.D;
Ts = sys_ss.Ts;
x0 = [deg2rad(30); deg2rad(0)];


poles = eig(A);

figure(1)
pzmap(sys_ss);
figure(2)
pzmap(sys_tf);


% fprintf("System Characteristics:\n");
% 
% if (rank(ctrb(A,B)) == size(sys_ss.A, 1))
%     fprintf("The system is controllable\n");
% else
%     fprintf("The system is NOT controllable!\n");
% end
% 
% if (rank(obsv(A,C)) == size(sys_ss.A, 1))
%     fprintf("The system is observable\n");
% else
%     fprintf("The system is NOT observable!\n");
% end
% 
% fprintf("\n");



% --- CREATE TUNER --- %


G = sys_tf; % PLANT
%G.OutputName = 'y';

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
    tmpPI = tunablePID("PI" + int2str(i), 'pi');
    tmpPI.Ts = Ts;
    tmpPI.InputName = D.OutputName{i}; % Decoup Gain -> Controller
    tmpPI.OutputName = G.InputName{i}; % Controller -> Plant
    controllers{i} = tmpPI;
end

%clear tmpPI


% Create a summing block for the reference, error, and output signals
S = sumblk('e = r - y',2); % Error = Reference - Plant Output


% Connect the system and controller components together
C0 = connect(controllers{:},D,S,{'r','y'},G.InputName);


% Tune the control system
wc = [0.1 100]; % TAG: [TODO] fix 
[G,C,gam,Info] = looptune(G,C0,wc);


% Display the tuned controller parameters
showTunable(C);


% Construct a closed-loop model of the tuned control system
T = connect(G,C,'r','y');



% --- EVALUATE SYSTEM --- %

% Check the time-domain response for the control system with the tuned coefficients. Plot the step response from reference to output
figure('Name','Time-Domain Response','NumberTitle','off')
step(T)

% Examine the frequency-domain response of the tuned result as an alternative method for validating the tuned controller
figure('Name','Frequency-Domain Response','Position',[100,100,800,800],'NumberTitle','off')
loopview(G,C,Info)


systemfilename = "system_" + num2str(order) + ".mat";
save(systemfilename, 'C');
