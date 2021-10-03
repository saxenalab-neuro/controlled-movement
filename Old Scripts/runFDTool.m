function [run_successfully] = runFDTool(run_number, ti, tf)

% IMPORTANT:
% File paths are weird for the tools. The root directory is initialized as
% C:\Users\Jaxton\OneDrive\controlled-movement\System Identification
% as this is the path of the FDTool setup file
% Any further paths must be RELATIVE to this main path at all times


% Setup OpenSim
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry');
model = Model("arm26.osim"); % Add the model


% Set File Paths
fdsetup = "System Identification\fd_motiongen_setup.xml";
controlsfilename = "CMC_Results\cmc_"  + num2str(run_number) + "_controls.sto";
statesfilename = "CMC_Results\cmc_"  + num2str(run_number) + "_states.sto";


% Setup the FD Tool
forwardTool = ForwardTool(fdsetup);
forwardTool.setModel(model);
forwardTool.setName("fd_" + num2str(run_number));
forwardTool.setControlsFileName(controlsfilename);
forwardTool.setStatesFileName(statesfilename);
forwardTool.setInitialTime(ti + 0.03); % CMC wastes the first 0.03 seconds
forwardTool.setFinalTime(tf);


% Run the FD Tool
run_successfully = forwardTool.run();


% Error Reporting
if (run_successfully == 0)
    fprintf("CRIT_ERR: FD Tool failed to run on script %d", run_number); 
end

end