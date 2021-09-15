function createdatafile(numscripts, datatype)

% Create cell arrays
input = cell(1,numscripts);
output = cell(1,numscripts);

% New sampling time
Ts = 0.001; % seconds % TAG: [HARDCODED]

unconverted = zeros(1,numscripts);

parfor number = 1:numscripts
    % .mat file names
    cmccontrolsfile = "C:\Users\Jaxton\controlled-movement\System Identification\" + datatype + "\Controls\" + lower(datatype) + "_" + num2str(number) + ".mat";
    cmcstatesfile = "C:\Users\Jaxton\controlled-movement\System Identification\" + datatype + "\States\" + lower(datatype) + "_" + num2str(number) + ".mat";
    
    % If either file doesn't exist, we have a problem
    if (~isfile(cmccontrolsfile) || ~isfile(cmcstatesfile))
        fprintf("CRIT_ERR: cmc_%d files are nonexistent\n", number);
        unconverted(number) = number;
        continue % File must have borked so it doesn't exist, let's move on
    end
    
    % Load .mat files
    cmccontrols = load(cmccontrolsfile).cmccontrols;
    cmcstates = load(cmcstatesfile).cmcstates;


    % Assign data
    tcontrols = cmccontrols(:,1);
    tstates = cmcstates(:,1);

    % Compare sizes of time arrays, there SHOULD be no discrepency
    if (numel(tcontrols) ~= numel(tstates))
        fprintf("CRIT_ERR: Time difference between controls and states on FILE %d\n", number);
        continue
    end


    % Load data
    time = tcontrols; % Irregular sampled time points
    controls = cmccontrols(:,2:9); % Controls file data points
    states = cmcstates(:,2:5); % States file data points

    
    % Define new time vector and interpolate input and output data
    newTime = min(time) : Ts : max(time); % New time vector

    % Interpolate
    controlsInterp = interp1(time, controls, newTime); % Interpolated  input data
    statesInterp = interp1(time, states, newTime); % Interpolated  output data

    % Assign new interpolated data to input and output cell arrays
    input{number} = controlsInterp;
    output{number} = statesInterp;
end

% Construct iddata object
data = iddata(output, input, Ts);

% Set input and output names
set(data, 'InputName', {'TRIlong', 'TRIlat', 'TRImed', 'BIClong', 'BICshort', 'BRA', 'shoulder reserve', 'elbow reserve'});
set(data, 'OutputName', {'shoulder value', 'shoulder speed', 'elbow value', 'elbow speed'});

% Save data to Cloud and SSD
iddataCloudFilename = append("System Identification\", datatype, "\", lower(datatype) + "_sysiddata.mat");
iddataSSDFilename = append("C:\Users\Jaxton\controlled-movement\System Identification\", datatype, "\", lower(datatype) + "_sysiddata.mat");

save(iddataCloudFilename, 'data');
save(iddataSSDFilename, 'data');

% Report and Print Errors
unconverted = unconverted(unconverted~=0);
fprintf("\WARNING: %d files failed to save into iddata\n", numel(unconverted));

end