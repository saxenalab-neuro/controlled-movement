function [] = createmotionfilestep(motionfilename, initial_state)

statesheaderfilename = "states_header.txt";
outputstatesfilename = "Tools/SS_Results/arm26_states.sto";
motionheaderfilename = "motion_header.txt";

%% WRITE FIRST STATE

% Read states header file
infile = fopen(statesheaderfilename, 'r'); % Open header file for reading

headerlines = 7;
buffer = '';
for tmp = 1:headerlines
    buffer = strcat(buffer, fgets(infile)); % Copy contents of header file to a buffer
    buffer = strcat(buffer, '\n');
end

fclose(infile); % Close infile for reading


% Write first state
outfile = fopen(outputstatesfilename, 'w'); % Open outfile for writing
fprintf(outfile, buffer); % Write header file buffer to output file
fprintf(outfile, '\n'); % Write an extra newline
writematrix(initial_state, outputstatesfilename, 'FileType', 'text', 'Delimiter', '\t', 'WriteMode', 'append'); % Copy data from matrix into file
fclose(outfile); % Close outfile for writing



%% WRITE MOTION FILE

% Convert initial_state into degrees now and write it into the motion file
initial_state(1,2:5) = initial_state(1,2:5).*(180/pi);

% Read motion header file
infile = fopen(motionheaderfilename, 'r'); % Open header file for reading

headerlines = 14;
buffer = '';
for tmp = 1:headerlines
    buffer = strcat(buffer, fgets(infile)); % Copy contents of header file to a buffer
    buffer = strcat(buffer, '\n');
end

fclose(infile); % Close infile for reading


% Write motion header and first state to motion file
outfile = fopen(motionfilename, 'w'); % Create or recreate motion file and open for writing
fprintf(outfile, buffer); % Write header file buffer to output file
writematrix(initial_state, motionfilename, 'FileType', 'text', 'Delimiter', '\t', 'WriteMode', 'append'); % Copy data from matrix into file
fclose(outfile); % Close outfile for writing

end