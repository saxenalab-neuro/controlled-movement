clear;clc;close all;


fit = cell(1,15);




for order=2:15
    reportfilename = "systems/sys_" + num2str(order) + "_report.mat";
    fit{order} = load(reportfilename).report.Fit;
end


lowest_MSE = [1 0; 1 0];

for order=2:15
    mse = fit{order}.MSE;
    
    if (mse(1) < lowest_MSE(1,1))
        lowest_MSE(1,1) = mse(1);
        lowest_MSE(1,2) = order;
    end
    
    if (mse(2) < lowest_MSE(2,1))
        lowest_MSE(2,1) = mse(2);
        lowest_MSE(2,2) = order;
    end
end


fprintf("Lowest MSE is for system %d and system %d", lowest_MSE(1,2), lowest_MSE(2,2));
% 13 appears to have the lowest MSE