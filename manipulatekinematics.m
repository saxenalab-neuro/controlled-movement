function [] = manipulatekinematics()

% READ %
kinematicsfile = "ComputedMuscleControl/kinematics.mot"; % Assign the file name
kinematics = importdata(kinematicsfile,' ', 14).data; % Import the data from the file


% EDIT %
[rows, ~] = size(kinematics);

% Edit values - Bicep Curl
r_shoulder_elev = zeros(1, rows); % Don't move upper arm, keep it at 0
r_elbow_flex = linspace(0, 130, rows); % r_elbow_flex changes linearly between 0 and 130 degrees

% Assign values
kinematics(:,2) = r_shoulder_elev; % Column 2 is the r_shoulder_elev values in degrees
kinematics(:,3) = r_elbow_flex; % Column 4 is the r_elbow_flex values in degrees


kinematicstest(:,1) = kinematics(:,1);
kinematicstest(:,2) = kinematics(:,3);
kinematicstest(:,3) = kinematics(:,4);

% WRITE %
writekinematics("kinematics.txt", kinematics); % Write the kinematics back to the file
movefile("kinematics.txt", "ComputedMuscleControl/kinematics.mot"); % Rename file since we had to work with a .txt file

writekinematics("bicepcurl.txt", kinematicstest); % Write the kinematics back to the file
movefile("bicepcurl.txt", "bicepcurl.mot"); % Rename file since we had to work with a .txt file
end