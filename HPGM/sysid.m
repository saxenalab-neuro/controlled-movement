function sysid(number, order)

warning('off', 'Ident:estimation:transientDataCorrection') % Turn off annoying warning

% Load the input-output data, which is stored in an iddata object
data = load('testing_sysiddata.mat').data;
fprintf("I loaded the data\n");

fprintf("About to run the system\n");

% Convert HiPerGator terminal strings to proper numbers, ugh
if (ischar(number))
    number = str2num(number);
end

if (ischar(order))
    order = str2num(order);
end

% Pull out a specific number of experiments
de = getexp(data, [1, number]);


% Generate and save system
sys = n4sid(de, order);
fprintf("WE MADE IT?\n");

savefilename = "SavedSystems/sys_" + num2str(number) + "_" + num2str(order) + ".mat";
save(savefilename, 'sys');
fprintf("I saved the system!\n");

end