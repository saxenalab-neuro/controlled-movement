function [] = automotioncreator(nummotions)


motions = cell(1,nummotions); % Preallocate the function handles cell array

ti = 0; % TAG: [HARDCODED]
tf = 1; % TAG: [HARDCODED]
dt = 0.001; % TAG: [HARDCODED]

t = ti:dt:tf;
shoulder = zeros(numel(t),1);

motiondata.ti = ti;
motiondata.tf = tf;
motiondata.dt = dt;
motiondata.t = t;

motions(1,:) = {motiondata};

smoother = 3; % Moving average smoother with span of 40

parfor i = 1:nummotions
    tic % Begin timer
    
    % Create Motion Data and Store It
    [t, elbow] = modularlinfunmaker(randi(4), smoother);
    motions{i}.data = [t, shoulder, elbow];
    
    
    % Motion Filename
    motionfilename = "C:/Users/Jaxton/controlled-movement/System Identification/Motion Files/script_" + num2str(i) + ".mot";
    
    
    % Write Motion File
    motion_file_writer(motionfilename, motions{i});
    fprintf("%d: motion file | %f seconds\n", i, toc); % End timer and report
    
end


% Save motion data and date it
datafilename = "C:/Users/Jaxton/controlled-movement/System Identification/Motion Files/motiondata.mat";
t = now;
date = datetime(t,'ConvertFrom','datenum');
save(datafilename, 'date', 'motions')


% CMC Tool
parfor i = 1:numel(motions)
    tic % Begin timer
    
    % Run CMC Tool
    if (runCMCTool(i, motions{i}.ti, motions{i}.tf))
        fprintf("%d: CMC | %f seconds\n", i, toc); % End timer and report
    end
end


% Convert .sto files to .mat files
sto2mat(nummotions);


end
