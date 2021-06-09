function [] = writesingledatastep(controls)
%% WRITE SINGLE CONTROLS

headerfilename = "conrols_header.txt";
outputfilename = "single_step_controls.sto";

% Read
infile = fopen(headerfilename, 'r'); % Open header file for reading

headerlines = 7;
buffer = '';
for tmp = 1:headerlines
    buffer = strcat(buffer, fgets(infile)); % Copy contents of header file to a buffer
    buffer = strcat(buffer, '\n');
end

fclose(infile); % Close infile for reading


% Write
outfile = fopen(outputfilename, 'w'); % Open outfile for writing

fprintf(outfile, buffer); % Write header file buffer to output file
writematrix(controls, outputfilename, 'FileType', 'text', 'Delimiter', '\t', 'WriteMode', 'append'); % Copy data from matrix into file

fclose(outfile); % Close outfile for writing



%% WRITE SINGLE STATES

headerfilename = "states_header.txt";
outputfilename = "single_step_states.sto";

% Read
infile = fopen(headerfilename, 'r'); % Open header file for reading

headerlines = 7;
buffer = '';
for tmp = 1:headerlines
    buffer = strcat(buffer, fgets(infile)); % Copy contents of header file to a buffer
    buffer = strcat(buffer, '\n');
end

fclose(infile); % Close infile for reading


% Write
outfile = fopen(outputfilename, 'w'); % Open outfile for writing

fprintf(outfile, buffer); % Write header file buffer to output file
writematrix(controls, outputfilename, 'FileType', 'text', 'Delimiter', '\t', 'WriteMode', 'append'); % Copy data from matrix into file

fclose(outfile); % Close outfile for writing

end