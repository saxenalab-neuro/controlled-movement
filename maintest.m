clear;clc;

% Setup OpenSim
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry'); % Add geometry to remove visualization error
model = Model("arm26.osim"); % Add the model


% Get data from files
controlsfile = "Tools/CMC_Results/cmc_output_controls.sto"; % Assign the file name
controls = importdata(controlsfile,' ', 7).data; % Import the data from the file

statesfile = "Tools/CMC_Results/cmc_output_states.sto"; % Assign the file name
states = importdata(statesfile,' ', 7).data; % Import the data from the file

% Get number of rows for both files
[controlsrows, ~] = size(controls);
[statesrows, ~] = size(states);

% Check consistency between controls and states
if (controlsrows ~= statesrows)
    fprintf("CRIT_ERR: Number of rows don't match!\n");
end


% Setup Forward Dynamics tool
fdSetup = "Tools\single_fd_setup.xml";
forwardTool = ForwardTool(fdSetup); % Initialize Forward Tool


motionoutputfilename = "motion.mot";
createmotionfile(); % Creates or resets the motion file



% For each time step, run the Forward Dynamics Tool
for i = 1:controlsrows-1
    
    % HYPERPARAMETERS %
    dt = 1e-4; % CHOOSE A DT, will not be able to calculate it on the fly
    forwardTool; % initialized from setup file
    
    
    
    % TIME SIGNAL PARAMATERS %
    controls = [c1, c2, c3, c4, c5, c6];
    ti = t;
    
    
    
    % FILE PARAMETERS %
    states = previous_states;
    
    
    
    % FORWARD TOOL STEP FUNCTION %
    forwardtoolstep(forwardTool, controls, ti, dt);
    
end