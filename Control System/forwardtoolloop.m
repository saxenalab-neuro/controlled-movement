function [coordinatevalues] = forwardtoolloop(forwardTool, controls, ti, dt)

% INPUTS
% forwardTool - the forward dynamics tool object that was initialized outside of the runtime
% controls - the six time signals from a closed loop or just 6 values in a matrix with values [0, 1]
% ti - the input time value from the signal
% tf - ti + dt really, where dt will be a hyperparameter in the closed loop version
%
%
% OUTPUTS
% Writes internally calculated states to a file


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

coordinatevalues = ss2cumulative(); % Copy output data into motion file

end