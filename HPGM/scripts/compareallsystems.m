function compareallsystems()

experiment = 1000; % TAG: [HARDCODED]

%for experiment = experiments
    % Load all system order data for a particular number set
    sys2filename = "SavedSystems/sys_" + num2str(experiment) + "_2.mat";
    sys4filename = "SavedSystems/sys_" + num2str(experiment) + "_4.mat";
    sys6filename = "SavedSystems/sys_" + num2str(experiment) + "_6.mat";
    sys8filename = "SavedSystems/sys_" + num2str(experiment) + "_8.mat";
    sys10filename = "SavedSystems/sys_" + num2str(experiment) + "_10.mat";

    sys2 = load(sys2filename).sys;
    sys4 = load(sys4filename).sys;
    sys6 = load(sys6filename).sys;
    sys8 = load(sys8filename).sys;
    sys10 = load(sys10filename).sys;


    % Load testing data
    testingdatafilename = "testing_sysiddata.mat";
    testingdata = load(testingdatafilename).data;
    testingdata = getexp(testingdata, 1:experiment); % Get the correct number of experiments

    % Compare against Testing data
    figurename = num2str(experiment) + " Experiments - Testing";
    ft = figure('Name', figurename, 'NumberTitle', 'off');
    compare(testingdata, sys2, sys4, sys6, sys8, sys10)
    saveas(ft, strcat("SavedSystems/", figurename, '.fig')) % Save figure for further use


    % Load validation data
    validationdatafilename = "validation_sysiddata.mat";
    validationdata = load(validationdatafilename).data;

    % Compare against Validation data
    figurename = num2str(experiment) + " Experiments - Validation";
    fv = figure('Name', figurename, 'NumberTitle', 'off');
    compare(validationdata, sys2, sys4, sys6, sys8, sys10)
    saveas(fv, strcat("SavedSystems/", figurename, '.fig')) % Save figure for further use
%end

end