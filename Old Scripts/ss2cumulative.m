function [coordinatevalues] = ss2cumulative()

SS_Results = "Tools\SS_Results\";
results_filenames = ["arm26_controls.sto", "arm26_states.sto", "arm26_states_degrees.mot"];
cumulative_filenames = ["cumulative_controls.sto", "cumulative_states.sto", "cumulative_motion.mot"];
headerlines = [8, 8, 15]; % Headerlines for each header file + 1 since we want to grab the second value

% For each of the three files, copy down the second result and append it to the cumulative file
for i = 1:numel(cumulative_filenames)
    infilename = SS_Results + results_filenames(i);
    outfilename = SS_Results + cumulative_filenames(i);
    
    % Read
    infile = fopen(infilename, 'r'); % Open computed motion states file for reading
    c = textscan(infile, '%s', 1, 'delimiter', '\n', 'headerlines', headerlines(i)); % Store computed motion state into buffer
    values = c{1,1}{1,1};
    
    if i == 3
        tmp = str2double(regexp(values, '\s+', 'split'));
        coordinatevalues = tmp(4);
    end
    
    fclose(infile); % Close infile for reading
    
    % Append
    outfile = fopen(outfilename, 'a'); % Open motion file to append computed motion state
    fprintf(outfile, values); % Append motion state buffer to motion file
    fprintf(outfile, '\n'); % Append a newline character
    fclose(outfile); % Close outfile for appending

end

end