%function createdatafile(numscripts, datatype)
numscripts = 200; datatype = "Validation";
tic % Begin timer

% Create cell arrays
input = cell(1,numscripts);
output = cell(1,numscripts);

% New sampling time
Ts = 0.001; % seconds % TAG: [HARDCODED]


% Load controls and states data
cmccontrolsfile = "System Identification\" + datatype + "\" + lower(datatype) + "_controls.mat";
cmcstatesfile = "System Identification\" + datatype + "\" + lower(datatype) + "_states.mat";

controls = load(cmccontrolsfile).controls;
states = load(cmcstatesfile).states;



for number = 1:numscripts
    time = controls{number}(:,1);
    newTime = min(time) : Ts : max(time);
    
    % Trim repreated time values (rare)
    [v, w] = unique(time, 'stable');
    duplicate_indices = setdiff(1:numel(time), w);
    
    if (~isempty(duplicate_indices))
        controls{number}(duplicate_indices,:) = [];
        states{number}(duplicate_indices,:) = [];
        time = controls{number}(:,1); % Remake time matrix
    end
    
    % Assign new interpolated data to input and output cell arrays
    input{number} = interp1(time, controls{number}(:,2:9), newTime); % Interpolated  input data
    output{number} = interp1(time, states{number}(:,2:5), newTime); % Interpolated  output data
end


% Construct iddata object
data = iddata(output, input, Ts);


% Set input and output names
set(data, 'InputName', {'TRIlong', 'TRIlat', 'TRImed', 'BIClong', 'BICshort', 'BRA', 'shoulder reserve', 'elbow reserve'});
set(data, 'OutputName', {'shoulder value', 'shoulder speed', 'elbow value', 'elbow speed'});

% Save data to Cloud and SSD
iddataCloudFilename = append("System Identification\", datatype, "\", lower(datatype) + "_sysiddata.mat");
% iddataSSDFilename = append("C:\Users\Jaxton\controlled-movement\System Identification\", datatype, "\", lower(datatype) + "_sysiddata.mat");

save(iddataCloudFilename, 'data');
% save(iddataSSDFilename, 'data'); % On Citrix, it is not possible to save to your SSD without a weird filepath


% Report
fprintf("\nExperiment data file creation took %f seconds\n", toc);

%end