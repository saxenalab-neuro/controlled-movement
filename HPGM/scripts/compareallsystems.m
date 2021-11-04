function compareallsystems()


HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";

savedsystemsdir = HPGMdir + "sysid/Testing/SavedSystems/";


experiments = [500 1000 2500 5000]; % TAG: [HARDCODED]

for experiment = experiments
    % Load all system order data for a particular number set
    sys2filename = savedsystemsdir + "sys_2_" + num2str(experiment) + ".mat";
    sys4filename = savedsystemsdir + "sys_4_" + num2str(experiment) + ".mat";
    sys6filename = savedsystemsdir + "sys_6_" + num2str(experiment) + ".mat";
    sys8filename = savedsystemsdir + "sys_8_" + num2str(experiment) + ".mat";
    sys10filename = savedsystemsdir + "sys_10_" + num2str(experiment) + ".mat";

    sys2 = load(sys2filename).sys;
    sys4 = load(sys4filename).sys;
    sys6 = load(sys6filename).sys;
    sys8 = load(sys8filename).sys;
    sys10 = load(sys10filename).sys;


    % Load testing data
    testingdatafilename = HPGMdir + "sysid/Testing/testing_sysiddata.mat";
    testingdata = load(testingdatafilename).data;
    testingdata = getexp(testingdata, 1:experiment); % Get the correct number of experiments

    % Compare against Testing data
    figurename = num2str(experiment) + " Experiments - Testing";
    ft = figure('Name', figurename, 'NumberTitle', 'off');
    [y,fit,ic] = compare(testingdata, sys2, sys4, sys6, sys8, sys10)
    saveas(ft, strcat(savedsystemsdir, figurename, '.fig')) % Save figure for further use


    % Load validation data
    validationdatafilename = HPGMdir + "sysid/Validation/validation_sysiddata.mat";
    validationdata = load(validationdatafilename).data;

    % Compare against Validation data
    figurename = num2str(experiment) + " Experiments - Validation";
    fv = figure('Name', figurename, 'NumberTitle', 'off');
    [y,fit,ic] = compare(validationdata, sys2, sys4, sys6, sys8, sys10)
    saveas(fv, strcat(savedsystemsdir, figurename, '.fig')) % Save figure for further use
end

end