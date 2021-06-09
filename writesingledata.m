function [] = writesingledata(type, data, index)

% type = "states";
% statesfile = "Tools/CMC_Results/cmc_output_states.sto"; % Assign the file name
% states = importdata(statesfile,' ', 7).data; % Import the data from the file
% data = states;
% index = 1;

% Assign filenames based on the data type
header_filename = type + "_header.txt";
output_filename = "single_step_" + type + ".sto";

% Obtain single data
single_data = data(index,:);


% Read
infile = fopen(header_filename, 'r'); % Open header file for reading

headerlines = 7;
buffer = '';
for tmp = 1:headerlines
    buffer = strcat(buffer, fgets(infile)); % Copy contents of header file to a buffer
    buffer = strcat(buffer, '\n');
end

fclose(infile); % Close infile for reading


% Write
outfile = fopen(output_filename, 'w'); % Open outfile for writing

fprintf(outfile, buffer); % Write header file buffer to output file
writematrix(single_data, output_filename, 'FileType', 'text', 'Delimiter', '\t', 'WriteMode', 'append'); % Copy data from matrix into file

fclose(outfile); % Close outfile for writing

end