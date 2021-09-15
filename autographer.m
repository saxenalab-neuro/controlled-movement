function autographer(number)

% Get data from files
desiredstatesfile = "C:\Users\Jaxton\controlled-movement\System Identification\Motion Files\script_" + num2str(number) + ".mot"; % Assign the file name
cmcstatesfile = "C:\Users\Jaxton\controlled-movement\System Identification\CMC_Results\cmc_" + num2str(number) + "_states.sto"; % Assign the file name

if (isfile(desiredstatesfile) && isfile(cmcstatesfile))
    desiredstates = importdata(desiredstatesfile, '\t', 14).data; % Import the data from the file
    cmcstates = importdata(cmcstatesfile, ' ', 7).data; % Import the data from the file

    % Get Data
    tdesired = desiredstates(:,1);
    shoulderdesired = desiredstates(:,2);
    elbowdesired = desiredstates(:,3);

    tcmc = cmcstates(:,1);
    shouldercmc = rad2deg(cmcstates(:,2));
    elbowcmc = rad2deg(cmcstates(:,4));


    % Make the plots
    subplot(1,2,1);
    plot(tdesired, elbowdesired, tcmc, elbowcmc);
    title("Elbow States");
    legend("Desired", "CMC");

    subplot(1,2,2);
    plot(tdesired, shoulderdesired, tcmc, shouldercmc);
    title("Shoulder States");
    legend("Desired", "CMC");
    
else
    fprintf("Files don't exist for script %d", number);
end



end