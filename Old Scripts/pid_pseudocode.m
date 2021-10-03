clear;clc;

% Setup OpenSim
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry'); % Add geometry to remove visualization error
model = Model("arm26.osim"); % Add the model


% Remove previous entries in the opensim.log file
fid = fopen("opensim.log", 'w');
fclose(fid);


% Initialize cumulative files
initCumulativeFiles();


% Initialize the Forward Dynamics Tool
fdSetupFile = "Tools\fd_loop_setup.xml";
forwardTool = ForwardTool(fdSetupFile); % Initialize Forward Tool
%forwardTool.setModel(model);


% simple software loop that implements a PID algorithm - https://en.wikipedia.org/wiki/PID_controller#Pseudocode

Kp = [0, 1, 1, 1, 1, 0];
Ki = zeros(1,6); %Kp .* 0.5;
Kd = zeros(1,6); %Ki .* 0.5;
dt = 0.01;

setpoint = 130;
measured_value = 0;
previous_error = 0;

numpids = numel(Kp);
integral = zeros(1,numpids);
controls = zeros(1,numpids);

ti = 0.0000;


while true
    error = setpoint - measured_value;
    proportional = error;
    
    for i = 1:numpids
        integral(i) = integral(i) + error * dt;
        derivative = (error - previous_error) / dt;
        controls(i) = 1/130 * (Kp(i) * proportional + Ki(i) * integral(i) + Kd(i) * derivative);
        
        % Clip controls to proper range
        if (controls(i) > 1)
            controls(i) = 1;
        elseif (controls(i) < 0.02)
            controls(i) = 0.02;
        end
    end
    
    
    
    % Write the controls and states to a file for the forward tool to read
    writesingledatastep(controls);


    % Set initial and final times
    forwardTool.setInitialTime(ti);
    forwardTool.setFinalTime(ti+dt);


    % Run the Forward Dynamics Tool
    if (forwardTool.run())
    else
        fprintf("\nCRIT_ERR: ForwardTool failed to run!\n");
        fprintf("At time = %d\n", ti);
    end


    debug = 1;
    % Debug output to keep tracck of the program
    if (debug)
        fprintf("Integrated from I = %s to F = %s\n", num2str(forwardTool.getInitialTime(), '%0.6f'), num2str(forwardTool.getFinalTime(), '%0.6f'));
    end

    measured_value = rad2deg(ss2cumulative()); % Copy output data into motion file
    
    previous_error = error;
    ti = ti + dt;
end