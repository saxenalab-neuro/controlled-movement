function fullsid()

%%% CLEANER %%%

% Clean up last results
cleaner()




%%% TESTING DATA %%%

% Run Testing for 5000 experiments

% Initialize properties
datatype = "Testing";
number = 5000;
arrmax = 50;
PER_TASK = number/arrmax;

% Motion file creation
mcp1(datatype,PER_TASK,arrmax)

% CMC
mcp2(datatype,PER_TASK,arrmax)

% Collect files and turn them into .mat files
mcp3(datatype)

% Create data file
sidp1(datatype)

% For system order identification
numbers = [(number/10) (number/4) (number/2) (number*3/4) (number)];
orders = [8 9 10 11 12 14 15];
arrmax = numel(numbers) * numel(orders);

% System identification
sidp2(datatype,number,arrmax)





%%% VALIDATION DATA %%%

% Run Validation for 500 experiments

% Initialize properties
datatype = "Validation";
number = 500;
arrmax = 50;
PER_TASK = number/arrmax;

% Motion file creation
mcp1(datatype,PER_TASK,arrmax)

% CMC
mcp2(datatype,PER_TASK,arrmax)

% Collect files and turn them into .mat files
mcp3(datatype)

% Create data file
sidp1(datatype)




%%% SYSTEM COMPARISON %%%

% Compare the systems and save .figs
comparesystems(number, numbers)

end