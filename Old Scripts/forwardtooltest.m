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

createmotionfile(); % Creates or resets the motion file


% For each time step, run the Forward Dynamics Tool
for i = 1:controlsrows-1
    
    % Write single controls and states
    writesingledata("controls", controls, i);
    writesingledata("states", states, i);
    
    % Get initial and final times for time step and edit them slightly
    mindt = forwardTool.getMinDT();
    ti = controls(i,1) - mindt;
    tf = controls(i+1,1) + mindt;
    
    % Set initial and final times
    forwardTool.setInitialTime(ti);
    forwardTool.setFinalTime(tf);
    
    % Outputs the time states to keep track of the program
    fprintf("Integrating from I = %s to F = %s\n", num2str(forwardTool.getInitialTime(), '%0.6f'), num2str(forwardTool.getFinalTime(), '%0.6f'));
    
    
    % Run the Forward Dynamics Tool
    if (forwardTool.run())
    else
        fprintf("\nCRIT_ERR: ForwardTool failed to run!\n");
        fprintf("At i = %d, time = %d\n", i, ti);
    end
    
    % Copy output data into motion file
    updatemotionfile(i);
    
end