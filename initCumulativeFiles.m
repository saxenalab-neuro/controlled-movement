function [] = initCumulativeFiles()

SS_Results = "Tools\SS_Results\";
cumulative_filenames = ["cumulative_controls.sto", "cumulative_states.sto", "cumulative_motion.mot"];
header_filenames = ["controls_header.txt", "states_header.txt", "motion_header.txt"];
headerlines = [7, 7, 14]; % Headerlines for each header file


% For each of the three files, copy down the second result and append it to the cumulative file
for i = 1:numel(cumulative_filenames)
    infilename = header_filenames(i);
    outfilename = SS_Results + cumulative_filenames(i);
    
    % Read states header file
    infile = fopen(infilename, 'r'); % Open header file for reading
    
    buffer = '';
    for tmp = 1:headerlines(i)
        buffer = strcat(buffer, fgets(infile)); % Copy contents of header file to a buffer
        buffer = strcat(buffer, '\n');
    end
    
    % Write header file to new cumulative file
    outfile = fopen(outfilename, 'w'); % Create or recreate motion file and open for writing
    fprintf(outfile, buffer); % Write header file buffer to output file
    fclose(outfile); % Close outfile for writing
    
end

end