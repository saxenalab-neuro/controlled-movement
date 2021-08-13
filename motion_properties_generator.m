function [motions] = motion_properties_generator()

% This function reads the "functions.txt" file where the motions are described as piecewise functions
% It creates objects storing these piecewise function arguments and then joins the arguments together as a function in string form
% It converts this new string to a function handle
% It calculates the position data with the function handle
% Then it assigns all these properties to a struct object, adds it to the list, and returns the list


% Obtain the defined functions as piecewise function objects
pwfuncobjects = readpwfunctions("functions.txt");


%t = transpose(0:.01:1);
deltat = 0.01; % seconds

numfunctions = numel(pwfuncobjects);
motions = cell(1,numfunctions); % Preallocate the function handles cell array

% Convert each function into a function handle!
for functionnum = 1:numfunctions
    
    % Get object properties
    numargs = pwfuncobjects{functionnum}.getNumArgs;
    args = pwfuncobjects{functionnum}.getArgs;
    bounds = pwfuncobjects{functionnum}.getBounds;
    
    
    % Construct the function in string form
    f = "@(t) ";
    
    for argnum = 1:numargs
        % First part is big, add the argument, and the first bound and part of the second bound
        f = strcat(f, "(" + args(argnum) + ").*((t>=" + num2str(bounds(argnum,1)) + ")&(t<");
        
        if (argnum == numargs)
            f = strcat(f, "="); % Last line so make sure equal to final bound
        end
        
        % Add the second bound and wrap it up
        f = strcat(f, num2str(bounds(argnum,2)) + "))");
        
        if (argnum < numargs)
            f = strcat(f, " + "); % Not the last line so continue the function
        elseif (argnum == numargs)
            f = strcat(f, ";"); % Last line so end the function
        end
    end
    
    
    % Assign the properties to a struct
    tmp.f = str2func(f);
    tmp.ti = bounds(1,1);
    tmp.tf = bounds(numargs,2);
    tmp.dt = deltat;
    tmp.t = tmp.ti:deltat:tmp.tf;
    
    % Add it to the list
    motions{functionnum} = tmp;
end

end