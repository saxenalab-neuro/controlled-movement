function [initstates] = initial_states_reader(dk, ti, Ts, varargin)

toolspathname = "../Tools/";

% Parse inputs
if nargin == 2
    if (strcmp(varargin{1},'ToolsPath'))
        toolspathname = varargin{2};
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

doIplot = false;

if doIplot == true
    figure('Name','Initial States')

    for i=2:numel(c)
        plot(c{1}, c{i})
        hold on
    end

    legend('shoulder_pos', 'shoulder_vel', 'elbow_pos', 'elbow_vel', 'TRIlong_a', 'TRIlong_l', 'TRIlat_a', 'TRIlat_l', 'TRImed_a', 'TRImed_l', 'BIClong_a', 'BIClong_l', 'BICshort_a', 'BICshort_l', 'BRA_a', 'BRA_l')
end

%0.59 to 0.72 appears to be a good range
% At 0.6 looks best and flat
% 0.60000000	      0.00000170	      0.00002296	      0.52359442	     -0.00005972	      0.03421023	      0.14811506	      0.12364336	      0.08149262	      0.12007534	      0.07658686	      0.15312493	      0.13825929	      0.11153019	      0.13728010	      0.06220714	      0.08596361


indlow = find(min(abs(c{1} - 0.59)) == abs(c{1} - 0.59));
indhigh = find(min(abs(c{1} - 0.72)) == abs(c{1} - 0.72));
totalgood = indhigh - indlow + 1;

goodvals = zeros(totalgood, 17);
tmp_tf = ti + (totalgood-1)*Ts;
goodvals(:,1) = ti:Ts:tmp_tf; % Reset time of goodvals to follow sampling time Ts

for i=2:numel(c)
    goodvals(:,i) = c{i}(indlow:indhigh);
end

initstates = transpose(goodvals(1:dk, [4 5]));




% --- WRITE STATES TO CUMULATIVE STATES FILE --- %

outfilename = toolspathname + "SS_Results/cumulative_states.sto";
% 
% % Append
% outfile = fopen(outfilename, 'a'); % Open motion file to append computed motion state
% 
% % Write data
% if numstates > totalgood
%     error("CRIT_ERR: NOT ENOUGH GOOD STATES, MAKE SOMETHING TO DUPLICATE THEM")
% end
% 
% for i=1:numstates
%     fprintf(outfile, strcat(formatspec, ' \n'), goodvals(i,:)); % Write last state bufffer to output file
% end
% 
% fclose(outfile); % Close outfile for appending


% Read existing cumulative file
infile = fopen(outfilename, 'r'); % Open header file for reading
cumulativelines = textscan(infile, '%s', 'delimiter', '\n');
cumulativelines = cumulativelines{1};
fclose(infile); % Close infile for reading


goodvallines = cell(totalgood,1);
for i=1:totalgood
    charbuffer = '';
    
    % Add all of goodvals row to character buffer to store into cell array for file writing
    for j=1:size(goodvals,2)-1
        charbuffer = strcat(charbuffer, num2str(goodvals(i,j)));
        
        if (j == size(goodvals,2))
            charbuffer = strcat(charbuffer, '\n');
            continue
        end
        
        charbuffer = strcat(charbuffer, '\t');
    end
    
    goodvallines{i} = charbuffer;
end


% Concatenate the two files
filelines = vertcat(cumulativelines, goodvallines); % Add the data rows from results lines to the cumulative file


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