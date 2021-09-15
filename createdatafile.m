function [] = createdatafile(numscripts)

% Create cell arrays
input = cell(1,numscripts);
output = cell(1,numscripts);

% New sampling time
Ts = 0.001; % seconds % TAG: [HARDCODED]


for number = 1:numscripts
    % Load .mat files
    cmccontrolsfile = "C:/Users/Jaxton/controlled-movement/System Identification/Data/controls_" + num2str(number) + ".mat";
    cmccontrols = load(cmccontrolsfile).cmccontrols;

    cmcstatesfile = "C:/Users/Jaxton/controlled-movement/System Identification/Data/states_" + num2str(number) + ".mat";
    cmcstates = load(cmcstatesfile).cmcstates;


    % Assign data
    tcontrols = cmccontrols(:,1);
    tstates = cmcstates(:,1);

    if(tcontrols ~= tstates)
        fprintf("CRIT_ERR: Time difference between controls and states on FILE %d\n", number)
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

data = iddata(output, input, Ts);

set(data, 'InputName', {'TRIlong', 'TRIlat', 'TRImed', 'BIClong', 'BICshort', 'BRA', 'shoulder reserve', 'elbow reserve'});
set(data, 'OutputName', {'shoulder value', 'shoulder speed', 'elbow value', 'elbow speed'});

save('C:/Users/Jaxton/controlled-movement/System Identification/Data/sysIDdata.mat', 'data');

end