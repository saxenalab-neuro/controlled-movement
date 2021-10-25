 function automotioncreator(nummotions, datatype)

% Check if datatype is correct
if (~any(datatype == ["Testing", "Validation"])) % If datatype doesn't match these two, throw an error
    error('Datatype must be equal to "Testing" or "Validation"')
end

% Ensure directories exist
motionfiledir = "C:/Users/Jaxton/controlled-movement/System Identification/" + datatype + "/Motion Files";
cmcfiledir = "C:/Users/Jaxton/controlled-movement/System Identification/" + datatype + "/CMC_Results";
mkdir(motionfiledir)
mkdir(cmcfiledir)


ti = 0; % TAG: [HARDCODED]
tf = 2; % TAG: [HARDCODED]
dt = 0.001; % TAG: [HARDCODED]

% Output Parameters
t = transpose(ti:dt:tf); % Set time array
shoulder = zeros(numel(t),1); % Set shoulder values

% Create motiondata struct
motiondata.ti = ti;
motiondata.tf = tf;
motiondata.dt = dt;
motiondata.t = t;

% Create motions cell array
motions = cell(1,nummotions); % Preallocate the motions cell array
motions(1,:) = {motiondata}; % Assign the premade struct to each cell


fprintf("------------MOTION FILES------------\n");

tstart = tic; % Begin main timer

% CREATE THE MOTION FILES %
parfor number = 1:nummotions
    tic % Begin timer
    
    % Create Motion Data and Store It
    elbow = modularlinfunmaker(randi(4), 0, 1, dt, true, 30);
    elbow = [repmat(30,100,1); 0.1 + elbow];
    elbow = smooth(elbow, 40);
    motions{number}.data = [t, shoulder, elbow];
    
    % Motion Filename (SSD)
    motionSSDFilename = "C:/Users/Jaxton/controlled-movement/System Identification/" + datatype + "/Motion Files/" + lower(datatype) + "_" + num2str(number) + ".mot";
    
    % Write Motion File
    motion_file_writer(motionSSDFilename, motions{number});
    
    % End timer and report
    fprintf("%d: motion file | %f seconds\n", number, toc);
end

fprintf("------------------------------------\n");
fprintf("TOTAL creation time: %f seconds\n", toc(tstart)); % End main timer
fprintf("------------------------------------\n\n");

% Save motion data to Cloud
datafilename = "System Identification/" + datatype + "/" + lower(datatype) + "_motiondata.mat";
save(datafilename, 'motions')


fprintf("-------------CMC FILES--------------\n");

tstart = tic; % Begin main timer

% CREATE THE CMC FILES %
parfor number = 1:numel(motions)
    tic % Begin timer
    
    % Run CMC Tool
    if (runCMCTool(number, datatype, motions{number}.ti, motions{number}.tf))
        % End timer and report
        fprintf("%d: CMC | %f seconds\n", number, toc);
    end
end

% Report total CMC time
fprintf("------------------------------------\n");
fprintf("TOTAL CMC time: %f seconds\n", toc(tstart)); % End main timer
fprintf("------------------------------------\n\n");

% Convert .sto files to .mat files
sto2mat(nummotions, datatype);

fprintf("THANK GOD FOR PARALLELIZATION\n");
end
