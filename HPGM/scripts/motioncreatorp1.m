function motioncreatorp1(number, datatype)


% Check if datatype is correct
if (~any(datatype == ["Testing", "Validation"])) % If datatype doesn't match these two, throw an error
    error('Datatype must be equal to "Testing" or "Validation"')
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

%fprintf("------------MOTION FILES------------\n");
tic % Begin timer

% Create Motion Data and store it
elbow = modularlinfunmaker(randi(4), 0, 1, dt, true, 30);
elbow = [repmat(30,100,1); 0.1 + elbow]; % TODO: Fix jank
elbow = smooth(elbow, 40);
motion.data = [t, shoulder, elbow];


% --- Save as motion file ---- %
% Motion File directory and filename
motionfiledir = HPGMdir + "sysid/" + datatype + "/motions/";
desiredkinematicsfilename = motionfiledir + lower(datatype) + "_" + num2str(number) + ".mot";

% Check if directory exists, if not, mkdir
if not(isfolder(motionfiledir))
    mkdir(motionfiledir)
end

% Write Motion File
motion_file_writer(desiredkinematicsfilename, motion);

% End timer and report
fprintf("%d: motion file | %f seconds\n", number, toc);


% --- Save motion to .mat file to compile later --- %
tempdir = HPGMdir + "sysid/" + datatype + "/temp/";
tempfilename = tempdir + lower(datatype) + "_" + num2str(number) + ".mat";

% Check if directory exists, if not, mkdir
if not(isfolder(tempdir))
    mkdir(tempdir)
end

% Write Motion File
save(tempfilename, 'motion');




%%% ----- CREATE THE CMC SETUP FILE ----- %%%
OS = "HPG"; % For testing purposes

% Set File Paths
if (OS == "HPG")
    cmcsetupinitialfilename = HPGMdir + "sysid/setup/cmc_setup.xml";
    cmcsetupfinalfilename = HPGMdir + "sysid/setup/" + num2str(number) + ".xml";
    desiredkinematicsfilename = "../" + datatype + "/motions/" + lower(datatype) + "_" + num2str(number) + ".mot";
    resultsdir = "../" + datatype + "/cmc";
end

if (OS == "Windows")
    cmcsetupinitialfilename = "../sysid/setup/cmc_setup.xml";
    cmcsetupfinalfilename = "../sysid/setup/" + num2str(number) + ".xml";
    desiredkinematicsfilename = "../" + datatype + "/motions/" + lower(datatype) + "_" + num2str(number) + ".mot";
    resultsdir = "../" + datatype + "/cmc";
end


% Check if directory exists, if not, mkdir
if not(isfolder(resultsdir))
    mkdir(resultsdir)
end


% Load xml file
setup = xml2struct(cmcsetupinitialfilename);

% Remove comment field
setup.OpenSimDocument.CMCTool = rmfield(setup.OpenSimDocument.CMCTool, 'Comment');

% Modify properties
setup.OpenSimDocument.CMCTool.Attributes.name = convertStringsToChars(lower(datatype) + "_" + num2str(number));
setup.OpenSimDocument.CMCTool.desired_kinematics_file.Text = convertStringsToChars(desiredkinematicsfilename);
setup.OpenSimDocument.CMCTool.results_directory.Text = convertStringsToChars(resultsdir);
setup.OpenSimDocument.CMCTool.initial_time.Text = num2str(ti);
setup.OpenSimDocument.CMCTool.final_time.Text = num2str(tf);

% Save to xml file
struct2xml(setup, cmcsetupfinalfilename);

end
