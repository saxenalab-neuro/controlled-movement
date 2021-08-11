function [pwfunctions] = readpwfunctions(functionsfilename)



fid = fopen(functionsfilename); % Open function definitions file

readingfunctions = false;
readingfunction = false;
numfunctions = 0;

pwfunctions = cell(1, 100);
func = pwfunc();


% Possible BUG: if "START" occurs on the very first line of the file, then undesireable behavior will occur

tline = fgetl(fid);
linenum = 1; % Keep track of the line number

while ischar(tline)
    tline = fgetl(fid);
    linenum = linenum + 1; %
    
    if (isa(tline, 'double'))
        error("TLINE IS A DOUBLE ON LINE %d\n%s", linenum, tline);
    end
    
    if (tline == "")
        continue % Skip newline whitespace
    end
    
    % Check for "START" to start reading functions
    if (readingfunctions == false && tline == "START")
        readingfunctions = true;
        continue % Go to next line of file
    end
    
    % Check for "END" to finish reading functions
    if (tline == "END")
        % Add last function to the list and break the while loop
        pwfunctions{numfunctions+1} = func; % Assign function to list        
        break
    end
    
    
    if (readingfunctions)
        % Check for "%%%" to start a new function definition
        if (tline == "%%%")
            % After the first function, the start of a new function indicates we need to add the last one to the list
            if (numfunctions > 0)
                pwfunctions{numfunctions+1} = func; % Assign function to list
            end
            
            % Begin new function
            readingfunction = true;
            func = pwfunc(); % Refresh piecewise function object
            numfunctions = numfunctions + 1; % Increase the number of functions
            continue % Go to next line of file
        end
        
        
        % If reading a function, get it's components and check for errors
        if (readingfunction)
            components = split(tline, " | "); % Split line into components
            
            % Separate components into named variables
            arg = components{1};
            lowerbound = str2double(components{2});
            upperbound = str2double(components{3});

            
            % Check for errors, and give helpful messages

            % Throw error if argument line is incorrect
            if (numel(components) ~= 3)
                error("CRIT_ERR: Read an incorrect argument line on line %d\n%s", linenum, tline);
            end

            % Throw error if no components
            if (components(1) == "")
                error("CRIT_ERR: No argument input on line %d\n%s", linenum, tline);
            elseif (components(2) == "")
                error("CRIT_ERR: No lower bound input on line %d\n%s", linenum, tline);
            elseif (components(3) == "")
                error("CRIT_ERR: No upper bound input on line %d\n%s", linenum, tline);
            end

            % Throw error if the lower bound is larger than the upper bound
            if (str2double(components(2)) > str2double(components(3)))
                error("CRIT_ERR: Lower bound is larger than upper bound input on line %d\n%s", linenum, tline);
            end
            
            
            % Add the argument and bounds to the piecewise function object
            func = func.AddArg(arg, lowerbound, upperbound);
        end
    end
end

fclose(fid); % Close function definitions file

pwfunctions = pwfunctions(~cellfun('isempty', pwfunctions)); % Cleanse cell array of empty elements

end