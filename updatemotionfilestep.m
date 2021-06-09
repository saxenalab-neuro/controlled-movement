function [] = updatemotionfilestep()

headerlines = 15;
statesfilename = "Tools/SS_Results/arm26_states_degrees.mot";
motionfilename = "motion.mot";


% Open files
infile = fopen(statesfilename); % Open the file to read the line from
outfile = fopen(motionfilename);

% Read + Write
fprintf(outfile, textscan(infile, '%s', 1, 'delimiter', '\n', 'headerlines', headerlines));

% Close files
fclose(infile);
fclose(outfile);

end