function run_sysID(order)

warning('off', 'Ident:estimation:transientDataCorrection') % Turn off annoying warning

% Load the input-output data, which is stored in an iddata object
testingdatafilename = "System Identification\Testing\testing_sysiddata.mat";

testingdata = load(testingdatafilename).data;


% Generate and save system
sys = n4sid(testingdata, order);

savefilename = "C:\Users\Jaxton\controlled-movement\System Identification\Testing\sys_" + num2str(order) + ".mat";
save(savefilename, 'sys');

end