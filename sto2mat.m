function [unconverted] = sto2mat(numscripts)

% Idea is to run this once so we don't have to call such heavy functions such as importdata every time.
% My hope is loading a .mat is significantly faster than importdata 'ing a .sto
% The results are in! Loading .mat files is SIGNIFICANTLY faster than importdata!

unconverted = zeros(1,numscripts);

times = zeros(1,numscripts);

for number = 1:numscripts
    tic % Begin timer
    
    cmccontrolsfile = "C:/Users/Jaxton/controlled-movement/System Identification/CMC_Results/cmc_" + num2str(number) + "_controls.sto";
    cmcstatesfile = "C:/Users/Jaxton/controlled-movement/System Identification/CMC_Results/cmc_" + num2str(number) + "_states.sto";
    
    if (isfile(cmccontrolsfile) && isfile(cmcstatesfile))
        cmccontrols = importdata(cmccontrolsfile, '\t', 7).data; % Import the data from the file
        cmcstates = importdata(cmcstatesfile, ' ', 7).data(:,1:5); % Import the data from the file
        cmcstates(:, 2:5) = rad2deg(cmcstates(:, 2:5)); % Convert to degrees
    else
        fprintf("CRIT_ERR: cmc_%d files are nonexistent\n", number);
        unconverted(number) = number;
        continue % File must have borked so it doesn't exist, let's move on
    end


    % Assign data
    tcontrols = cmccontrols(:,1);
    tstates = cmcstates(:,1);

    if (tcontrols ~= tstates)
        fprintf("CRIT_ERR: Time difference between controls and states on FILE %d\n", number)
    end

    controlsfilename = append('C:/Users/Jaxton/controlled-movement/System Identification/Data/controls_', num2str(number), '.mat');
    statesfilename = append('C:/Users/Jaxton/controlled-movement/System Identification/Data/states_', num2str(number), '.mat');

    save(controlsfilename, 'cmccontrols')
    save(statesfilename, 'cmcstates')
    
    times(number) = toc;
    %fprintf("%d: sto2mat | %f seconds\n", number, toc); % End timer and report
end

times = times(times~=0); % Remove all zeros from array, obviously those values didn't work
fprintf("\nSto2Mat Average time: %f | Total time: %f\n", mean(times), sum(times));
unconverted = unconverted(unconverted~=0);
fprintf("\nNOTICE: %d files failed to convert\n", numel(unconverted));

end