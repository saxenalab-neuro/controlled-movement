clear;clc;

% Setup OpenSim
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry'); % Add geometry to remove visualization error
model = Model("arm26.osim"); % Add the model


% Remove previous entries in the opensim.log file
fid = fopen("opensim.log", 'w');
fclose(fid);


% Get data from files
controlsfile = "Tools\CMC_Results\cmc_output_controls.sto"; % Assign the file name
controls = importdata(controlsfile,' ', 7).data; % Import the data from the file

statesfile = "Tools\CMC_Results\cmc_output_states.sto"; % Assign the file name
states = importdata(statesfile,' ', 7).data; % Import the data from the file

% Get number of rows for controls which will be the number of iterations we need
[controlsrows, ~] = size(controls);


% Set initial state and make motion file
motionfilename = "motionalt.mot";
initial_state = states(1,:);
createmotionfilestep(motionfilename, initial_state); % Creates or resets the motion file
initCumulativeFiles();

% Setup Forward Dynamics tool
fdSetup = "Tools\single_fd_setup.xml";
forwardTool = ForwardTool(fdSetup); % Initialize Forward Tool


% For each time step, run the Forward Dynamics Tool
for i = 1:controlsrows-1
    single_controls = controls(i,:);
    
    ti = controls(i,1);
    tf = controls(i+1,1);
    
    % FORWARD TOOL STEP FUNCTION %
    forwardtoolstep(forwardTool, single_controls, ti, tf, motionfilename);
    
end

copyfile Tools\SS_Results\cumulative_motion.mot cumulative_motion.mot