function [unconverted] = sto2mat(datatype)


% Check if datatype is correct
if (~any(datatype == ["Testing", "Validation"])) % If datatype doesn't match these two, throw an error
    error('Datatype must be equal to "Testing" or "Validation"')
end


HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";



% Convert each controls and states file from the cmc tool

cmcresultsdir = HPGMdir + "sysid/" + datatype + "/cmc/";

controlsfiles = dir(fullfile(cmcresultsdir, "*_controls.sto"));
statesfiles = dir(fullfile(cmcresultsdir, "*_states.sto"));


if (numel(controlsfiles) ~= numel(statesfiles))
    error("CRIT_ERR: # of controls files does not equal the # of states files\n");
end

numscripts = numel(controlsfiles);

unconverted = zeros(1,numscripts);
controls = cell(1,numscripts);
states = cell(1,numscripts);



for number = 1:numscripts
    % Set filenames
    cmccontrolsfile = cmcresultsdir + controlsfiles(number).name;
    cmcstatesfile = cmcresultsdir + statesfiles(number).name;
    
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
        fprintf("size controls %d, size states %d\n", numel(cmccontrols(:,1)), numel(cmcstates(:,1)));
        continue
    end
    
    % Assign the individual controls to the group cell array
    controls{number} = cmccontrols;
    states{number} = cmcstates;
end


% Save controls and states each as a group
if (~all(cellfun('isempty', controls)) || ~all(cellfun('isempty', states)))
    % Save controls
    controlsfilename = HPGMdir + "sysid/" + datatype + "/" + lower(datatype) + "_controls.mat";
    save(controlsfilename, 'controls')
    fprintf("Saved the controls!\n");
        
    % Save states
    statesfilename = HPGMdir + "sysid/" + datatype + "/" + lower(datatype) + "_controls.mat";
    save(statesfilename, 'states')
    fprintf("Saved the states!\n");
end



end