function graph_single()

number = 1;

sysiddir = "C:/Users/Jaxton/Desktop/sysid/";


motions = importdata(sysiddir + "validation/motions/validation_" + number + ".mot", '\t', 14).data;
states = importdata(sysiddir + "validation/cmc/validation_" + number + "_states.sto", ' ', 7).data(:,1:5); % Import the data from the file
states(:, 2:5) = rad2deg(states(:, 2:5)); % Convert radians to degrees



figurename = "Motion Graph";
mg = figure('Name', figurename);




motiont = motions(:,1);
motionpos = motions(:,3);

statest = states(:,1);
statespos = states(:,4);
plot(motiont, motionpos, statest, statespos);

legend('Ideal Motion', 'CMC States','Location','southwest')
xlabel('Time (seconds)') 
ylabel('Angle (degrees)') 

saveas(mg, sysiddir + "systems/" + figurename + "gg.fig") % Save figure for further use
fprintf("Motion figure is saved!\n");

end