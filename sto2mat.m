function [] = sto2mat(numscripts)

% Idea is to run this once so we don't have to call such heavy functions such as importdata every time.
% My hope is loading a .mat is significantly faster than importdata 'ing a .sto
% The results are in! Loading .mat files is SIGNIFICANTLY faster than importdata!



for number = 1:numscripts
    cmccontrolsfile = "System Identification/CMC_Results/cmc_" + num2str(number) + "_controls.sto";
    cmccontrols = importdata(cmccontrolsfile, '\t', 7).data; % Import the data from the file

    cmcstatesfile = "System Identification/CMC_Results/cmc_" + num2str(number) + "_states.sto";
    cmcstates = importdata(cmcstatesfile, ' ', 7).data; % Import the data from the file


    % Assign data
    tcontrols = cmccontrols(:,1);
    tstates = cmcstates(:,1);

    if(tcontrols ~= tstates)
        fprintf("CRIT_ERR: Time difference between controls and states on FILE %d\n", number)
    end

    
    controlsfilename = append('System Identification/Data/controls_', num2str(number), '.mat');
    statesfilename = append('System Identification/Data/states_', num2str(number), '.mat');

    save(controlsfilename, 'cmccontrols')
    save(statesfilename, 'cmcstates')
end

end