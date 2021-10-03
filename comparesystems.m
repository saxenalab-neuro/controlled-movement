function comparesystems()

% Load systems of training data
sys2filename = "C:\Users\Jaxton\controlled-movement\System Identification\Testing\sys_2.mat";
sys4filename = "C:\Users\Jaxton\controlled-movement\System Identification\Testing\sys_4.mat";
sys6filename = "C:\Users\Jaxton\controlled-movement\System Identification\Testing\sys_6.mat";
sys8filename = "C:\Users\Jaxton\controlled-movement\System Identification\Testing\sys_8.mat";
sys10filename = "C:\Users\Jaxton\controlled-movement\System Identification\Testing\sys_10.mat";

sys2 = load(sys2filename).sys;
sys4 = load(sys4filename).sys;
sys6 = load(sys6filename).sys;
sys8 = load(sys8filename).sys;
sys10 = load(sys10filename).sys;


% Load validation data
validationdatafilename = "System Identification\Validation\validation_sysiddata.mat";

validationdata = load(validationdatafilename).data;


% Compare the simulated model response with the measured output
compare(validationdata, sys2, sys4, sys6, sys8, sys10)

end