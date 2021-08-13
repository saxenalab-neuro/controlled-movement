function SIdatagen()


% motion properties = [f, ti, tf, dt, t]; but in struct formation


% Generate all the desired motions
motions = motion_properties_generator();


for i = 1:numel(motions)

    % Calculate Motion Data
    motions{i}.data = motiongenerator(motions{i});


    % Motion Filename
    motionfilename = "System Identification\Motion Files\script_" + num2str(i) + ".mot";


    % Write Motion File
    motion_file_writer(motionfilename, motions{i});
    fprintf("%d: motion file\n", i);


    % Run CMC Tool
    runCMCTool(i, motions{i}.ti, motions{i}.tf);
    fprintf("%d: CMC\n", i);


    % Run Forward Tool
    runFDTool(i, motions{i}.ti, motions{i}.tf);
    fprintf("%d: FD\n", i);

end

end