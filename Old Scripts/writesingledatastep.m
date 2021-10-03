function writesingledatastep(controls)
%% WRITE SINGLE CONTROLS

headerfilename = "controls_header.txt";
outputfilename = "single_step_controls.sto";


% Read Header
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
inputfilename = "Tools\SS_Results\arm26_states.sto";


% Read Header
infile = fopen(headerfilename, 'r'); % Open header file for reading

headerlines = 7;
buffer = '';
for tmp = 1:headerlines
    buffer = strcat(buffer, fgets(infile)); % Copy contents of header file to a buffer
    buffer = strcat(buffer, '\n');
end

fclose(infile); % Close infile for reading


% Read Last State
infile = fopen(inputfilename, 'r'); % Open computed states file for reading
headerlines = 8;
c = textscan(infile, '%s', 1, 'delimiter', '\n', 'headerlines', headerlines);
laststate = c{1,1}{1,1};
fclose(infile); % Close infile for reading


% Write
outfile = fopen(outputfilename, 'w'); % Open outfile for writing
fprintf(outfile, buffer); % Write header file buffer to output file
fprintf(outfile, laststate); % Write last state bufffer to output file
fclose(outfile); % Close outfile for writing
end