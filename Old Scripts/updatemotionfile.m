function [] = updatemotionfile(i)

% Known parameters
headerlines = 15;
variables = 17;

statesfilename = "Tools\SS_Results\arm26_states_degrees.mot";
motionfilename = "motion.mot";

% For first time point, need to capture both the initial and final states
if (i == 1)
    headerlines = 14;
end



% Create the format specifier for reading
formatspecifier = '';
for i = 1:variables
    formatspecifier = strcat(formatspecifier, "%f");
    if (i ~= variables)
        formatspecifier = strcat(formatspecifier, " ");
    end
end


% Read
infile = fopen(statesfilename); % Open the file to read the line from
motion = cell2mat(textscan(infile, formatspecifier, 'headerlines', headerlines)); % Extract data and convert to matrix in one swoop
fclose(infile);


% Write
writematrix(motion, motionfilename, 'FileType', 'text', 'Delimiter', '\t', 'WriteMode', 'append'); % Copy data from matrix into file

end