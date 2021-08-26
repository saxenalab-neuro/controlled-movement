function [] = raw_vs_cmc_error(number)


 


% Get data from files
rawstatesfile = "System Identification/Motion Files/script_" + num2str(number) + ".mot"; % Assign the file name
rawstates = importdata(rawstatesfile, '\t', 14).data; % Import the data from the file

cmcstatesfile = "System Identification/CMC_Results/cmc_" + num2str(number) + "_states.sto"; % Assign the file name
cmcstates = importdata(cmcstatesfile, ' ', 7).data; % Import the data from the file

fdnewstatesfile = "System Identification/FD_Results_New/fd_" + num2str(number) + "_states.sto"; % Assign the file name
fdnewstates = importdata(fdnewstatesfile, ' ', 7).data; % Import the data from the file



% Assign data
traw = rawstates(:,1);
tcmc = cmcstates(:,1);
tfd = fdnewstates(:,1);

% raw = [time, elbow, shoulder]
raw(:,1) = traw;
raw(:,2) = rawstates(:,3);
raw(:,3) = rawstates(:,2);

% cmc = [time, elbow, shoulder]
cmc(:,1) = tcmc;
cmc(:,2) = rad2deg(cmcstates(:,4));
cmc(:,3) = rad2deg(cmcstates(:,2));

% fd = [time, elbow, shoulder]
fd(:,1) = tfd;
fd(:,2) = rad2deg(fdnewstates(:,4));
fd(:,3) = rad2deg(fdnewstates(:,2));




% Process data
% data = [t, rawelbow, rawshoulder, cmcelbow, cmcshoulder, fdelbow, fdshoulder]
data = zeros(97,7); % 0.03 to 0.99 [TAG: HARDCODED]

data(:,1) = raw(4:100,1);
data(:,2) = raw(4:100,2);
data(:,3) = raw(4:100,3);


cmclastindex = 1;
fdlastindex = 1;

for i = 1:numel(data(:,1))
    rawtime = data(i,1);
    
    % Check CMC values
    for cmcindex = 1:numel(tcmc)
        % Boost speed
        if (cmclastindex > cmcindex)
            continue;
        end
        
        % Check if raw time = cmc time
        if (tcmc(cmcindex) == rawtime)
            % Assign values to data matrix
            data(i,4) = cmc(cmcindex,2); % Elbow
            data(i,5) = cmc(cmcindex,3); % Shoulder
            cmclastindex = cmcindex; % Update speed index
            break; % Done
        end
    end
    
    
    % Check FD values
    for fdindex = 1:numel(tfd)
        % Boost speed
        if (fdlastindex > fdindex)
            continue;
        end
        
        % Check if raw time = fd time, we know very last value is exact so this case works
        if (tfd(fdindex) == rawtime)
            % Assign values to data matrix
            data(i,6) = fd(fdindex,2); % Elbow
            data(i,7) = fd(fdindex,3); % Shoulder
            fdlastindex = fdindex; % Update speed index
            break; % Done
        end
        
        % Else it's going to be approximate
        if (tfd(fdindex) < rawtime &&  rawtime < tfd(fdindex + 1))
            if ((rawtime - tfd(fdindex)) < (tfd(fdindex+1) - rawtime))
                % Earlier (current) value is closer to the raw time value Assign values to data matrix
                data(i,6) = fd(fdindex,2); % Elbow
                data(i,7) = fd(fdindex,3); % Shoulder
                fdlastindex = fdindex; % Update speed index
            else
                % Later (next) value is closer to the raw time value Assign values to data matrix
                data(i,6) = fd(fdindex,2); % Elbow
                data(i,7) = fd(fdindex,3); % Shoulder
                fdlastindex = fdindex+1; % Update speed index
            end
            
            break; % Done
        end
    end
end


% Calculate error
% (cmc - raw) * 100% should result in positive if over and negative in under

% errordata = [t, elbow(cmc-raw), elbow(fd-raw), shoulder(cmc-raw), shoulder(fd-raw)]
errordata = zeros(97,5);
errordata(:,1) = data(:,1);

errordata(:,2) = (data(:,4) - data(:,2)); %./ data(:,2) .* 100;
errordata(:,3) = (data(:,6) - data(:,2)); %./ data(:,2) .* 100;
errordata(:,4) = (data(:,5) - data(:,3)); %sqrt(mean((data(:,3) - data(:,5)).^2));
errordata(:,5) = (data(:,7) - data(:,3)); %sqrt(mean((data(:,3) - data(:,7)).^2));



% RMSE
fprintf("RMSE Elbow Error (CMC - RAW) %f\n", sqrt(mean((data(:,2) - data(:,4)).^2)));
fprintf("RMSE Elbow Error (FD - RAW) %f\n", sqrt(mean((data(:,2) - data(:,6)).^2)));
fprintf("RMSE Shoulder Error (CMC - RAW) %f\n", sqrt(mean((data(:,3) - data(:,5)).^2)));
fprintf("RMSE Shoulder Error (FD - RAW) %f\n", sqrt(mean((data(:,3) - data(:,7)).^2)));




% Graph
figurename = "Raw, CMC, and FD Error Comparison: File  " + num2str(number);
figure('Name', figurename, 'NumberTitle', 'off');

% Make the plots
subplot(2,2,1)
bar(errordata(:,1), errordata(:,2))
title("Elbow Error (CMC - RAW)");

subplot(2,2,2)
bar(errordata(:,1), errordata(:,3))
title("Elbow Error (FD - RAW)");

subplot(2,2,3)
bar(errordata(:,1), errordata(:,4))
title("Shoulder Error (CMC - RAW)");

subplot(2,2,4)
bar(errordata(:,1), errordata(:,5))
title("Shoulder Error (FD - RAW)");

end