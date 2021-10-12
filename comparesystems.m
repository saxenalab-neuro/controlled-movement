function comparesystems(numscripts)


% Ensure entered value matches one of the following
scriptnums = [100 250 750 1000 1500 2000 2500 3000 4000 5000]; % TAG: [HARDCODED]

assmsg = "Invalid number, please choose one of the following: 100 250 750 1000 1500 2000 2500 3000 4000 5000";
assert(ismember(numscripts, scriptnums), assmsg)


% Load all system order data for a particular number set
sys2filename = "HPGM\SavedSystems\sys_" + num2str(numscripts) + "_2.mat";
sys4filename = "HPGM\SavedSystems\sys_" + num2str(numscripts) + "_4.mat";
sys6filename = "HPGM\SavedSystems\sys_" + num2str(numscripts) + "_6.mat";
sys8filename = "HPGM\SavedSystems\sys_" + num2str(numscripts) + "_8.mat";
sys10filename = "HPGM\SavedSystems\sys_" + num2str(numscripts) + "_10.mat";

sys2 = load(sys2filename).sys;
sys4 = load(sys4filename).sys;
sys6 = load(sys6filename).sys;
sys8 = load(sys8filename).sys;
sys10 = load(sys10filename).sys;


% Load testing data
testingdatafilename = "System Identification\Testing\testing_sysiddata.mat";
testingdata = load(testingdatafilename).data;

% Load validation data
validationdatafilename = "System Identification\Validation\validation_sysiddata.mat";
validationdata = load(validationdatafilename).data;

dt = getexp(testingdata, 1:10);
dv = getexp(validationdata, 1:10);

% Compare the simulated model response with the measured output
[y, fit, ic] = compare(dt, sys2, sys4, sys6, sys8, sys10);

end