clear;clc;

% Known parameters, TODO: need a way to dynamically set these
headerlines = 15;
variables = 17;

motionfile = "motion.mot";
statesfile = "Tools/SS_Results/arm26_states_degrees.mot";



% Create the format specifier
formatspecifier = '';
for i = 1:variables
    formatspecifier = strcat(formatspecifier, "%f");
    if (i ~= variables)
        formatspecifier = strcat(formatspecifier, " ");
    end
end


% Read
infile = fopen(statesfile); % Open the file to read the line from
motion = cell2mat(textscan(infile, formatspecifier, 'headerlines', headerlines)); % Extract data and convert to numbers in one swoop
fclose(infile);


% USING FORMAT SPECIFIER

% % Copy cell data into matrix of correct size
% [a, ~] = size(c{1,1});
% tmp = zeros(a, variables);
% for i = 1:variables
%     tmp(:,i) = c{1,i};
% end
% motion = tmp;





% % NOT USING FORMAT SPECIFIER, just '%f'
% motion = transpose(c{:}); % Convert to horizontal matrix
% 
% % Check if I got more than one row of data
% [~, b] = size(motion);
% if (b > variables)
%     num = b/variables;
%     tmp = zeros(num,variables);
%     
%     % Stack chunks of the original row vector
%     for i = 1:num
%         startpos = 1+17*(i-1);
%         endpos = 17*i;
%         tmp(i,:) = motion(1,startpos:endpos);
%     end
%     
%     % Reassign the matrix
%     motion = tmp;
% end


%str2double(regexp(string, '(\d+,)*\d+(\.\d*)?', 'match')); % where [STRING] is the line I copied from the file