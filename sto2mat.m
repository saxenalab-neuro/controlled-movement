function [unconverted] = sto2mat(numscripts, datatype)

% Idea is to run this once so we don't have to call such heavy functions such as importdata every time.
% My hope is loading a .mat is significantly faster than importdata 'ing a .sto
% The results are in! Loading .mat files is SIGNIFICANTLY faster than importdata!


% Initialize arrays
unconverted = zeros(1,numscripts);
controls = cell(1,numscripts);
states = cell(1,numscripts);

% Convert each controls and states file from the cmc tool
parfor number = 1:numscripts
    tic % Begin timer
    
    % Set filenames
    cmccontrolsfile = "C:\Users\Jaxton\controlled-movement\System Identification\" + datatype + "\CMC_Results\" + lower(datatype) + "_" + num2str(number) + "_controls.sto";
    cmcstatesfile = "C:\Users\Jaxton\controlled-movement\System Identification\" + datatype + "\CMC_Results\" + lower(datatype) + "_" + num2str(number) + "_states.sto";
    
    % If either file doesn't exist, we have a problem
    if (~isfile(cmccontrolsfile) || ~isfile(cmcstatesfile))
        fprintf("CRIT_ERR: cmc_%d files are nonexistent\n", number);
        unconverted(number) = number;
        continue % File must have borked so it doesn't exist, let's move on
    end
    
    % Import and convert data
    cmccontrols = importdata(cmccontrolsfile, '\t', 7).data; % Import the data from the file
    cmcstates = importdata(cmcstatesfile, ' ', 7).data(:,1:5); % Import the data from the file
    cmcstates(:, 2:5) = rad2deg(cmcstates(:, 2:5)); % Convert radians to degrees
    
    % Compare sizes of time arrays, there SHOULD be no discrepency
    if (numel(cmccontrols(:,1)) ~= numel(cmcstates(:,1)))
        fprintf("CRIT_ERR: Time difference between controls and states on FILE %d\n", number);
        continue
    end
    
    % Assign the individual controls to the group cell array
    controls{number} = cmccontrols;
    states{number} = cmcstates;
end


% Save controls and states each as a group
if (~all(cellfun('isempty', controls)) || ~all(cellfun('isempty', states)))
    % Save controls to Cloud and to SSD
    controlsCloudFilename = append("System Identification\", datatype, "\", lower(datatype), "_controls.mat");
    controlsSSDFilename = append("C:\Users\Jaxton\controlled-movement\System Identification\", datatype, "\", lower(datatype), "_controls.mat");
    
    save(controlsCloudFilename, 'controls')
    save(controlsSSDFilename, 'controls')
    
    
    % Save states to Cloud and to SSD
    statesCloudFilename = append("System Identification\", datatype, "\", lower(datatype), "_states.mat");
    statesSSDFilename = append("C:\Users\Jaxton\controlled-movement\System Identification\", datatype, "\", lower(datatype), "_states.mat");

    save(statesCloudFilename, 'states')
    save(statesSSDFilename, 'states')
end


% Report times and errors
fprintf("------------------------------------\n");
fprintf("Sto2Mat Total time: %f\n", toc);
unconverted = unconverted(unconverted~=0);
fprintf("\nNOTICE: %d files failed to convert\n", numel(unconverted));
fprintf("------------------------------------\n\n");

end