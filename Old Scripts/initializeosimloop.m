% Setup OpenSim
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry'); % Add geometry to remove visualization error
model = Model("arm26.osim"); % Add the model


% Remove previous entries in the opensim.log file
fid = fopen("opensim.log", 'w');
fclose(fid);


% Initialize cumulative files
initCumulativeFiles();


% Initialize the Forward Dynamics Tool
fdSetupFile = "Tools\fd_loop_setup.xml";
forwardTool = ForwardTool(fdSetupFile); % Initialize Forward Tool

load coordinatevalues.mat