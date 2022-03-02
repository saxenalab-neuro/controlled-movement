function syssimulate(trainingdatacount)

warning('off', 'Ident:estimation:transientDataCorrection') % Turn off annoying warning

% Convert HiPerGator terminal strings to proper numbers, ugh
if (ischar(trainingdatacount))
    trainingdatacount = str2num(trainingdatacount);
end



HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";
systemsdir = HPGMdir + "systems/";


license('inuse')
license('test','Identification_Toolbox')
license('checkout','Identification_Toolbox')

% --- LOAD SYSTEMS --- %

orders = [2 3 4 6 7 8 9 10 11 12 13 14 15]; % TAG: [HARDCODED] % Removed 5 because it was unreasonably out of range ~3000+%

% Load all system order data for a particular number set
systems = cell(numel(orders),1);

for i = 1:numel(orders)
    systems{i} = load(systemsdir + "sys_" + orders(i) + "_" + num2str(trainingdatacount) + ".mat", 'sys');
    %systems{i}.Name = "sys" + orders(i);
end
fprintf("Loaded the systems\n");




% --- LOAD DATA --- %

% Load training data
trainingdatafilename = systemsdir + "training_sysiddata.mat";
trainingdata = load(trainingdatafilename).data;
training_yref = trainingdata.y; % Copy the measured output into reference output yref.
fprintf("Loaded the training data\n");

% Load validation data
validationdatafilename = systemsdir + "validation_sysiddata.mat";
validationdata = load(validationdatafilename).data;
validation_yref = validationdata.y; % Copy the measured output into reference output yref.
fprintf("Loaded the validation data\n");




% --- REFERENCE DATA --- %

% Create reference data
training_yrefc = cell(numel(orders),1);
for i = 1:numel(orders)
    training_yrefc{i} = training_yref;
end

validation_yrefc = cell(numel(orders),1);
for i = 1:numel(orders)
    validation_yrefc{i} = validation_yref;
end
fprintf("Created reference data\n");




% --- SAVE YREF VALUES --- %

yrefdir = systemsdir + "yref/";

% Check if directory exists, if not, mkdir
if not(isfolder(yrefdir))
    mkdir(yrefdir)
end

save(yrefdir + "training_yrefc_" + num2str(trainingdatacount) + ".mat", 'training_yrefc')
save(yrefdir + "validation_yrefc_" + num2str(trainingdatacount) + ".mat", 'validation_yrefc')
fprintf("Saved reference values to yref directory\n");




% --- SIMULATION DATA --- %

% Create simulation data cell arrays
training_ysim = cell(numel(orders),1);
training_yc = cell(numel(orders),1);

validation_ysim = cell(numel(orders),1);
validation_yc = cell(numel(orders),1);
fprintf("Created simulation data cell arrays\n");


% Simulate both systems to get estimated outputs
for i = 1:numel(orders)
    training_ysim{i} = sim(systems{i},trainingdata(:,[],:)); % Simulate on training data
    training_yc{i} = training_ysim{i}.y;
end
fprintf("Simulated on training data\n");

for i = 1:numel(orders)
    validation_ysim{i} = sim(systems{i},validationdata(:,[],:)); % Simulate on validation data
    validation_yc{i} = validation_ysim{i}.y;
end
fprintf("Simulated on validation data\n");




% --- SAVE YSIM VALUES --- %

ysimdir = systemsdir + "ysim/";

% Check if directory exists, if not, mkdir
if not(isfolder(ysimdir))
    mkdir(ysimdir)
end

save(ysimdir + "training_ysim_" + num2str(trainingdatacount) + ".mat", 'training_ysim')
save(ysimdir + "validation_ysim_" + num2str(trainingdatacount) + ".mat", 'validation_ysim')
fprintf("Saved simulated values to ysim directory\n");




% --- SAVE YC VALUES --- %

ycdir = systemsdir + "yc/";

% Check if directory exists, if not, mkdir
if not(isfolder(ycdir))
    mkdir(ycdir)
end

save(ycdir + "training_yc_" + num2str(trainingdatacount) + ".mat", 'training_yc')
save(ycdir + "validation_yc_" + num2str(trainingdatacount) + ".mat", 'validation_yc')
fprintf("Saved simulated values to ysim directory\n");

fprintf("--- ALL DONE ---\n");

end