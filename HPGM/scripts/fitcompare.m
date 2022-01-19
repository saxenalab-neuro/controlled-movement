function fitcompare(number)

% Convert HiPerGator terminal strings to proper numbers, ugh
if (ischar(number))
    number = str2num(number);
end

HPGMdir = "/home/jaxtonwillman/Desktop/HPGM/";
savedsystemsdir = "../sysid/training/SavedSystems/";

fit = load(savedsystemsdir + "compare/testing_fit_" + num2str(number) + ".mat").fit;

[orders, experiments] = size(fit);


NRMSE = zeros(orders,4);

for order = 1:orders
    
    values = zeros(1,4);
    
    for experiment = 1:experiments
        values(1) = values(1) + fit{order, experiment}(1);
        values(2) = values(2) + fit{order, experiment}(2);
        values(3) = values(3) + fit{order, experiment}(3);
        values(4) = values(4) + fit{order, experiment}(4);
    end
    
    values = values./experiments;
    
    NRMSE(order,:) = values;
    
end


bestorder = find(NRMSE(:,3) == min(NRMSE(:,3)));

fprintf("A system of order %d is the most optimal for elbow value tracking\n", bestorder);


save(savedsystemsdir + "compare/testing_NRMSE_" + num2str(number) + ".mat", 'NRMSE')

end