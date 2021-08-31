clear;clc;



% Load the input-output data, which is stored in an iddata object
load 'System Identification/Data/sysIDdata.mat'

% Estimate a fourth-order state-space model
nx = 1:10;
sys = ssest(data, nx);

% Compare the simulated model response with the measured output
compare(data, sys)