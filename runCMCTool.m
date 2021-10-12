function [run_successfully] = runCMCTool(run_number, datatype, ti, tf)

% IMPORTANT:
% File paths are weird for the tools. The root directory is initialized as
% C:\Users\Jaxton\OneDrive\controlled-movement\System Identification
% as this is the path of the CMCTool setup file
% Any further paths must be RELATIVE, NOT EXACT, to this main path at all times


% Setup OpenSim
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry');


% Set File Paths
cmcsetup = "C:\Users\Jaxton\controlled-movement\System Identification\cmc_HPG_setup.xml";
motionfilename = datatype + "\Motion Files\" + lower(datatype) + "_" + num2str(run_number) + ".mot";
resultsdir = datatype + "\CMC_Results";


% Setup the CMC Tool
cmcTool = CMCTool(cmcsetup);
cmcTool.setName(lower(datatype) + "_" + num2str(run_number));
cmcTool.setDesiredKinematicsFileName(motionfilename);
cmcTool.setResultsDir(resultsdir);
cmcTool.setInitialTime(ti);
cmcTool.setFinalTime(tf);


% Run the CMC Tool
run_successfully = cmcTool.run();


% Error Reporting
if (run_successfully == 0)
    fprintf("CRIT_ERR: CMC Tool failed to run on script %d\n", run_number); 
end

end

