% Create some variables
time = 0:0.01:0.5;
%r_shoulder_elev = zeros(1, numel(time));
r_elbow_flex = linspace(0, 130, numel(time));

data = [time; r_elbow_flex];

% Save the variable x,y,z into one *.mat file
save coordinatevalues.mat data
% Clear them out of the workspace
clear time r_shoulder_elev r_elbow_flex
% Load them again
load coordinatevalues.mat