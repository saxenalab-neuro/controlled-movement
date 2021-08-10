function SIdatagen()


% Setup OpenSim
% import org.opensim.modeling.* % Import OpenSim Libraries
% ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry');
% 
% Remove previous entries in the opensim.log file
fid = fopen("opensim.log", 'w');
fclose(fid);


% Motion Writer

% motionheaderwriter(outfilename, rows, columns, tstart, tend, variables)


% Come up with an array of crazy motion value for only bicep curl
% Vary all variables at some point. theta and theta dot. A lot of files with no radial acceleration, and some files with some radial acceleration


% Once I generate my motion file values, figure out the time range, and the number of rows and columns
% Then write the motion file header and the motion file values


% Constant change in position equates to a linear, first order function, so function could bu an input to get the full range of motion I want
% A second order function should give me the acceleartion I want

% Variables to change
%timestart
%timeend
%stepsize
%positionstart
%positionfunction

% motion = [tstart, tend, stepsize, posstart, posfunc]; but in struct formation


% Generate all the desired motions
motions = motionpropertiesgenerator();


for i = 1:numel(motions)

% Calculate Motion Data
motions{i}.data = motiongenerator(motions{i});


% Motion Filename
motionfilename = "System Identification\Motion Files\script_" + num2str(i) + ".mot";


% Write Motion File
motionheaderwriter(motionfilename, motions{i});


% Run RRA Tool
%runRRATool(i);


% Run CMC Tool
runCMCTool(i);

% Run Forward Tool
runFDTool(i);

end



% for i = 1:numel(motions)
% % Run CMC Tool
% runCMCTool(i);
% end
% 
% 
% for i = 1:numel(motions)
% % Run Forward Tool
% runFDTool(i);
% end

end
