function writeheader(headerfilename, outfilename)

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
outfile = fopen(outfilename, 'w'); % Open outfile for writing

fprintf(outfile, buffer); % Write header file buffer to output file

fclose(outfile);

end