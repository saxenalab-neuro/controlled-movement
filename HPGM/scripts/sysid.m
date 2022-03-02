function sysid(number, order)

warning('off', 'Ident:estimation:transientDataCorrection') % Turn off annoying warning

% Convert HiPerGator terminal strings to proper numbers, ugh
if (ischar(number))
    number = str2num(number);
end

if (ischar(order))
    order = str2num(order);
end



HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";
systemdatafile = HPGMdir + "systems/training_sysiddata.mat";


% Load the input-output data, which is stored in an iddata object
data = load(systemdatafile).data;
fprintf("I loaded the data\n");


% Pull out a specific number of experiments
de = getexp(data, [1, number]);

fprintf("About to run the system\n");

% Generate and save system
sys = n4sid(de, order);
sys.Name = "sys" + order;

% Saved System File directory and filename
savedsystemfilename = HPGMdir + "systems/" + "sys_" + num2str(order) + "_" + num2str(number) + ".mat";
save(savedsystemfilename, 'sys');
fprintf("Saved system of order %d for %d experiments\n", order, number);

end