function motionmaker(startnum, endnum, datatype)


% Check if datatype is correct
if (~any(datatype == ["training", "validation"])) % If datatype doesn't match these two, throw an error
    error('Datatype must be equal to "training" or "validation"')
end

% Convert HiPerGator terminal strings to proper numbers, ugh
if (ischar(startnum))
    startnum = str2num(startnum);
end

if (ischar(endnum))
    endnum = str2num(endnum);
end

HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";


ti = 0; % TAG: [HARDCODED]
tf = 1.1; % TAG: [HARDCODED]
dt = 0.001; % TAG: [HARDCODED]

% Output Parameters
t = transpose(ti:dt:tf); % Set time array
shoulder = zeros(numel(t),1); % Set shoulder values

% Create motiondata struct
motion.ti = ti;
motion.tf = tf;
motion.dt = dt;
motion.t = t;



%%% ----- CREATE THE MOTION FILE ----- %%%
seed = (tic-1.637e15)/10000;
fprintf("SEED: %d\n", seed);
rng(seed)
for number = startnum:endnum
    tic
    
    % Create Motion Data and store it
    [error, elbow] = modfuncmaker(randi(4), 0, 1, dt, true, 30);
    
    % Keep going till we get good functions
    while error == 1
        [error, elbow] = modfuncmaker(randi(4), 0, 1, dt, true, 30);
    end
    
    elbow = [repmat(30,100,1); 0.1 + elbow]; % TODO: Fix jank
    elbow = smooth(elbow, 40);
    motion.data = [t, shoulder, elbow];
    
    
    % --- Save as motion file ---- %
    % Motion File directory and filename
    motionfiledir = HPGMdir + datatype + "/motions/";
    desiredkinematicsfilename = motionfiledir + datatype + "_" + num2str(number) + ".mot";

    % Check if directory exists, if not, mkdir
    if not(isfolder(motionfiledir))
        mkdir(motionfiledir)
    end

    % Write Motion File
    motion_file_writer(desiredkinematicsfilename, motion);
    
    
    
    % --- Save motion to .mat file to compile later --- %
    tempdir = HPGMdir + datatype + "/temp/";
    tempfilename = tempdir + datatype + "_" + num2str(number) + ".mat";

    % Check if directory exists, if not, mkdir
    if not(isfolder(tempdir))
        mkdir(tempdir)
    end

    % Write Motion File
    save(tempfilename, 'motion');

    
    
    
    % --- CMC XML Setup Files --- %
    cmcsetupinitialfilename = HPGMdir + "setup/cmc_setup.xml";
    cmcsetupfinalfilename = HPGMdir + "setup/" + num2str(number) + ".xml";
    desiredkinematicsfilename = HPGMdir + datatype + "/motions/" + datatype + "_" + num2str(number) + ".mot";
    resultsdir = HPGMdir + datatype + "/cmc";
    

    % Check if directory exists, if not, mkdir
    if not(isfolder(resultsdir))
        mkdir(resultsdir)
    end


    % Load xml file
    setup = xml2struct(cmcsetupinitialfilename);

    % Remove comment field
    setup.OpenSimDocument.CMCTool = rmfield(setup.OpenSimDocument.CMCTool, 'Comment');

    % Modify properties
    setup.OpenSimDocument.CMCTool.Attributes.name = convertStringsToChars(datatype + "_" + num2str(number));
    setup.OpenSimDocument.CMCTool.desired_kinematics_file.Text = convertStringsToChars(desiredkinematicsfilename);
    setup.OpenSimDocument.CMCTool.results_directory.Text = convertStringsToChars(resultsdir);
    setup.OpenSimDocument.CMCTool.initial_time.Text = num2str(ti);
    setup.OpenSimDocument.CMCTool.final_time.Text = num2str(tf);

    % Save to xml file
    struct2xml(setup, cmcsetupfinalfilename);
    
    % End timer and report
    fprintf("%d: motion file | %f seconds\n", number, toc);

end


end
