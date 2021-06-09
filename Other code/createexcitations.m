function [muscleexcitations, ractuatorexcitations] = createexcitations(tstart,tend)

musclenames = ["TRIlong", "TRIlat", "TRImed", "BIClong", "BICshort", "BRA"]; 
ractuatornames = ["r_shoulder_elev", "r_elbow_flex"];


% Bicep curl STRONG MAN YES!
%muscleexcitations = ones(11,6); % [[] [] [] [] [] []] An array of excitations for each muscle
%ractuatorexcitations = ones(11,2); % [[] []] An array of excitations for each reserve actuator


% Values all set to 1 create a RAPID movement. Need to figure out what magnitudes are appropriate

% Set the starting properties
time = tstart:0.01:tend;
[~, timecount] = size(time);
[~, musclecount] = size(musclenames);
[~, ractuatorcount] = size(ractuatornames);

nil = zeros(1,timecount)';
max = ones(1,timecount)';

% Excite TRIlong
%trilong = ones(1,timecount);



% Excite TRIlat
%TRIlat = ones(1,timecount);



% Excite TRImed
%TRImed = ones(1,timecount);



% Excite BIClong
%BIClong = ones(1,timecount);



% Excite BICshort
%BICshort = ones(1,timecount);



% Excite BRA
%BRA = ones(1,timecount);



% BIClong, BICshort, and BRA need major excitations
muscleexcitations = [nil, nil, nil, max, max, max];
ractuatorexcitations = [nil, nil];






end