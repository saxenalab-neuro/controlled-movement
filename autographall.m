function autographall(numscripts)


% Load Elbow Deired Motions
motionsdatafile = "C:/Users/Jaxton/controlled-movement/System Identification/Motion Files/motiondata.mat";
motions = load(motionsdatafile).motions;

% Elbow Deired Motions
subplot(2,1,1)
for i=1:numscripts
    plot(motions{1,i}.data(:,1), motions{1,i}.data(:,3));
    hold on
end


% Elbow CMC Motions
subplot(2,1,2)
for number = 1:numscripts
    % Load .mat files
    cmccontrolsfile = "C:/Users/Jaxton/controlled-movement/System Identification/Data/controls_" + num2str(number) + ".mat";
    cmcstatesfile = "C:/Users/Jaxton/controlled-movement/System Identification/Data/states_" + num2str(number) + ".mat";
    
    cmccontrols = load(cmccontrolsfile).cmccontrols;
    cmcstates = load(cmcstatesfile).cmcstates;
    
    plot(cmcstates(:,1), cmcstates(:,4));
    hold on
end


end