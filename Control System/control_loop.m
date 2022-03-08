clear;clc;close all


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
Ts = 0.001; % Sampling time
t = ti:Ts:tf;

% K acts as my time index
k = 1;
dk = 20;
current_batch = k:k-1+dk;


% --- INITIAL CONDITIONS --- %

despos = deg2rad(60); % Desired position [rad] - reference(1)
desvel = deg2rad(0); % Desired velocity [rad/s] - reference(2)
initpos = deg2rad(30);
initvel = deg2rad(0);


% --- PREALLOCATE ARRAYS --- %

r = repmat([despos; desvel], 1, numel(t)); % Reference (desired)
y = zeros(2,numel(t)); % Output (measured)
e = zeros(2,numel(t)); % Error
d = zeros(8,numel(t)); % Decoupled gain
di = zeros(8,numel(t)); % Integral error
u = zeros(8,numel(t)); % Command signal - Muscle contractions 0 to 1


% --- INITIALIZE SIGNALS --- %

initCumulativeFiles(); % Initialize cumulative files

% Output of plant (measured)
y(:,current_batch) = initial_states_reader(dk, ti, Ts); % [initial position in rad, initial velocity in rad/s]

% Error (difference)
e(:,current_batch) = r(:,current_batch) - y(:,current_batch); % [position in rad, velocity in rad/s]


k = k + dk; % Increment time batch



% figure('Name', 'Output versus Reference')
% 
% subplot(2,1,1)
% p1 = plot(t, rad2deg(r(1)));
% p2 = plot(t, rad2deg(y(1)));
% 
% xlim([0 10])
% ylim([-90 180])
% xlabel('Time (s)')
% ylabel('Position (degrees)')
% axis manual
% 
% p1.XDataSource = 't';
% p1.YDataSource = 'rad2deg(r(1))';
% p2.XDataSource = 't';
% p2.YDataSource = 'rad2deg(y(1))';
% 
% subplot(2,1,2)
% p3 = plot(t, rad2deg(r(2)));
% p4 = plot(t, rad2deg(y(2)));
% 
% xlim([0 10])
% ylim([-45 90])
% xlabel('Time (s)')
% ylabel('Velocity (degrees/s)')
% axis manual
% 
% p3.XDataSource = 't';
% p3.YDataSource = 'rad2deg(r(2))';
% p4.XDataSource = 't';
% p4.YDataSource = 'rad2deg(y(2))';

% legend('shoulder_pos', 'shoulder_vel') % Legend currently doesn't work as I'm plotting 1000's of data series and not linking and updating the plot data
% TODO: https://www.mathworks.com/help/matlab/creating_plots/making-graphs-responsive-with-data-linking.html

while true % For each time batch
    
    previous_batch = current_batch;
    current_batch = k:k-1+dk;
    next_batch = k+dk:k-1+2*dk;
    
    
    % --- SIGNALS --- %
    
    for i=current_batch
        % Summing Junction
        e(:,i) = r(:,i) - y(:,i-1);

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
    
    
    % --- RESULTS --- %
    
%     refreshdata
%     drawnow
    plot(t(current_batch), rad2deg(r(1,current_batch)), t(current_batch), rad2deg(y(1,current_batch))) % Plot elbow position: output versus reference
    hold on
    
    
    k = k + dk; % Onto the next time step!
end


% Write cumulative results to file
