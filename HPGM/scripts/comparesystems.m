function comparesystems(number, datatype)

% Check if datatype is correct
if (~any(datatype == ["training", "validation"])) % If datatype doesn't match these two, throw an error
    error('Datatype must be equal to "training" or "validation"')
end

% Convert HiPerGator terminal strings to proper numbers, ugh
if (ischar(number))
    number = str2num(number);
end


HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";
savedsystemsdir = HPGMdir + "systems/";


%orders = [2 4 6 8 10 11 12 13 14 15]; % TAG: [HARDCODED]

sys8 = load(savedsystemsdir + "sys_8_" + num2str(number) + ".mat").sys;
sys9 = load(savedsystemsdir + "sys_9_" + num2str(number) + ".mat").sys;
sys10 = load(savedsystemsdir + "sys_10_" + num2str(number) + ".mat").sys;
sys11 = load(savedsystemsdir + "sys_11_" + num2str(number) + ".mat").sys;
sys12 = load(savedsystemsdir + "sys_12_" + num2str(number) + ".mat").sys;
sys14 = load(savedsystemsdir + "sys_14_" + num2str(number) + ".mat").sys;
sys15 = load(savedsystemsdir + "sys_15_" + num2str(number) + ".mat").sys;
fprintf("Loaded the systems\n");

if (datatype == "training")
    % Load training data
    trainingdatafilename = savedsystemsdir + "training_sysiddata.mat";
    trainingdata = load(trainingdatafilename).data;
    fprintf("Loaded the training data\n");
    
    % Compare against training data
    figurename = num2str(number) + "_training";
    ft = figure('Name', figurename, 'NumberTitle', 'off');
    fprintf("Created the training figure\n");
    compare(trainingdata, sys8, sys9, sys10, sys11, sys12, sys14, sys15);
    saveas(ft, strcat(savedsystemsdir, figurename, '.fig')) % Save figure for further use
    fprintf("Saved training Figure\n");

elseif (datatype == "validation")
    % Load validation data
    validationdatafilename = savedsystemsdir + "validation_sysiddata.mat";
    validationdata = load(validationdatafilename).data;
    fprintf("Loaded the validation data\n");

    % Compare against validation data
    figurename = num2str(number) + "_validation";
    fv = figure('Name', figurename, 'NumberTitle', 'off');
    fprintf("Created the validation figure\n");
    compare(validationdata, sys8, sys9, sys10, sys11, sys12, sys14, sys15);
    saveas(fv, strcat(savedsystemsdir, figurename, '.fig')) % Save figure for further use
    fprintf("Saved validation Figure\n");
end


comparedir = savedsystemsdir + "compare/";

% Check if directory exists, if not, mkdir
if not(isfolder(comparedir))
    mkdir(comparedir)
end

[y, fit, ic] = compare(validationdata, sys8, sys9, sys10, sys11, sys12, sys14, sys15);
save(comparedir + datatype + "_y_" + num2str(number) + ".mat", 'y')
save(comparedir + datatype + "_fit_" + num2str(number) + ".mat", 'fit')
save(comparedir + datatype + "_ic_" + num2str(number) + ".mat", 'ic')
fprintf("Saved validation fit and data!\n");

close all % Close all figures so the program can exit with success
end