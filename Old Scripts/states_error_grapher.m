function [] = states_error_grapher(number, newstates)





% Get data from files
desiredstatesfile = "System Identification/Motion Files/script_" + num2str(number) + ".mot"; % Assign the file name
desiredstates = importdata(desiredstatesfile, '\t', 14).data; % Import the data from the file

cmcstatesfile = "System Identification/CMC_Results/cmc_" + num2str(number) + "_states.sto"; % Assign the file name
cmcstates = importdata(cmcstatesfile, ' ', 7).data; % Import the data from the file

fdstatesfile = "System Identification/FD_Results/fd_" + num2str(number) + "_states.sto"; % Assign the file name
fdstates = importdata(fdstatesfile, ' ', 7).data; % Import the data from the file

if (newstates)
    fdnewstatesfile = "System Identification/FD_Results_New/fd_" + num2str(number) + "_states.sto"; % Assign the file name
    fdnewstates = importdata(fdnewstatesfile, ' ', 7).data; % Import the data from the file
end

tdesired = desiredstates(:,1);
shoulderdesired = desiredstates(:,2);
elbowdesired = desiredstates(:,3);

tcmc = cmcstates(:,1);
shouldercmc = rad2deg(cmcstates(:,2));
elbowcmc = rad2deg(cmcstates(:,4));

tfd = fdstates(:,1);
shoulderfd = rad2deg(fdstates(:,2));
elbowfd = rad2deg(fdstates(:,4));

if (newstates)
    tfdnew = fdnewstates(:,1);
    shoulderfdnew = rad2deg(fdnewstates(:,2));
    elbowfdnew = rad2deg(fdnewstates(:,4));
end




figurename = "Elbow and Shoulder States Comparison: File  " + num2str(number);
figure('Name', figurename, 'NumberTitle', 'off');

if (newstates)
    % Make the plots
    subplot(1,2,1)
    plot(tdesired, elbowdesired, tcmc, elbowcmc, tfd, elbowfd, tfdnew, elbowfdnew)
    title("Elbow States");
    legend("Desired", "CMC", "FD", "FD New");

    subplot(1,2,2)
    plot(tdesired, shoulderdesired, tcmc, shouldercmc, tfd, shoulderfd, tfdnew, shoulderfdnew)
    title("Shoulder States");
    legend("Desired", "CMC", "FD", "FD New");
else
    % Make the plots
    subplot(1,2,1)
    plot(tdesired, elbowdesired, tcmc, elbowcmc, tfd, elbowfd)
    title("Elbow States");
    legend("Desired", "CMC", "FD");

    subplot(1,2,2)
    plot(tdesired, shoulderdesired, tcmc, shouldercmc, tfd, shoulderfd)
    title("Shoulder States");
    legend("Desired", "CMC", "FD");
end

end