clear;clc;

% Obtain the defined functions as piecewise function objects
pwfuncobjects = readpwfunctions("functions.txt");


% Now we have all these functions, need to convert them to function handles


%t = transpose(0:.01:1);


numfunctions = numel(pwfuncobjects);
f = cell(1,numfunctions); % Preallocate the function handles cell array

% Convert each function into a function handle!
for functionnum = 1:numfunctions
    
    % Get object properties
    numargs = pwfuncobjects{functionnum}.getNumArgs;
    args = pwfuncobjects{functionnum}.getArgs;
    bounds = pwfuncobjects{functionnum}.getBounds;
    
    func = "@(t) ";
    
    for argnum = 1:numargs
        % First part is big, add the argument, and the first bound and part of the second bound
        func = strcat(func, "(" + args(argnum) + ").*((t>=" + num2str(bounds(argnum,1)) + ")&(t<");
        
        if (argnum == numargs)
            func = strcat(func, "="); % Last line so make sure equal to final bound
        end
        
        % Add the second bound and wrap it up
        func = strcat(func, num2str(bounds(argnum,2)) + "))");
        
        if (argnum < numargs)
            func = strcat(func, " + "); % Not the last line so continue the function
        elseif (argnum == numargs)
            func = strcat(func, ";"); % Last line so end the function
        end
    end
    
    % Assign the properties to an object and add it to the list
    tmp.func = str2func(func);
    tmp.ti = bounds(1,1);
    tmp.tf = bounds(numargs,2);    
    f{functionnum} = tmp;
end

% Now I have a whole lot of function handles



t = f{1}.ti:0.01:f{1}.tf;
plot(t,f{1}(t));

