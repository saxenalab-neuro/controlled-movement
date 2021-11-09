function R2 = calculateR2(z,z_est)
% calcuateR2 Cacluate R-squared
% R2 = calcuateR2(z,z_est) takes two inputs - The observed data x and its
% estimation z_est (may be from a regression or other model), and then
% compute the R-squared value a measure of goodness of fit. R2 = 0
% corresponds to the worst fit, whereas R2 = 1 corresponds to the best fit.
% 
% Copyright @ Md Shoaibur Rahman (shaoibur@bcm.edu)

r = z-z_est;
normr = norm(r);
SSE = normr.^2;
SST = norm(z-mean(z))^2;
R2 = 1 - SSE/SST;
