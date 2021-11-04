function sysid(datatype, number, order)

% Check if datatype is correct
if (~any(datatype == ["Testing", "Validation"])) % If datatype doesn't match these two, throw an error
    error('Datatype must be equal to "Testing" or "Validation"')
end


HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";
systemdatafile = HPGMdir + "sysid/" + datatype + "/" + lower(datatype) + "_sysiddata.mat";


warning('off', 'Ident:estimation:transientDataCorrection') % Turn off annoying warning

% Load the input-output data, which is stored in an iddata object
data = load(systemdatafile).data;
fprintf("I loaded the data\n");


% Convert HiPerGator terminal strings to proper numbers, ugh
if (ischar(number))
    number = str2num(number);
end

if (ischar(order))
    order = str2num(order);
end


% Pull out a specific number of experiments
de = getexp(data, [1, number]);

fprintf("About to run the system\n");

% Generate and save system
sys = n4sid(de, order);


% Saved System File directory and filename
savedsystemsdir = HPGMdir + "sysid/" + datatype + "/SavedSystems/";
savedsystemfilename = savedsystemsdir + "sys_" + num2str(order) + "_" + num2str(number) + ".mat";

% Check if directory exists, if not, mkdir
if not(isfolder(savedsystemsdir))
    mkdir(savedsystemsdir)
end

save(savedsystemfilename, 'sys');
fprintf("Saved system of order %d for %d experiments\n", order, number);

end