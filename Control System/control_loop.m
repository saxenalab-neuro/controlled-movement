if (exist('myapp', 'var'))
    delete(myapp)
end

clear;clc;close all



toolspathname = "../Tools/";
system_order = 9;

% % Parse inputs
% if nargin == 2
%     if (strcmp(varargin{1},'ToolsPath'))
%         toolspathname = varargin{2};
%     end
% end



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

controllersfilename = "controller_tuning/system_" + num2str(system_order) + ".mat";
Blocks = load(controllersfilename).C.Blocks;

D = Blocks.Decoupler.Gain.Value;

Blocks_cell = struct2cell(Blocks);
controllers = cell(1,numel(Blocks_cell)-1);

for i=2:numel(Blocks_cell)
    controllers{i-1} = pid(Blocks_cell{i});
end


Kp = zeros(numel(controllers),1);
Ki = zeros(numel(controllers),1);
Kd = zeros(numel(controllers),1);

for i=1:numel(controllers)
    Kp(i) = controllers{i}.Kp;
    Ki(i) = controllers{i}.Ki;
    Kd(i) = controllers{i}.Kd;
end

clear Blocks_cell Blocks s i




%%%%% --- SYSTEM LOOP --- %%%%%



        



% --- INITIALIZE STATES --- %

ti = 0;
tf = 10;
Ts = 0.001; % Sampling time
t = ti:Ts:tf;

% K acts as my time index
k = 1;
dk = 200;
current_batch = k:k-1+dk;


% --- INITIAL CONDITIONS --- %

despos = repmat(deg2rad(60), 1, numel(t)); % Desired position [rad] - reference(1)
desvel = repmat(deg2rad(0), 1, numel(t)); % Desired velocity [rad/s] - reference(2)
r = [despos; desvel]; % Reference (desired)


% --- STARTUP CONTROL APP --- %

ds = DataStorage();
myapp = control_loop_visualizer(ds);

% Wait until I can proceed - user has selected a reference signal
% Give uiwait a figure handle, it will wait until it is closed or uiresume is used in here or in the app

uiwait(myapp.ControlLoopAppUIFigure);
fprintf("Waiting...");

% Waiting for uiresume(myapp.ControlLoopAppUIFigure) to be called from from either start button callback

if (myapp.startSimulation == true)
    % Get reference signal
    [r, ti, tf] = myapp.getRefSignal(); % Override defaults with real signal
    t = ti:Ts:tf; % Set time array
else
    error("CRIT_ERR: NO REFERENCE SIGNAL???")
end


% --- PREALLOCATE ARRAYS --- %

y = zeros(2,numel(t)); % Output (measured)
e = zeros(2,numel(t)); % Error
d = zeros(8,numel(t)); % Decoupled gain
di = zeros(8,numel(t)); % Integral error
u = zeros(8,numel(t)); % Command signal - Muscle contractions 0 to 1

% Create mirror signals, but in degrees
r_deg = rad2deg(r);
y_deg = rad2deg(y);


% --- INITIALIZE SIGNALS --- %

initCumulativeFiles(); % Initialize cumulative files


% Output of plant (measured)
y(:,current_batch) = initial_states_reader(dk, ti, Ts); % Get initial states
y_deg(:,current_batch) = rad2deg(y(:,current_batch)); % Calculate degree signal

% Error (difference)
e(:,current_batch) = r(:,current_batch) - y(:,current_batch); % [position in rad, velocity in rad/s]


k = k + dk; % Increment time batch


% --- SET UP GRAPHS --- %

figure('Name', 'Output versus Reference')

% Position Graph
subplot(2,1,1)
p_pos = plot(t(1:k-1), r_deg(1,1:k-1), t(1:k-1), y_deg(1,1:k-1));

xlim([0 10])
ylim([-60 270])
legend('Reference', 'Output')
xlabel('Time (s)')
ylabel('Position (degrees)')
axis manual

% Velocity Graph
subplot(2,1,2)
p_vel = plot(t(1:k-1), r_deg(2,1:k-1), t(1:k-1), y_deg(2,1:k-1));

xlim([0 10])
ylim([-90 360])
legend('Reference', 'Output')
xlabel('Time (s)')
ylabel('Velocity (degrees/s)')
axis manual


% --- UPDATE APP GRAPHS --- %

pos_graph.t = t(1:k-1);
pos_graph.r = r_deg(1,1:k-1);
pos_graph.y = y_deg(1,1:k-1);

vel_graph.t = t(1:k-1);
vel_graph.r = r_deg(2,1:k-1);
vel_graph.y = y_deg(2,1:k-1);

ds.dataArea.pos_graph = pos_graph;
ds.dataArea.vel_graph = vel_graph;

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
        r(:,i) = myapp.getReference();
        r_deg(:,i) = rad2deg(r(:,i));
        
        % Summing Junction
        e(:,i) = r(:,i) - y(:,i-dk); % But y is calculated in batches so go find previous value

        % Decoupled Gain
        d(:,i) = D * e(:,i);

        % Calculate integral error
        di(:,i) = di(:,i-1) + Ts * d(:,i-1); % i-1 refers to the previous batch

        % Calculate command signal (muscle signals)
        u(:,i) = Kp .* d(:,i) + Ki .* di(:,i);
        % Referenced from https://tttapa.github.io/Pages/Arduino/Control-Theory/Motor-Fader/PID-Controllers.html#derivative-filtering
    end
    
    
    % --- FORWARD TOOL --- %
    
    % Run Forward Tool for this time step
    y(:,next_batch) = forwardtoolloop(forwardTool, transpose(u(:,current_batch)), t(k+1), t(k+dk));
    y_deg(:,next_batch) = rad2deg(y(:,next_batch)); % Calculate degree signal
    
    
    % --- RESULTS --- %
    
    % Position graph data
    p_pos(1).XData = t(1:k-1);
    p_pos(1).YData = r_deg(1,1:k-1);
    
    p_pos(2).XData = t(1:k-1);
    p_pos(2).YData = y_deg(1,1:k-1);
    
    % Velocity graph data
    p_vel(1).XData = t(1:k-1);
    p_vel(1).YData = r_deg(2,1:k-1);
    
    p_vel(2).XData = t(1:k-1);
    p_vel(2).YData = y_deg(2,1:k-1);
    
    
    % Refresh graphs
    drawnow
    
    
    % Change app graphs
    pos_graph.t = t(current_batch);
    pos_graph.r = r_deg(1,current_batch);
    pos_graph.y = y_deg(1,current_batch);
    
    vel_graph.t = t(current_batch);
    vel_graph.r = r_deg(2,current_batch);
    vel_graph.y = y_deg(2,current_batch);
    
    myapp.updateGraphs(pos_graph, vel_graph)
    
    
    k = k + dk; % Onto the next time step!
end


% [TAG] TODO: Write final signals to file
