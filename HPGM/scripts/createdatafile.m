function createdatafile(datatype)

% Check if datatype is correct
if (~any(datatype == ["training", "validation"])) % If datatype doesn't match these two, throw an error
    error('Datatype must be equal to "training" or "validation"')
end


HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";



tic % Begin timer

% Load controls and states data
cmccontrolsfile = HPGMdir + datatype + "/" + datatype + "_controls.mat";
cmcstatesfile = HPGMdir + datatype + "/" + datatype + "_states.mat";
controls = load(cmccontrolsfile).controls;
states = load(cmcstatesfile).states;

fprintf("There are %d experiments\n", numel(controls));
numexperiments = numel(controls);

% Create cell arrays
input = cell(1,numexperiments);
output = cell(1,numexperiments);



% New sampling time
Ts = 0.001; % seconds % TAG: [HARDCODED]

for number = 1:numexperiments
    time = controls{number}(:,1);
    newTime = min(time) : Ts : max(time);
    
    % Trim repreated time values (rare)
    [~, w] = unique(time, 'stable');
    duplicate_indices = setdiff(1:numel(time), w);
    
    if (~isempty(duplicate_indices))
        controls{number}(duplicate_indices,:) = [];
        states{number}(duplicate_indices,:) = [];
        time = controls{number}(:,1); % Remake time matrix
    end
    
    % Assign new interpolated data to input and output cell arrays
    input{number} = interp1(time, controls{number}(:,2:end), newTime); % Interpolated  input data
    output{number} = interp1(time, states{number}(:,2:end), newTime); % Interpolated  output data
end



% Construct iddata object
data = iddata(output, input, Ts);


% Set input and output names
set(data, 'InputName', {'TRIlong', 'TRIlat', 'TRImed', 'BIClong', 'BICshort', 'BRA', 'shoulder reserve', 'elbow reserve'});
set(data, 'OutputName', {'elbow value', 'elbow speed'});

% Saved System File directory and filename
iddatafilename = HPGMdir + "systems/" + datatype + "_sysiddata.mat";
save(iddatafilename, 'data');


% Report
fprintf("\nExperiment data file creation took %f seconds\n", toc);

end