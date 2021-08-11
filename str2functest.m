clear;clc;


t = transpose(0:.01:1);



numfunctions = 1;


args = ["0", "200*t-20", "70", "200*t-40", "140"]; % Piecewise arguments, need to make sure they are in proper matrix math form
bounds = [0, 0.1; 0.1, 0.45; 0.45, 0.55; 0.55, 0.9; 0.9, 1]; % Lower Bound, Upper Bound

% @(t) (0).*((t>=0)&(t<0.1)) + ...
%     (200*t-20).*((t>=0.1)&(t<0.45)) + ...
%     (70).*((t>=0.45)&(t<0.55)) + ...
%     (200*t-40).*((t>=0.55)&(t<0.9)) + ...
%     (140).*((t>=0.9)&(t<=1));


f = cell(1,numfunctions);

% FOR EACH FUNCTON for i = 1:numel(functions)

func = "@(t) ";

for i = 1:numel(args)
    func = strcat(func, "(" + args(i) + ").*((t>=" + num2str(bounds(i,1)) + ")&(t<");
    
    if (i == numel(args))
        func = strcat(func, "="); % Last line so make sure equal to final value
    end
    
    func = strcat(func, num2str(bounds(i,2)) + "))");
    
    if (i < numel(args))
        func = strcat(func, " + "); % Not the last line so continue the function
    elseif (i == numel(args))
        func = strcat(func, ";"); % Last line so end the function
    end
end

f{1} = str2func(func);

% END FOR EACH FUNCTION


% argtmp = "(" + fs11 + ").*((t>=" + num2str(lb) + ")&(t<" + num2str(ub) + "))"
% tmp = "@(t) " + fs11;
% 
% f1 = str2func(tmp);



plot(t,f{1}(t));