function [] = kinematics_debugger(number)

% Copy of SIdatagen, but only for ONE function, with additional diagnostics


% motion properties = [f, ti, tf, dt, t]; but in struct formation


% Generate all the desired motions
motions = motion_properties_generator();


% Motion data and motion file writing

tic;

% Calculate Motion Data
motions{number}.data = motiongenerator(motions{number});


% Motion Filename
motionfilename = "System Identification\Motion Files\script_" + num2str(number) + ".mot";


% Write Motion File
motion_file_writer(motionfilename, motions{number});
fprintf("%d: motion file | %f seconds\n", number, toc);

% Plot motion file
motionfile_plot(number);

tic

% Run CMC Tool
runCMCTool(number, motions{number}.ti, motions{number}.tf);
fprintf("%d: CMC | %f seconds\n", number, toc);

tic

% Run Forward Tool
runFDTool(number, motions{number}.ti, motions{number}.tf);
fprintf("%d: FD | %f seconds\n", number, toc);


% TODO: Plot comparisons between desired:CMC, desired:FD, CMC:FD, desired:CMC:FD
% TODO: Add debug bool to runCMCTool and runFDTool with functionality that enables visualization, and full analysis of tool properties

 % THE ISSUE: I run SIdatagen (version before 8/13/2021 at 1:26 AM) which results in a messy forward dynamics state file, CMC doesn't report anything wrong with it's states output though.
 % If I run a FD analysis in the tools window in the actual application, there's no issue and I get a movement that matches what it should be, without any shoulder movement too, tracking tasks isn't a problem for it

end