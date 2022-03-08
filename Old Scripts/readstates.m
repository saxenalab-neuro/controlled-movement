%function [] = readstates()
clear;clc;
% meta data
headerlines = 7;
delimiter = '\t';
variables = ["version", "nRows", "nColumns", "inDegrees"];


% NEED TO FIGURE OUT HOW TO READ A HEADER %

% Define structure properties
name = "single_step_states";
version = 1;
nRows = 1;
nColumns = 17;
inDegrees = "no";
text = "endheader";
states = [  "time"
            "/jointset/r_shoulder/r_shoulder_elev/value"
            "/jointset/r_shoulder/r_shoulder_elev/speed"
            "/jointset/r_elbow/r_elbow_flex/value"
            "/jointset/r_elbow/r_elbow_flex/speed"
            "/forceset/TRIlong/activation"
            "/forceset/TRIlong/fiber_length"
            "/forceset/TRIlat/activation"
            "/forceset/TRIlat/fiber_length"
            "/forceset/TRImed/activation"
            "/forceset/TRImed/fiber_length"
            "/forceset/BIClong/activation"
            "/forceset/BIClong/fiber_length"
            "/forceset/BICshort/activation"
            "/forceset/BICshort/fiber_length"
            "/forceset/BRA/activation"
            "/forceset/BRA/fiber_length"
         ];


% Assign data and properties to struct
header.name = name;
header.version = version;
header.nRows = nRows;
header.nColumns = nColumns;
header.inDegrees = inDegrees;
header.Text = text;
header.states = states;


% Write out the struct
fn = fieldnames(header); % Num field names should match with headerlines

% Check for errors
[numfieldnames, ~] = size(fn);
if (numfieldnames ~= headerlines)
     fprintf("\nCRIT_ERR: Not writing the correct amount of headerlines!\n");
end

% Write header struct to a buffer to write to a file
buffer = '';
for k=1:numel(fn)
    
    % if a variable, print the variable name, else just print the string value of the property
    if (fn{k} == "states")  % If we have to deal with states, need special logic        
        for i=1:numel(header.states)
            buffer = strcat(buffer, header.states(i)); % Copy in the state variable name
            
            if (i ~= numel(header.states))
                buffer = strcat(buffer, '\t'); % Separate with a tab
            end
        end
    
    % If header property is a varaiable
    elseif (ismember(fn{k}, variables))
        buffer = strcat(buffer, fn{k}); % Copy in the variable name
        buffer = strcat(buffer, '=');
    
    % Else just copy in the text
    else
        buffer = strcat(buffer, string(header.(fn{k}))); % Copy in the text        
    end
    
    buffer = strcat(buffer, '\n'); % Every line needs to be ended in a newline character
end


% Write buffer to outfile
outfile = fopen("test.sto", 'w'); % Open outfile for writing
fprintf(outfile, buffer); % Write header file buffer to output file
fclose(outfile); % Close outfile for writing



%end