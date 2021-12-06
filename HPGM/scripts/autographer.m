function autographer(datatype)

% Check if datatype is correct
if (~any(datatype == ["Testing", "Validation"])) % If datatype doesn't match these two, throw an error
    error('Datatype must be equal to "Testing" or "Validation"')
end


HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";

savedsystemsdir = HPGMdir + "sysid/Testing/SavedSystems/";
filenamestarter = HPGMdir + "sysid/" + datatype + "/" + lower(datatype) + "_";

motions = load(filenamestarter + "motiondata.mat").motions;
states = load(filenamestarter + "states.mat").states;
controls = load(filenamestarter + "controls.mat").controls;

figurename = datatype + " Motion Graph";
mg = figure('Name', figurename);


if numel(motions) < 500
    number = numel(motions);
else
    number = 500;
end

for i=1:number
    
    t = motions{i}.data(:,1);
    pos = motions{i}.data(:,3);
    
    % Make the plots
    subplot(2,1,1);
    plot(t, pos);
    hold on
    
end

title("Motion - Elbow Pos");
hold off


for i=1:number
    
    t = states{i}(:,1);
    pos = states{i}(:,4);
    
    subplot(2,1,2);
    plot(t, pos);
    hold on
    
end

title("States - Elbow Pos");
hold off


saveas(mg, savedsystemsdir + figurename + ".fig") % Save figure for further use
fprintf("Motion figure is saved!\n");

end