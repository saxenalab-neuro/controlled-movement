function autographer(datatype)

filenamestarter = "System Identification/" + datatype + "/" + lower(datatype) + "_";

motions = load(filenamestarter + "motiondata.mat").motions;
states = load(filenamestarter + "states.mat").states;
controls = load(filenamestarter + "controls.mat").controls;


figure()

for i=1:numel(motions)
    
    t = motions{i}.data(:,1);
    pos = motions{i}.data(:,3);
    
    % Make the plots
    subplot(2,1,1);
    plot(t, pos);
    hold on
    
end

title("Motion - Elbow Pos");
hold off

for i=1:numel(states)
    
    t = states{i}(:,1);
    pos = states{i}(:,4);
    
    subplot(2,1,2);
    plot(t, pos);
    hold on
    
end

title("States - Elbow Pos");
hold off

end