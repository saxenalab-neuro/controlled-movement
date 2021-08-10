function [motions] = motionpropertiesgenerator()

%%% THIS FUNCTION IS PURPOSELY HARD CODED
%
% KEY PROPERTIES:
%     motion = [tstart, tend, stepsize, posstart, posfunc];
%     
%     tstart is the start time of the motion
%     tend is the end time of the motion
%     stepsize is the time step for the iteration, governs how many data points
%     posstart is the start position of the motion
%         This value must be within the rotational constraints of the joint
%     posfunc is a function to generate the motion positions from the start position
%         Generating each motion data point is tedious so a function automates it
%         The positions generated must be within the rotational constraints of the specified joint at all times
% 
% This function generates the key properties to generate each motion file
% It returns a struct of each of the key properties to be used in the main SIdatagen function
% 
% TODO:
% Add support for piecewise functions, currently functions are limited to continous linear functions





% HARD CODED VARIABLES %
% GUIDE:     [tstart, tend, stepsize, posstart]
variables = [   
                0.00, 1, 0.010, 0;
                0.00, 1, 0.010, 30
            ];


% HARDCODED FUNCTIONS %
f{1} = @(t) 140*t;
f{2} = @(t) 70*t;


% Get number of rows of variables matrix
[rows, ~] = size(variables);

% Assertion check that the number of functions matches the number of rows of the variables
assert(numel(f) == rows);

% Create a cell array to store the motions
motions = cell(1, rows);

for i = 1:rows
    % Create a struct called motion and assign the key properties to it
    motion.tstart   = variables(i, 1);
    motion.tend     = variables(i, 2);
    motion.stepsize = variables(i, 3);
    motion.posstart = variables(i, 4);
    motion.posfunc  = f{i};
    
    % Add the motion struct to the motions cell array
    motions{i} = motion;
end

end
