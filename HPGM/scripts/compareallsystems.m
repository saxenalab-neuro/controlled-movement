function compareallsystems()


HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";

savedsystemsdir = HPGMdir + "sysid/Testing/SavedSystems/";

testingdatacount = 5000; % TAG: [HARDCODED]
orders = [10 11 12 13 14 15]; % TAG: [HARDCODED]

systems = cell(numel(orders),1);

for i = 1:numel(orders)
    % Load all system order data for a particular number set
    systems{i} = load(savedsystemsdir + "sys_" + orders(i) + "_" + num2str(testingdatacount) + ".mat").sys;
end

% Load testing data
testingdatafilename = HPGMdir + "sysid/Testing/testing_sysiddata.mat";
testingdata = load(testingdatafilename).data;
testingdata = getexp(testingdata, 1:testingdatacount); % Get the correct number of experiments


% Compare against Testing data
figurename = "Testing";
ft = figure('Name', figurename, 'NumberTitle', 'off');
[~,fit,~] = compare(testingdata, systems{:});
saveas(ft, strcat(savedsystemsdir, figurename, '.fig')) % Save figure for further use

testingfitfilename = savedsystemsdir + "testing_fit.mat";
save(testingfitfilename, 'fit');


% Load validation data
validationdatafilename = HPGMdir + "sysid/Validation/validation_sysiddata.mat";
validationdata = load(validationdatafilename).data;

% Compare against Validation data
figurename = "Validation";
fv = figure('Name', figurename, 'NumberTitle', 'off');
[~,fit,~] = compare(validationdata, systems{:});
saveas(fv, strcat(savedsystemsdir, figurename, '.fig')) % Save figure for further use

validationfitfilename = savedsystemsdir + "validation_fit.mat";
save(validationfitfilename, 'fit');
end