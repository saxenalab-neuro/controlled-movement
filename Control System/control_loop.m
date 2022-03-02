clear;clc;


toolspathname = "../Tools/";

% % Parse inputs
% if nargin == 2
%     if (strcmp(varargin{1},'ToolsPath'))
%         toolspathname = varargin{2};
%     end
% end

%%% SETUP %%%

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


% --- PREALLOCATE ARRAYS --- %
r = zeros(2,1,10000); % Reference
y = zeros(2,1,10000); % Output
e = zeros(2,1,10000); % Error
d = zeros(8,1,10000); % Decoupled gain
di = zeros(8,1,10000); % Integral error
u = zeros(8,1,10000); % Command signal - Muscle contractions 0 to 1
results = zeros(2,10000); % Results




% --- INITIAL CONDITIONS --- %
despos = deg2rad(60);
desvel = deg2rad(0);
initpos = deg2rad(30);
initvel = deg2rad(0);


% --- SIGNALS --- %
% Reference signal (desired)
r(:,:,1) = [despos; desvel]; % [desired position in rad, desired velocity in rad/s]

% Output of plant (measured)
y(:,:,1) = [initpos; initvel]; % [initial position in rad, initial velocity in rad/s]

% Error (difference)
e(:,:,1) = r(1) - y(1); % [position in rad, velocity in rad/s]


Ts = 0.001; % Time sampling


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

% Initialize cumulative files
initCumulativeFiles();



%%% SYSTEM LOOP %%%

k = 2;
ti = 1;

while true
    
    % --- SIGNALS --- %
    
    % Summing Junction
    e(:,:,k) = r(:,:,k) - y(:,:,k);
            
    % Decoupled Gain
    d(:,:,k) = D * e(:,:,k);
        
    % Calculate integral error
    di(:,:,k) = di(:,:,k-1) + Ts * d(:,:,k-1);
    
    % Calculate command signal (muscle signals)
    u(:,:,k) = Kp .* d(:,:,k) + Ki .* di(:,:,k);
    % Referenced from https://tttapa.github.io/Pages/Arduino/Control-Theory/Motor-Fader/PID-Controllers.html#derivative-filtering
        
    
    % --- FORWARD TOOL --- %
    
    % Run Forward Tool for this time step
    y(:,:,k+1) = forwardtoolloop(forwardTool, u(:,:,k), ti, Ts);
    
    
    % --- RESULTS --- %
    
    % Combine results into master array
    results(:,:,k) = [r(:,:,k), y(:,:,k), e(:,:,k), d(:,:,k), u(:,:,k), y(:,:,k+1)];
    
    k = k + 1; % Onto the next time step!
end


% Write cumulative results to file
% 

