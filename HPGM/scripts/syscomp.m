function syscomp(trainingdatacount)

warning('off', 'Ident:estimation:transientDataCorrection') % Turn off annoying warning

% Convert HiPerGator terminal strings to proper numbers, ugh
if (ischar(trainingdatacount))
    trainingdatacount = str2num(trainingdatacount);
end



HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";
systemsdir = HPGMdir + "systems/";



% --- LOAD SYSTEMS --- %

orders = [2 3 4 6 7 8 9 10 11 12 13 14 15]; % TAG: [HARDCODED] % Removed 5 because it was unreasonably out of range ~3000+%

% Load all system order data for a particular number set
systems = cell(numel(orders),1);

for i = 1:numel(orders)
    systems{i} = load(systemsdir + "sys_" + orders(i) + "_" + num2str(trainingdatacount) + ".mat", 'sys');
    systems{i}.Name = "sys" + orders(i);
end
fprintf("Loaded the systems\n");




% --- LOAD DATA --- %

% Load training data
trainingdatafilename = systemsdir + "training_sysiddata.mat";
trainingdata = load(trainingdatafilename, 'data');
fprintf("Loaded the training data\n");

% Load validation data
validationdatafilename = systemsdir + "validation_sysiddata.mat";
validationdata = load(validationdatafilename, 'data');
fprintf("Loaded the validation data\n");




% --- COMPARE APPROACH --- %

% Compare against training data
figurename = num2str(trainingdatacount) + "_training";
ft = figure('Name', figurename, 'NumberTitle', 'off');
fprintf("Created the training figure\n");
compare(trainingdata, systems{:});
saveas(ft, strcat(systemsdir, figurename, '.fig')) % Save figure for further use
fprintf("Saved training Figure\n");

% Compare against validation data
figurename = num2str(trainingdatacount) + "_validation";
fv = figure('Name', figurename, 'NumberTitle', 'off');
fprintf("Created the validation figure\n");
compare(validationdata, systems{:});
saveas(fv, strcat(systemsdir, figurename, '.fig')) % Save figure for further use
fprintf("Saved validation Figure\n");


close all % Close all figures so the program can exit with success


end