function writecontrols(controls, varargin)

toolspathname = "../Tools/";

% Parse inputs
if nargin == 2
    if (strcmp(varargin{1},'ToolsPath'))
        toolspathname = varargin{2};
    end
end


headerfilename = toolspathname + "controls_header.txt";
outputfilename = toolspathname + "SS_results/single_step_controls.sto";


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


end