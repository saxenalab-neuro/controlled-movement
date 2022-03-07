function [coordinatevalues] = ss2cumulative(varargin)

toolspathname = "../Tools/";

% Parse inputs
if nargin == 2
    if (strcmp(varargin{1},'ToolsPath'))
        toolspathname = varargin{2};
    end
end



SSResultspathname = toolspathname + "SS_Results/";

results_filenames = [SSResultspathname + "arm26_controls.sto", SSResultspathname + "arm26_states.sto", SSResultspathname + "arm26_states_degrees.mot"];
cumulative_filenames = [SSResultspathname + "cumulative_controls.sto", SSResultspathname + "cumulative_states.sto", SSResultspathname + "cumulative_motion.mot"];
headerlines = [7, 7, 14]; % Headerlines for each header file + 1 since we want to grab the second value



% For each of the three files, copy down the second result and append it to the cumulative file
for i = 1:numel(cumulative_filenames)
    
    % Read existing cumulative file
    infile = fopen(cumulative_filenames(i), 'r'); % Open header file for reading
    cumulativelines = textscan(infile,'%s', 'delimiter','\n');
    cumulativelines = cumulativelines{1};
    fclose(infile); % Close infile for reading
    
    
    % Read results file and add to filelines
    infile = fopen(results_filenames(i), 'r'); % Open header file for reading
    resultslines = textscan(infile,'%s', 'delimiter','\n');
    resultslines = resultslines{1};
    fclose(infile); % Close infile for reading
    
    
    % Concatenate the two files
    if (numel(resultslines) > headerlines(i))
        filelines = vertcat(cumulativelines, resultslines(headerlines(i)+1:end)); % Add the data rows from results lines to the cumulative file
    end
    
    
    % Update header row numbers and ranges
    nRows = numel(filelines) - headerlines(i);
    filelines{3} = regexprep(string(filelines{3}), '\d+', num2str(nRows)); % Replace the row count
    
    
    % Motion file has extra properties in the header to change
    if (i == 3)
        filelines{10} = regexprep(string(filelines{10}), '\d+', num2str(nRows)); % Replace the row count
        ti = regexp(filelines{headerlines(i)+1}, '(\d+,)*\d+(\.\d*)?', 'match', 'once'); % Find the initial time
        tf = regexp(filelines{end}, '(\d+,)*\d+(\.\d*)?', 'match', 'once'); % Find the final time
        filelines{12} = regexprep(string(filelines{12}), '(\d+,)*\d+(\.\d*)?', ti, 1); % Replace the initial time
        filelines{12} = regexprep(string(filelines{12}), '(\d+,)*\d+(\.\d*)?', tf, 2); % Replace the final time
    end
    
    
    % Overwrite cumulative file with new file
    outfile = fopen(cumulative_filenames(i), 'w'); % Create or recreate motion file and open for writing
    for j=1:numel(filelines)
        fprintf(outfile, filelines{j} + "\n"); % Write each line back to cumulative file
    end
    fclose(outfile); % Close outfile for writing
    
    
    % Get states output as main function return
    if (i == 2)
        dk = numel(resultslines)-headerlines(i);
        coordinatevalues = zeros(2,dk);
        for j=1:dk
            tmpvals = regexp(resultslines{headerlines(i)+j},'(\d+,)*\d+(\.\d*)?','match');
            coordinatevalues(1,j) = str2double(tmpvals{4});
            coordinatevalues(2,j) = str2double(tmpvals{5});
        end
    end
    
    
    
%     % Read
%     infile = fopen(infilename, 'r'); % Open computed motion states file for reading
%     c = textscan(infile, '%s', 1, 'delimiter', '\n', 'headerlines', headerlines(i)); % Store computed motion state into buffer
%     values = c{1,1}{1,1};
%     
%     if i == 3
%         tmp = str2double(regexp(values, '\s+', 'split'));
%         coordinatevalues = tmp(4);
%     end
%     
%     fclose(infile); % Close infile for reading
%     
%     % Append
%     outfile = fopen(outfilename, 'a'); % Open motion file to append computed motion state
%     fprintf(outfile, values); % Append motion state buffer to motion file
%     fprintf(outfile, '\n'); % Append a newline character
%     fclose(outfile); % Close outfile for appending

end

end