clear;clc;

warning('off', 'Ident:estimation:transientDataCorrection') % Turn off annoying warning

% Load the input-output data, which is stored in an iddata object
load 'System Identification/Data/sysIDdata.mat' data

% Estimate a fourth-order state-space model
%nx = 1:10;
%sys = n4sid(data, nx);

% Choose experiments for estimation
de = getexp(data, 1:10); 

% Choose experiments for validation
dv = getexp(data, 11);

sys = n4sid(de, 4);


% Compare the simulated model response with the measured output
compare(dv, sys)


%% Modify Form, Feedthrough, and Disturbance-Model Matrices
clear;clc;

warning('off', 'Ident:estimation:transientDataCorrection') % Turn off annoying warning

% Load the input-output data, which is stored in an iddata object
load 'System Identification/Data/sysIDdata.mat' data

sys1 = n4sid(data, 4);

sys2 = n4sid(data, 4, 'Form', 'modal');

A1 = sys1.A
A2 = sys2.A

sys3 = n4sid(data, 4, 'Feedthrough', 1);

D1 = sys1.D
D3 = sys3.D

sys4 = n4sid(data, 4, 'DisturbanceModel', 'none');

K1 = sys1.K
K4 = sys4.K

compare(data, sys1, sys2, sys3, sys4)
