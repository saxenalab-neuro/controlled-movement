clear;clc;

% input signal - step

% setup PID controllers for each muscle (6)

% while

% Make PIDs
PID = cell(1,6);
PID{1} = pid(25, 30, 5);
PID{2} = pid(25, 30, 5);
PID{3} = pid(25, 30, 5);
PID{4} = pid(25, 30, 5);
PID{5} = pid(25, 30, 5);
PID{6} = pid(25, 30, 5);

% run input signal through PIDs to get controls

% write controls to file

% use controls to run forward dynamics

% output

% 