function [coordinatevalues] = forwardtoolloop(forwardTool, controls, ti, tf)

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
writecontrols(controls);


% Set initial and final times
forwardTool.setInitialTime(ti);
forwardTool.setFinalTime(tf);


% Run the Forward Dynamics Tool
if (forwardTool.run())
else
    fprintf("\nCRIT_ERR: ForwardTool failed to run!\n");
    fprintf("At time = %d\n", ti);
end


debug = true;
% Debug output to keep track of the program
if (debug)
    fprintf("Integrated from I = %s to F = %s\n", num2str(forwardTool.getInitialTime(), '%0.6f'), num2str(forwardTool.getFinalTime(), '%0.6f'));
end

[t,pos,vel] = ss2cumulative(); % Copy OpenSim output into cumulative files

% Need to make sure coordinate values is a 2-by-20 and not anything more or less. Need to interpolate to get that. A little icky but it's a bandaid for now. [TAG] TODO: Figure out better solution

tq = ti:0.001:tf; % TAG [HARDCODED]: Change Ts to be dynamic
coordinatevalues(1,:) = interp1(t, pos, tq, 'spline');
coordinatevalues(2,:) = interp1(t, vel, tq, 'spline');

end