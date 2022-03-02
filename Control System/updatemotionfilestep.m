function [] = updatemotionfilestep(motionfilename, varargin)

toolspathname = "../Tools/";

% Parse inputs
if nargin == 2
    if (strcmp(varargin{1},'ToolsPath'))
        toolspathname = varargin{2};
    end
end


headerlines = 15;
statesfilename = toolspathname + "SS_Results/arm26_states_degrees.mot";


% Read
infile = fopen(statesfilename, 'r'); % Open computed motion states file for reading
c = textscan(infile, '%s', 1, 'delimiter', '\n', 'headerlines', headerlines); % Store computed motion state into buffer
motion = c{1,1}{1,1};
fclose(infile); % Close infile for reading


% Append
outfile = fopen(motionfilename, 'a'); % Open motion file to append computed motion state
fprintf(outfile, motion); % Append motion state buffer to motion file
fprintf(outfile, '\n'); % Append a newline character
fclose(outfile); % Close outfile for appending

end