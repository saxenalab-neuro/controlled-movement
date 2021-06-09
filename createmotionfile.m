function [] = createmotionfile()

header_filename = "motion_header.txt";
output_filename = "motion.mot";


% Read motion header file
infile = fopen(header_filename, 'r'); % Open header file for reading

headerlines = 14;
buffer = '';
for tmp = 1:headerlines
    buffer = strcat(buffer, fgets(infile)); % Copy contents of header file to a buffer
    buffer = strcat(buffer, '\n');
end

fclose(infile); % Close infile for reading


% Write motion header file to motion file
outfile = fopen(output_filename, 'w'); % Open outfile for writing

fprintf(outfile, buffer); % Write header file buffer to output file

fclose(outfile); % Close outfile for writing

end