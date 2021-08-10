function [] = runFDTool(run_number)

% IMPORTANT:
% File paths are weird for the tools. The root directory is initialized as
% C:\Users\Jaxton\OneDrive\controlled-movement\System Identification
% as this is the path of the FDTool setup file
% Any further paths must be RELATIVE to this main path at all times





% Setup OpenSim
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry');

% Set File Paths
fdsetup = "System Identification\fd_motiongen_setup.xml";
controlsfilename = "CMC_Results\cmc_"  + num2str(run_number) + "_controls.sto";
statesfilename = "CMC_Results\cmc_"  + num2str(run_number) + "_states.sto";

% Setup the RRA Tool
forwardTool = ForwardTool(fdsetup);
forwardTool.setName("fd_" + num2str(run_number));
forwardTool.setControlsFileName(controlsfilename);
forwardTool.setStatesFileName(statesfilename);
%forwardTool.setInitialTime(motion{run_number}.tstart);
%forwardTool.setFinalTime(motion{run_number}.tend);

% Run the RRA Tool
assert(forwardTool.run());

end