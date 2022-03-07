clear;clc

% HEADER READER AND MANIPULATOR TEST

nRows = 81;

headerfilename = "../Tools/SS_Results/single_step_controls.sto";  % "test.sto"

headerlines = [7, 7, 14];


% --- CUMULATIVE FILES --- %

% % Read existing cumulative file
% infile = fopen(cumulativefilename, 'r'); % Open header file for reading
% C = textscan(infile,'%s','delimiter','\n');
% C = C{1};
% fclose(infile); % Close infile for reading
% 
% 
% % Read new output file


infile = fopen(headerfilename, 'r'); % Open header file for reading
filelines = textscan(infile,'%s','delimiter','\n');
filelines = filelines{1};
fclose(infile); % Close infile for reading


% Update header row numbers and ranges
filelines{3} = regexprep(string(filelines{3}), '\d+', num2str(nRows));
ismotionheader = false;
if (ismotionheader == true)
    filelines{10} = regexprep(string(filelines{10}), '\d+', num2str(nRows));
    filelines{12} = regexprep(string(filelines{12}), '(\d+,)*\d+(\.\d*)?', num2str(ti), 1);
    filelines{12} = regexprep(string(filelines{12}), '(\d+,)*\d+(\.\d*)?', num2str(tf), 2);
end





% 
% % --- WRITE BATCH SINGLE STEP FILES --- %
% 
% % Read file
% infile = fopen(headerfilename, 'r'); % Open header file for reading
% C = textscan(infile,'%s','delimiter','\n');
% C = C{1};
% fclose(infile); % Close infile for reading
% 
% 
% % Add data to cell
% 
% 
% C{3} = regexprep(string(C{3}), '\d+', num2str(nRows));
% 
% if (ismotionheader == true)
%     C{10} = regexprep(string(C{10}), '\d+', num2str(nRows));
%     C{12} = regexprep(string(C{12}), '(\d+,)*\d+(\.\d*)?', num2str(ti), 1);
%     C{12} = regexprep(string(C{12}), '(\d+,)*\d+(\.\d*)?', num2str(tf), 2);
% end













% outfilename = "test.sto";
% 
% % Write
% outfile = fopen(outfilename, 'w'); % Open outfile for writing
% 
% 
% % fprintf(outfile, buffer); % Write header file buffer to output file
% % writematrix(controls, outfilename, 'FileType', 'text', 'Delimiter', '\t', 'WriteMode', 'append'); % Copy data from matrix into file
% 
% variables = ["1", "nRows", "nColumns", "inDegrees"];
% 
% %if (outfilename == "states_header.txt")
% 
% name = "bob's you'r uncle";
% nRows = 15;
% 
% fprintf(outfile, name + "\n");
% fprintf(outfile, "version=1\n");
% fprintf(outfile, "nRows=" + num2str(nRows) + "\n");
% fprintf(outfile, "nColumns=17\n");
% fprintf(outfile, "inDegrees=no\n");
% fprintf(outfile, "endheader\n");
% fprintf(outfile, "time	/jointset/r_shoulder/r_shoulder_elev/value	/jointset/r_shoulder/r_shoulder_elev/speed	/jointset/r_elbow/r_elbow_flex/value	/jointset/r_elbow/r_elbow_flex/speed	/forceset/TRIlong/activation	/forceset/TRIlong/fiber_length	/forceset/TRIlat/activation	/forceset/TRIlat/fiber_length	/forceset/TRImed/activation	/forceset/TRImed/fiber_length	/forceset/BIClong/activation	/forceset/BIClong/fiber_length	/forceset/BICshort/activation	/forceset/BICshort/fiber_length	/forceset/BRA/activation	/forceset/BRA/fiber_length\n");
% 
% 
% 
% fclose(outfile); % Close outfile for writing

