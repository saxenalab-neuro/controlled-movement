if (exist('myapp', 'var'))
    delete(myapp)
end

clear;clc;close all

warning('off','Control:analysis:LsimStartTime') % Turn off warning about lsim start time not being 0


% Variables to control

toolspathname = "../Tools/";
system_order = 10;
batchsize = 20;

muscles = ["TRIlong", "TRIlat", "TRImed", "BIClong", "BICshort", "BRA", "shoulder_res", "elbow_res"];
Pgain = 0.017 .* [1 1 1 1 1 1 1 1]';
Igain = 0.03 .* [1 1 1 1 1 1 1 1]';
Dgain = 1 .* [1 1 1 1 1 1 1 1]';
n_int = 100;
n_diff = 2;



% --- SETUP OPENSIM, FORWARD DYNAMICS TOOL, AND FILES --- %

% Setup OpenSim
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:/OpenSim 4.2/Geometry'); % Add geometry to remove visualization error
model = Model("../arm26.osim"); % Add the model

% Remove previous entries in the opensim.log file
fid = fopen("opensim.log", 'w');
fclose(fid);

% Setup Forward Dynamics tool
fdSetup = toolspathname + "fd_loop_setup.xml";
forwardTool = ForwardTool(fdSetup); % Initialize Forward Tool



% --- IMPORT CONTROLLERS --- %

controllersfilename = "controller_tuning/loops/controllers_" + num2str(system_order) + ".mat"; % Import from specified system number
gain = load(controllersfilename).gain;
D = gain.D;
controllers = gain.controllers;
Kp = gain.Kp;
Ki = gain.Ki;
Kd = gain.Kd;



% --- IMPORT TRANSFER FUNCTIONS --- %

tffilename = "systems/sys_" + num2str(system_order) + "_tf.mat";
sys_tf = load(tffilename).sys_tf;

% Import estimated initial states
x0filename = "systems/sys_" + num2str(system_order) + "_report.mat";
x0 = load(x0filename).report.Parameters.X0;



% --- INITIALIZE STATES --- %

ti = 0;
tf = 10;
Ts = 0.001; % Sampling time
t = ti:Ts:tf;

% K acts as my time index
k = 1;
dk = batchsize;
current_batch = k:k-1+dk;



% --- INITIAL CONDITIONS --- %

despos = repmat(deg2rad(60), 1, numel(t)); % Desired position [rad] - reference(1)
desvel = repmat(deg2rad(0), 1, numel(t)); % Desired velocity [rad/s] - reference(2)
r = [despos; desvel]; % Reference (desired)
r_deg = rad2deg(r);


% --- STARTUP CONTROL APP --- %

ds = DataStorage();
myapp = control_loop_visualizer(ds);

% Wait until I can proceed - user has selected a reference signal
% Give uiwait a figure handle, it will wait until it is closed or uiresume is used in here or in the app

uiwait(myapp.ControlLoopAppUIFigure);
fprintf("Waiting...\n");

% Waiting for uiresume(myapp.ControlLoopAppUIFigure) to be called from from either start button callback

if (myapp.startSimulation == true)
    % Get reference signal
    [r, r_deg, ti, tf] = myapp.getRefSignal(); % Override defaults with real signal
    t = ti:Ts:tf; % Set time array % [TAG] HARDCODED: Allow Ts to be set from within app
else
    error("CRIT_ERR: NO REFERENCE SIGNAL???\n")
end



% --- PREALLOCATE ARRAYS --- %

y = zeros(2,numel(t)); % Output in radians (measured)
y_deg = zeros(2,numel(t)); % Output in degrees (measured)
y_sim = zeros(2,numel(t)); % Output (simulated)
y_sim_deg = zeros(2,numel(t)); % Output in degrees(simulated)
e = zeros(2,numel(t)); % Error
d = zeros(8,numel(t)); % Decoupled gain
di = zeros(8,numel(t)); % Integral error
dd = zeros(8,numel(t)); % Derivative error
u = zeros(8,numel(t)); % Command signal - Muscle contractions 0 to 1


% --- INITIALIZE SIGNALS --- %

initCumulativeFiles(); % Initialize cumulative files


% Output of plant (measured)
y(:,current_batch) = initial_states_reader(dk, ti, Ts); % Get initial states
y_deg(:,current_batch) = rad2deg(y(:,current_batch)); % Calculate degree signal

% Error (difference)
e(:,current_batch) = r(:,current_batch) - y(:,current_batch); % [position in rad, velocity in rad/s]


k = k + dk; % Increment time batch
current_batch = k:k-1+dk;


% --- SET UP GRAPHS --- %

f_out = figure('Name', 'Output versus Reference');

% Position Graph
subplot(2,1,1)
p_pos = plot(t(1:k-1), r_deg(1,1:k-1), t(1:k-1), y_deg(1,1:k-1), t(1:k-1), rad2deg(e(1,1:k-1)), t(1:k-1), u(1,1:k-1));

xlim([0 10])
ylim([-30 210])
legend('Reference', 'Output', 'Error', 'Command')
xlabel('Time (s)')
ylabel('Position (degrees)')
axis manual


% Velocity Graph 
subplot(2,1,2)
p_vel = plot(t(1:k-1), r_deg(2,1:k-1), t(1:k-1), y_deg(2,1:k-1), t(1:k-1), rad2deg(e(2,1:k-1)), t(1:k-1), u(2,1:k-1));

xlim([0 10])
ylim([-250 250])
legend('Reference', 'Output', 'Error', 'Command')
xlabel('Time (s)')
ylabel('Velocity (degrees/s)')
axis manual


% % --- Create Simulated Test Graph --- %
% 
% f_sim = figure('Name', 'Simulated');
% 
% % Position Graph
% subplot(2,1,1)
% s_pos = plot(t(1:k-1), y_sim_deg(1,1:k-1));
% 
% % Velocity Graph
% subplot(2,1,2)
% s_vel = plot(t(1:k-1), y_sim_deg(2,1:k-1));



% --- UPDATE APP GRAPHS --- %

pos_graph.t = t(1:k-1);
pos_graph.r = r_deg(1,1:k-1);
pos_graph.y = y_deg(1,1:k-1);
pos_graph.ysim = y_sim_deg(1,1:k-1);

vel_graph.t = t(1:k-1);
vel_graph.r = r_deg(2,1:k-1);
vel_graph.y = y_deg(2,1:k-1);
vel_graph.ysim = y_sim_deg(2,1:k-1);

myapp.updateGraphs(pos_graph, vel_graph);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ----- RUN CONTROL LOOP!!! ----- %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while k < numel(t)-1-dk % Do for each time batch until the end
    
    previous_batch = current_batch;
    current_batch = k:k-1+dk;
    next_batch = k+dk:k-1+2*dk;
    
    
    % --- SIGNALS --- %
    
    for i=current_batch
        % Get reference signal from app / slider
        [r(:,i), r_deg(:,i)] = myapp.updateRef(r_deg(:,i));
        
        % Summing Junction
        e(:,i) = r(1,i) - y(:,i-dk); % But y is calculated in batches so go find previous value

        % Decoupled Gain
        d(:,i) = D * e(:,i);

        % Calculate integral error
        di(:,i) = di(:,i-1) + Ts * d(:,i-1); % i-1 refers to the previous batch

        % Calculate derivative error
        dd(:,i) = (d(:,i-1) - d(:,i-n_diff)) / (t(i-1) - t(i-n_diff)); % difference in value over difference in time

        % Calculate command signal (muscle signals)
        u(:,i) = Pgain .* Kp .* d(:,i) + Igain .* Ki .* di(:,i) + Dgain .* Kd .* dd(:,i);
        % Referenced from https://tttapa.github.io/Pages/Arduino/Control-Theory/Motor-Fader/PID-Controllers.html#derivative-filtering
        
        % In range and coerce
        u(:,i) = max(min(u(:,i),1),-1);
    end
    
    
    % --- FORWARD TOOL --- %
    
    % Run Forward Tool for this time step
    % y is output, so this state's output should be part of this batch, not next batch
    y(:,current_batch) = forwardtoolloop(forwardTool, transpose(u(:,current_batch)), t(k+1), t(k+dk));
    y_deg(:,current_batch) = rad2deg(y(:,current_batch)); % Calculate degree signal
    
    
    % --- RESULTS --- %
    
%     figure(f_out)
%     
    % Position graph data
    p_pos(1).XData = t(1:k-1);
    p_pos(1).YData = r_deg(1,1:k-1);
    
    p_pos(2).XData = t(1:k-1);
    p_pos(2).YData = y_deg(1,1:k-1);
    
    p_pos(3).XData = t(1:k-1);
    p_pos(3).YData = rad2deg(e(1,1:k-1));
    
    p_pos(4).XData = t(1:k-1);
    p_pos(4).YData = u(1,1:k-1);
    
    % Velocity graph data
    p_vel(1).XData = t(1:k-1);
    p_vel(1).YData = r_deg(2,1:k-1);
    
    p_vel(2).XData = t(1:k-1);
    p_vel(2).YData = y_deg(2,1:k-1);
    
    p_vel(3).XData = t(1:k-1);
    p_vel(3).YData = rad2deg(e(2,1:k-1));
    
    p_vel(4).XData = t(1:k-1);
    p_vel(4).YData = u(2,1:k-1);
%     
%     
%     
%     figure(f_sim)
%     
%     % Position graph data
%     s_pos.XData = t(current_batch);
%     s_pos.YData = y_sim_deg(1,current_batch);
%     
%     % Velocity graph data
%     s_vel.XData = t(current_batch);
%     s_vel.YData = y_sim_deg(2,current_batch);
%     
%     
    % Refresh graphs
    drawnow
    
    
    % Update app graphs
    pos_graph.t = t(current_batch);
    pos_graph.r = r_deg(1,current_batch);
    pos_graph.y = y_deg(1,current_batch);
    pos_graph.ysim = y_sim_deg(1,current_batch);
    
    vel_graph.t = t(current_batch);
    vel_graph.r = r_deg(2,current_batch);
    vel_graph.y = y_deg(2,current_batch);
    vel_graph.ysim = y_sim_deg(2,current_batch);
    
    myapp.updateGraphs(pos_graph, vel_graph)
    
    
    k = k + dk; % Onto the next time step!
end

% --- SIMULATION --- %

% y_sim = transpose(lsim(sys_tf, u, t, x0));
% y_sim_deg = rad2deg(y_sim); % Calculate degree signal

% simOpt = simOptions('InitialCondition',x0);
% [y_sim_test, y_sim_test_sd] = sim(sys_tf,u,simOpt);

