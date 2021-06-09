clear;clc;

% step test

import org.opensim.modeling.* % Import OpenSim Libraries
geometrypath = 'C:\OpenSim 4.2\Geometry';
ModelVisualizer.addDirToGeometrySearchPaths(geometrypath);
model = Model("arm26.osim");

% FORWARD DYNAMICS TOOL PATHS %
forwardDynamicsFolder = "ForwardDynamics\";
forwardDynamicsSetup = forwardDynamicsFolder+"forwardDynamics_setup.xml";
forwardDynamicsResultsFolder = forwardDynamicsFolder+"Results\";

% FORWARD DYNAMICS TOOL %
forwardTool = ForwardTool(forwardDynamicsSetup); % Initialize Forward Tool


manager = man

readSingleControl();
writeSingleControl();

