function SIdatagen()


% motion properties = [f, ti, tf, dt, t]; but in struct formation


% Generate all the desired motions
motions = motion_properties_generator();


% Motion data and motion file writing
for i = 1:numel(motions)
    tic;
    
    % Calculate Motion Data
    motions{i}.data = motiongenerator(motions{i});


    % Motion Filename
    motionfilename = "System Identification\Motion Files\script_" + num2str(i) + ".mot";


    % Write Motion File
    motion_file_writer(motionfilename, motions{i});
    fprintf("%d: motion file | %f seconds\n", i, toc);

end


breakindex = 6; % Janky way to skip function 6, which is broken

% CMC Tool
for i = 1:numel(motions)
    if (i == breakindex)
        continue
    end
    
    tic
    
    % Run CMC Tool
    runCMCTool(i, motions{i}.ti, motions{i}.tf);
    fprintf("%d: CMC | %f seconds\n", i, toc);
end

% FD Tool
for i = 1:numel(motions)
    if (i == breakindex)
        continue
    end
    
    tic
    
    % Run Forward Tool
    runFDTool(i, motions{i}.ti, motions{i}.tf);
    fprintf("%d: FD | %f seconds\n", i, toc);
end

end