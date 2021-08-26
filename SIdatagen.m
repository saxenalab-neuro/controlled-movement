function SIdatagen()


% motion properties = [f, ti, tf, dt, t]; but in struct formation


% Generate all the desired motions
motions = motion_properties_generator();


% Motion data and motion file writing
for i = 1:numel(motions)
    tic % Begin timer
    
    % Calculate Motion Data
    motions{i}.data = motiongenerator(motions{i});


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

% FD Tool
for i = 1:numel(motions)
    tic % Begin timer
    
    % Run Forward Tool
    if (runFDTool(i, motions{i}.ti, motions{i}.tf))
        fprintf("%d: FD | %f seconds\n", i, toc); % End timer and report
    end
end

% Run Comparision Graphs
for i = 1:numel(motions)
    states_error_grapher(i);
end

end