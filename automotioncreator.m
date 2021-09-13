function [motions] = automotioncreator(nummotions)


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

for i = 1:nummotions
    tic % Begin timer
    
    % Create Motion Data and Store It
    [t, elbow] = modularlinfunmaker(randi(6));
    
    motiondata.data = [t, shoulder, elbow];
    
    motions{i} = motiondata;
    
    
    % Motion Filename
    motionfilename = "System Identification\Motion Files\script_" + num2str(i) + ".mot";


    % Write Motion File
    motion_file_writer(motionfilename, motions{i});
    fprintf("%d: motion file | %f seconds\n", i, toc); % End timer and report

end


% CMC Tool
for i = 1:numel(motions)
    tic % Begin timer
    
    % Run CMC Tool
    if (runCMCTool(i, motions{i}.ti, motions{i}.tf))
        fprintf("%d: CMC | %f seconds\n", i, toc); % End timer and report
    end
end

end
