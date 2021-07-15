% random controls


clear;clc;

% Setup OpenSim
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry'); % Add geometry to remove visualization error
model = Model("arm26.osim"); % Add the model


% Remove previous entries in the opensim.log file
fid = fopen("opensim.log", 'w');
fclose(fid);

statesfile = "Tools/CMC_Results/cmc_output_states.sto"; % Assign the file name
states = importdata(statesfile,' ', 7).data; % Import the data from the file


% Set initial state and make motion file
motionfilename = "bananas.mot";
initial_state = states(1,:);
createmotionfilestep(motionfilename, initial_state); % Creates or resets the motion file


% Setup Forward Dynamics tool
fdSetup = "Tools\single_fd_setup.xml";
forwardTool = ForwardTool(fdSetup); % Initialize Forward Tool

ti = 0.03;
dt = .01;

% For each time step, run the Forward Dynamics Tool
for i = 1:200
    
    
    single_controls = [0.02, 0.02, 0.02, 0.4, 0.5, 0.6];
    tf = ti + dt;
    
    % FORWARD TOOL STEP FUNCTION %
    forwardtoolstep(forwardTool, single_controls, ti, tf, motionfilename);
    
    ti = tf;
    
end
