function sysfit(trainingdatacount)

warning('off', 'Ident:estimation:transientDataCorrection') % Turn off annoying warning

% Convert HiPerGator terminal strings to proper numbers, ugh
if (ischar(trainingdatacount))
    trainingdatacount = str2num(trainingdatacount);
end



HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";
systemsdir = HPGMdir + "systems/";



% --- LOAD DATA --- %

% Load yref system data
yrefdir = systemsdir + "yref/";

training_yrefc = load(yrefdir + "training_yrefc_" + num2str(trainingdatacount) + ".mat").training_yrefc;
validation_yrefc = load(yrefdir + "validation_yrefc_" + num2str(trainingdatacount) + ".mat").validation_yrefc;
fprintf("Loaded reference values\n");

% Load yc system data
ycdir = systemsdir + "yc/";

training_yc = load(ycdir + "training_yc_" + num2str(trainingdatacount) + ".mat").training_yc;
validation_yc = load(ycdir + "validation_yc_" + num2str(trainingdatacount) + ".mat").validation_yc;
fprintf("Loaded simulated values\n");





% --- CALCULATE FIT VALUES --- %

% Compute training data fit values for the three cost functions
training_fit_mse = goodnessOfFit(training_yc, training_yrefc, 'MSE');
training_fit_nmse = goodnessOfFit(training_yc, training_yrefc, 'NMSE');
training_fit_nrmse = goodnessOfFit(training_yc, training_yrefc, 'NRMSE');
fprintf("Computed training data fit values for the three cost functions\n");

% Compute validation data fit values for the three cost functions
validation_fit_mse = goodnessOfFit(validation_yc, validation_yrefc, 'MSE');
validation_fit_nmse = goodnessOfFit(validation_yc, validation_yrefc, 'NMSE');
validation_fit_nrmse = goodnessOfFit(validation_yc, validation_yrefc, 'NRMSE');
fprintf("Computed validation data fit values for the three cost functions\n");




% --- SAVE FIT VALUES --- %

msedir = systemsdir + "mse/";
nmsedir = systemsdir + "nmse/";
nrmsedir = systemsdir + "nrmse/";

% Check if directory exists, if not, mkdir
if not(isfolder(msedir))
    mkdir(msedir)
end

if not(isfolder(nmsedir))
    mkdir(nmsedir)
end

if not(isfolder(nrmsedir))
    mkdir(nrmsedir)
end


% Save training data fit values to mse directory
save(msedir + "training_fit_mse_" + num2str(trainingdatacount) + ".mat", 'training_fit_mse')
save(nmsedir + "training_fit_nmse_" + num2str(trainingdatacount) + ".mat", 'training_fit_nmse')
save(nrmsedir + "training_fit_nrmse_" + num2str(trainingdatacount) + ".mat", 'training_fit_nrmse')
fprintf("Saved training data fit values to mse directories\n");

% Save validation data fit values to mse directory
save(msedir + "validation_fit_mse_" + num2str(trainingdatacount) + ".mat", 'validation_fit_mse')
save(nmsedir + "validation_fit_nmse_" + num2str(trainingdatacount) + ".mat", 'validation_fit_nmse')
save(nrmsedir + "validation_fit_nrmse_" + num2str(trainingdatacount) + ".mat", 'validation_fit_nrmse')
fprintf("Saved validation data fit values to mse directories\n");


fprintf("--- ALL DONE ---\n");

end