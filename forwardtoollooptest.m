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
[controlsrows, ~] = size(controls);

initCumulativeFiles();

% Setup Forward Dynamics tool
fdSetup = "Tools\fd_loop_setup.xml";
forwardTool = ForwardTool(fdSetup); % Initialize Forward Tool


% For each time step, run the Forward Dynamics Tool
for i = 1:controlsrows-1
    single_controls = controls(i,:);
    
    ti = controls(i,1);
    tf = controls(i+1,1);
    
    % FORWARD TOOL STEP FUNCTION %
    state = forwardtoolloop(forwardTool, single_controls, ti, tf-ti);
    degrees = rad2deg(state);
end

copyfile Tools\SS_Results\cumulative_motion.mot cumulative_motion.mot