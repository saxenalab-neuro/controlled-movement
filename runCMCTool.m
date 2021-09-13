function [run_successfully] = runCMCTool(run_number, ti, tf)

% IMPORTANT:
% File paths are weird for the tools. The root directory is initialized as
% C:\Users\Jaxton\OneDrive\controlled-movement\System Identification
% as this is the path of the CMCTool setup file
% Any further paths must be RELATIVE to this main path at all times


% Setup OpenSim
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry');
%model = Model("arm26.osim"); % Add the model


% Set File Paths
motionfilename = "Motion Files\script_" + num2str(run_number) + ".mot";
cmcsetup = "System Identification\cmc_motiongen_setup.xml";


% Setup the CMC Tool
cmcTool = CMCTool(cmcsetup);
%cmcTool.setModel(model);
cmcTool.setName("cmc_" + num2str(run_number));
cmcTool.setDesiredKinematicsFileName(motionfilename);
cmcTool.setInitialTime(ti);
cmcTool.setFinalTime(tf);


% Run the CMC Tool
run_successfully = cmcTool.run();


% Error Reporting
if (run_successfully == 0)
    fprintf("CRIT_ERR: CMC Tool failed to run on script %d\n", run_number); 
end

end

