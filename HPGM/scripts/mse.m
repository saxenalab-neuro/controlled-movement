function mse(number, datatype)

% Convert HiPerGator terminal strings to proper numbers, ugh
if (ischar(number))
    number = str2num(number);
end


HPGMdir = "C:/Users/Jaxton/Desktop/"; %"/home/jaxtonwillman/Desktop/HPGM/";
savedsystemsdir = HPGMdir + "systems/";
msedir = savedsystemsdir + "mse/";




HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";
systemdatafile = HPGMdir + "sysid/training/SavedSystems/testing_sysiddata.mat";


warning('off', 'Ident:estimation:transientDataCorrection') % Turn off annoying warning

% Load the input-output data, which is stored in an iddata object
data = load(systemdatafile).data;
fprintf("I loaded the data\n");

opt = tfestOptions('InitializeMethod','n4sid');



% Find the goodness of fit between measured and estimated outputs for two models.
% Obtain the input-output measurements z2 from iddata2. Copy the measured output into reference output yref.

load iddata2 z2
yref = z2.y;

% Estimate second-order and fourth-order transfer function models using z2.

sys2 = tfest(z2,2,opt);
sys4 = tfest(z2,4);
sys8 = load(savedsystemsdir + "sys_8_" + num2str(number) + ".mat").sys;
sys9 = load(savedsystemsdir + "sys_9_" + num2str(number) + ".mat").sys;
sys10 = load(savedsystemsdir + "sys_10_" + num2str(number) + ".mat").sys;
sys11 = load(savedsystemsdir + "sys_11_" + num2str(number) + ".mat").sys;
sys12 = load(savedsystemsdir + "sys_12_" + num2str(number) + ".mat").sys;
sys14 = load(savedsystemsdir + "sys_14_" + num2str(number) + ".mat").sys;
sys15 = load(savedsystemsdir + "sys_15_" + num2str(number) + ".mat").sys;
fprintf("Loaded the systems\n");


% Simulate both systems to get estimated outputs.

y_sim2 = sim(sys2,z2(:,[],:));
y2 = y_sim2.y;
y_sim4 = sim(sys4,z2(:,[],:));
y4 = y_sim4.y;

% Create cell arrays from the reference and estimated outputs. The reference data set is the same for both model comparisons, so create identical reference cells.

yrefc = {yref yref};
yc = {y2 y4};

% Compute fit values for the three cost functions.

fit_nrmse = goodnessOfFit(yc,yrefc,'NRMSE');





filenamestarter = HPGMdir + datatype + "/" + datatype + "_";

motions = load(filenamestarter + "motiondata.mat").motions;
states = load(filenamestarter + "states.mat").states;
y_values = load(savedsystemsdir + "compare/y_" + num2str(number) + ".mat").y;

ideal_states = load(filenamestarter + "motiondata.mat").motions;
computed_states = load(filenamestarter + "states.mat").states;
%interpolated_states = ;
%y_values = system_states;



%%%%
predicted_ideal = ideal_states;
predicted_computed = computed_states;
observed = system_states;
%%%%



mse_ideal = sum((observed - predicted_ideal).^2) / number;
mse_computed = sum((observed - predicted_computed).^2) / number;


save(msedir + "mse_computed_" + num2str(number) + ".mat", 'mse_ideal')
save(msedir + "mse_ideal_" + num2str(number) + ".mat", 'mse_computed')
fprintf("MSE value is %f for %d experiments!\n", mse, number);





%%%%%%%%
%FROM COMPAREALLSYSTEMS - TODO: DELETE
%%%%%%%%



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
% % Compare against training data
% figurename = num2str(number) + "_training";
% ft = figure('Name', figurename, 'NumberTitle', 'off');
% fprintf("Created the testing figure\n");
% compare(testingdata, sys8, sys9, sys10, sys11, sys12, sys14, sys15);
% saveas(ft, strcat(savedsystemsdir, figurename, '.fig')) % Save figure for further use
% fprintf("Saved training Figure\n");


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


comparedir = savedsystemsdir + "compare/";

% Check if directory exists, if not, mkdir
if not(isfolder(comparedir))
    mkdir(comparedir)
end

[y, fit, ic] = compare(validationdata, sys8, sys9, sys10, sys11, sys12, sys14, sys15);
save(comparedir + "y_" + num2str(number) + ".mat", 'y')
save(comparedir + "fit_" + num2str(number) + ".mat", 'fit')
save(comparedir + "ic_" + num2str(number) + ".mat", 'ic')
fprintf("Saved validation fit and data!\n");

end