function compareallsystems(number)

% Convert HiPerGator terminal strings to proper numbers, ugh
if (ischar(number))
    number = str2num(number);
end


HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";
savedsystemsdir = HPGMdir + "sysid/Testing/SavedSystems/";


%orders = [2 4 6 8 10 11 12 13 14 15]; % TAG: [HARDCODED]

sys8 = load(savedsystemsdir + "sys_8_" + num2str(number) + ".mat").sys;
sys9 = load(savedsystemsdir + "sys_9_" + num2str(number) + ".mat").sys;
sys10 = load(savedsystemsdir + "sys_10_" + num2str(number) + ".mat").sys;
sys11 = load(savedsystemsdir + "sys_11_" + num2str(number) + ".mat").sys;
sys12 = load(savedsystemsdir + "sys_12_" + num2str(number) + ".mat").sys;
sys14 = load(savedsystemsdir + "sys_14_" + num2str(number) + ".mat").sys;
sys15 = load(savedsystemsdir + "sys_15_" + num2str(number) + ".mat").sys;
fprintf("Loaded the systems\n");


% % Load testing data
% testingdatafilename = savedsystemsdir + "testing_sysiddata.mat";
% testingdata = load(testingdatafilename).data;
% fprintf("Loaded the testing data\n");
% 
% % Compare against Testing data
% figurename = num2str(number) + "_Testing";
% ft = figure('Name', figurename, 'NumberTitle', 'off');
% fprintf("Created the testing figure\n");
% compare(testingdata, sys8, sys9, sys10, sys11, sys12, sys14, sys15);
% saveas(ft, strcat(savedsystemsdir, figurename, '.fig')) % Save figure for further use
% fprintf("Saved Testing Figure\n");


% Load validation data
validationdatafilename = savedsystemsdir + "validation_sysiddata.mat";
validationdata = load(validationdatafilename).data;
fprintf("Loaded the validation data\n");

% Compare against Validation data
figurename = num2str(number) + "_Validation";
fv = figure('Name', figurename, 'NumberTitle', 'off');
fprintf("Created the validation figure\n");
compare(validationdata, sys8, sys9, sys10, sys11, sys12, sys14, sys15);
saveas(fv, strcat(savedsystemsdir, figurename, '.fig')) % Save figure for further use
fprintf("Saved Validation Figure\n");


comparedir = savedsystemsdir + "compare/";

% Check if directory exists, if not, mkdir
if not(isfolder(comparedir))
    mkdir(comparedir)
end

[y, fit, ic] = compare(validationdata, sys8, sys9, sys10, sys11, sys12, sys14, sys15);
save(comparedir + "y_" + num2str(number) + ".mat", 'y')
save(comparedir + "fit_" + num2str(number) + ".mat", 'fit')
save(comparedir + "ic_" + num2str(number) + ".mat", 'ic')
fprintf("Saved Validation fit and data!\n");

end