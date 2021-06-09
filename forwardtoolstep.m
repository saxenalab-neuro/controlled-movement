function forwardtoolstep(forwardTool, controls, t, dt)

% INPUTS
% forwardTool - the forward dynamics tool object that was initialized outside of the runtime
% controls - the input matrix from the 6 PIDs/TFs
% t - the input time value from the signal
% dt - hyperparameter? the chosen change in time
%
%
% OUTPUTS
% Writes internally calculated states to a file


% Write the controls and states to a file for the forward tool to read
writesingledatastep(controls);

% Set initial and final times
forwardTool.setInitialTime(t);
forwardTool.setFinalTime(t + dt);

% Outputs the time states to keep track of the program
if (debug)
    fprintf("Integrating from I = %s to F = %s\n", num2str(forwardTool.getInitialTime(), '%0.6f'), num2str(forwardTool.getFinalTime(), '%0.6f'));
end

% Run the Forward Dynamics Tool
if (forwardTool.run())
else
    fprintf("\nCRIT_ERR: ForwardTool failed to run!\n");
    fprintf("At time = %d\n", t);
end    

% Copy output data into motion file
updatemotionfilestep();

end