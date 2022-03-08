function [initstates] = initial_states_reader(dk, ti, Ts, varargin)


% Default variables
toolspathname = "../Tools/";
doIplot = false;


% Parse variable inputs
if numel(varargin) > 0
    for i=1:nargin
        % Tools Path
        if (strcmp(varargin{i},'ToolsPath'))
            toolspathname = varargin{i+1};
        end
        
        % Add another input here
    end
end



% --- Read States --- %
infilename = toolspathname + "Results/cmc_output_states.sto";

% Read Last State
infile = fopen(infilename, 'r'); % Open computed states file for reading
headerlines = 7;
formatspec = '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
c = textscan(infile, formatspec, 5273, 'delimiter', '\n', 'headerlines', headerlines+1);
fclose(infile); % Close infile for reading



% --- Process States --- %

% Plot raw output, what looks good?
if doIplot == true
    figure('Name','Initial States')
    
    for i=2:numel(c)
        plot(c{1}, c{i})
        hold on
    end

    legend('shoulder_pos', 'shoulder_vel', 'elbow_pos', 'elbow_vel', 'TRIlong_a', 'TRIlong_l', 'TRIlat_a', 'TRIlat_l', 'TRImed_a', 'TRImed_l', 'BIClong_a', 'BIClong_l', 'BICshort_a', 'BICshort_l', 'BRA_a', 'BRA_l')
end


% Identify the good range visually and write it into code
% 0.59 to 0.72 appears to be a good range
% At 0.6 looks best and flat
% 0.60000000	      0.00000170	      0.00002296	      0.52359442	     -0.00005972	      0.03421023	      0.14811506	      0.12364336	      0.08149262	      0.12007534	      0.07658686	      0.15312493	      0.13825929	      0.11153019	      0.13728010	      0.06220714	      0.08596361


% Get good data range and put it into a matrix
indlow = find(min(abs(c{1} - 0.59)) == abs(c{1} - 0.59)); % Index where good data range begins
indhigh = find(min(abs(c{1} - 0.72)) == abs(c{1} - 0.72)); % Index where good data range ends
totalgood = indhigh - indlow + 1; % How many good points there are

goodvals = zeros(totalgood, 17); % Initialize matrix

for i=2:numel(c)
    goodvals(:,i) = c{i}(indlow:indhigh); % Convert raw data into a matrix
end


tf = ti + (size(goodvals,1)-1)*Ts;
goodvals(:,1) = ti:Ts:tf; % Reset time of goodvals to follow sampling time Ts

initstates = transpose(goodvals(1:dk, [4 5]));

% Duplicate goodvals to get more vals
goodvals = vertcat(goodvals, flip(goodvals));


% Set time of states to what I want
tf = ti + (size(goodvals,1)-1)*Ts;
goodvals(:,1) = ti:Ts:tf; % Reset time of goodvals to follow sampling time Ts


% Plot good data, does it look flat?
if doIplot == true
    figure('Name','Initial States')
    
    for i=2:numel(c)
        plot(goodvals(:,1), goodvals(:,i))
        hold on
    end
    
    legend('shoulder_pos', 'shoulder_vel', 'elbow_pos', 'elbow_vel', 'TRIlong_a', 'TRIlong_l', 'TRIlat_a', 'TRIlat_l', 'TRImed_a', 'TRImed_l', 'BIClong_a', 'BIClong_l', 'BICshort_a', 'BICshort_l', 'BRA_a', 'BRA_l')
end

% Good data looks really flat so that's great!!! Let's continue.

% Okay so now I have a bunch of initial states I can write to a file. I need to write from 0 to ti so that my ForwardTool can take off from there.


% --- WRITE STATES TO CUMULATIVE STATES FILE --- %

outfilename = toolspathname + "SS_Results/cumulative_states.sto";


% Read existing cumulative file
infile = fopen(outfilename, 'r'); % Open header file for reading
cumulativelines = textscan(infile, '%s', 'delimiter', '\n');
cumulativelines = cumulativelines{1};
fclose(infile); % Close infile for reading


goodvallines = cell(size(goodvals,1),1);
for i=1:size(goodvals,1)
    charbuffer = '';
    
    % Add all of goodvals row to character buffer to store into cell array for file writing
    for j=1:size(goodvals,2)
        charbuffer = strcat(charbuffer, num2str(goodvals(i,j), '%9.8f'), {'\t      '});
    end
    
    goodvallines{i} = charbuffer;
end


% Concatenate the batch of initial values with the fresh header file
filelines = vertcat(cumulativelines, goodvallines(1:dk+1)); % Add the data rows from results lines to the cumulative file


% Update header row numbers and ranges
nRows = numel(filelines) - headerlines;
filelines{3} = regexprep(string(filelines{3}), '\d+', num2str(nRows)); % Replace the row count


% Overwrite cumulative file with new file
outfile = fopen(outfilename, 'w'); % Create or recreate motion file and open for writing
for j=1:numel(filelines)
    fprintf(outfile, filelines{j} + "\n"); % Write each line back to cumulative file
end
fclose(outfile); % Close outfile for writing


end