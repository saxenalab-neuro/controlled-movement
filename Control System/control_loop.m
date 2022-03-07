clear;clc;


toolspathname = "../Tools/";

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


forwardTool.getInitialTime()
forwardTool.getFinalTime()


% --- IMPORT CONTROLLERS --- %

controllersfilename = "controller_tuning/system_9.mat";
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
Ts = 0.001; % Time sampling
t = ti:Ts:tf;

k = 2;
dk = 20;


% --- PREALLOCATE ARRAYS --- %

r = zeros(2,numel(t)); % Reference
y = zeros(2,numel(t)); % Output
e = zeros(2,numel(t)); % Error
d = zeros(8,numel(t)); % Decoupled gain
di = zeros(8,numel(t)); % Integral error
u = zeros(8,numel(t)); % Command signal - Muscle contractions 0 to 1


% --- INITIAL CONDITIONS --- %

despos = deg2rad(60);
desvel = deg2rad(0);
initpos = deg2rad(30);
initvel = deg2rad(0);


% --- INITIAL SIGNALS --- %

for i=1:dk
    % Reference signal (desired)
    r(:,i) = [despos; desvel]; % [desired position in rad, desired velocity in rad/s]

    % Output of plant (measured)
    y(:,i) = [initpos; initvel]; % [initial position in rad, initial velocity in rad/s]

    % Error (difference)
    e(:,i) = r(:,i) - y(:,i); % [position in rad, velocity in rad/s]
end



% --- SYSTEM LOOP --- %

initCumulativeFiles(); % Initialize cumulative files

y(:,k:k-1+dk) = initial_states_reader(dk, ti, Ts); % Initialize states

%figure('Name', 'Output versus Reference')



% K acts as my time index
k = k-1+dk; % Current batch

while true % For each time batch
    
    current_batch = k:k-1+dk;
    next_batch = k+dk:k-1+2*dk;
    
    
    % --- SIGNALS --- %
    
    for i=current_batch
        % Summing Junction
        e(:,i) = r(:,i) - y(:,i);

        % Decoupled Gain
        d(:,i) = D * e(:,i);

        % Calculate integral error
        di(:,i) = di(:,i-1) + Ts * d(:,i-1);

        % Calculate command signal (muscle signals)
        u(:,i) = Kp .* d(:,i) + Ki .* di(:,i);
        % Referenced from https://tttapa.github.io/Pages/Arduino/Control-Theory/Motor-Fader/PID-Controllers.html#derivative-filtering
    end
    
    
    % --- FORWARD TOOL --- %
    
    % Run Forward Tool for this time step
    y(:,next_batch) = forwardtoolloop(forwardTool, transpose(u(:,current_batch)), t(k), t(k-1+dk));
    
    
    % --- RESULTS --- %
    
    plot(t(current_batch), r(1,current_batch), t(current_batch), y(1,current_batch)) % Plot elbow position: output versus reference
    hold on
    
    k = k + dk; % Onto the next time step!
end


% Write cumulative results to file
% 

