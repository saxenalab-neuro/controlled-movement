
% osim loop initialization

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

statesfile = "Tools/CMC_Results/cmc_output_states.sto"; % Assign the file name
states = importdata(statesfile,' ', 7).data; % Import the data from the file

% Get number of rows for controls which will be the number of iterations we need
[controlsrows, ~] = size(controls);


% Set initial state and make motion file
motionfilename = "motionalt.mot";
initial_state = states(1,:);
createmotionfilestep(motionfilename, initial_state); % Creates or resets the motion file


% Setup Forward Dynamics tool
fdSetup = "Tools\single_fd_setup.xml";
forwardTool = ForwardTool(fdSetup); % Initialize Forward Tool

dt = 1e-4;



% instead of copying each line of header file, why not just copy the headerfile, change the name, and then open it for appending? Way easier.
% For initialization, create initialization headerfiles with the initial states for the state and motion files