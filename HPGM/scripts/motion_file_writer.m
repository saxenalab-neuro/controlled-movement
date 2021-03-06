function motion_file_writer(outfilename, motion)

% TODO: WRITE ABOUT FUNCTION


% Hard code the header data of the motion file
motion_header = [ "bicep_curl"
    "\nversion=1"
    "\nnRows="
    "\nnColumns="
    "\ninDegrees=yes"
    "\n"
    "\n# SIMM Motion File Header:"
    "\nname bicep_curl"
    "\ndatacolumns "
    "\ndatarows "
    "\notherdata 1"
    "\nrange "
    "\nendheader\n"
    ];

% Hard code the variables of the motion file
variables = ["time", "/jointset/r_shoulder/r_shoulder_elev/value", "/jointset/r_elbow/r_elbow_flex/value"];

[rows, columns] = size(motion.data);


% Messy but modular way to create the header and change the variables while doing so
buffer = '';
buffer = strcat(buffer, motion_header(1) + motion_header(2) + motion_header(3) + num2str(rows) + motion_header(4) + num2str(columns));
buffer = strcat(buffer, motion_header(5) + motion_header(6) + motion_header(7) + motion_header(8) + motion_header(9) + num2str(columns));
buffer = strcat(buffer, motion_header(10) + num2str(rows) + motion_header(11) + motion_header(12) + num2str(motion.ti, '%.4f') + " " + num2str(motion.tf, '%.4f') + motion_header(13));


% Gather variables line
for i = 1:numel(variables)
    buffer = strcat(buffer, variables(i));
    
    if (i ~= numel(variables)) % Don't put tab at end, just in between every word
        buffer = strcat(buffer, '\t');
    end
end

% Copy variables line to buffer
buffer = strcat(buffer, '\n');


% Create matrix of data from motion
matrixbuffer = '';
for i = 1:rows
    for j = 1:columns
        matrixbuffer = strcat(matrixbuffer, num2str(motion.data(i,j), '%.4f'));
        
        if (j ~= columns) % Don't put tab at end, just in between every word
            matrixbuffer = strcat(matrixbuffer, '\t');
        end
    end
    
    matrixbuffer = strcat(matrixbuffer, '\n');
end


% Write header file to new cumulative file
outfile = fopen(outfilename, 'w'); % Create or recreate motion file and open for writing
fprintf(outfile, buffer); % Write header file buffer to output file
fprintf(outfile, matrixbuffer); % Write matrix to output file
fclose(outfile); % Close outfile for writing

end