function [] = OpenSimFunction()
% OpenSim Run OpenSim as a function
% Run OpenSim as a function

import org.opensim.modeling.* % Import OpenSim Libraries
geometrypath = 'C:\OpenSim 4.2\Geometry';
ModelVisualizer.addDirToGeometrySearchPaths(geometrypath);

% MODEL %
model = Model("arm26.osim"); % Initialize the model
model.initSystem();


% CMC TOOL PATHS %
cmcFolder = "ComputedMuscleControl\";
cmcToolSetup = cmcFolder+"cmc_setup.xml";
cmcResultsFolder = cmcFolder+"Results\";
desiredKinematicsFileName = cmcFolder+"kinematics.mot";
constraintsFileName = cmcFolder+"control_constraints.xml";
taskSetFileName = cmcFolder+"cmc_tasks.xml";
%externalLoadsFileName = cmcFolder+"external_loads";






% EXTERNAL LOADS%
% Create external loads object from external loads xml file
%externalLoads = ExternalLoads(externalLoadsFileName, false);


% CMC TOOL SETUP %
manipulatekinematics();


% CMC TOOL %
fprintf("THIS MARKS THE BEGINNING OF THE CMC TOOL!\n");
cmcTool = CMCTool(cmcToolSetup); % Initialize CMC Tool with cmc_setup.xml file

% AbstractTool methods %
% cmcTool.setModel(model);
% %cmcTool.setExternalLoads(externalLoads);
% cmcTool.setResultsDir(cmcResultsFolder);
% 
% % CMCTool methods %
% cmcTool.setDesiredKinematicsFileName(desiredKinematicsFileName);
% cmcTool.setConstraintsFileName(constraintsFileName);
% cmcTool.setTaskSetFileName(taskSetFileName);
% %cmcTool.setExternalLoadsFileName(externalLoadsFileName);
% %cmcTool.setTimeWindow()
if (cmcTool.run())
    fprintf("\n\nHooray cmcTool ran!\n\n");
else
    fprintf("\n\nCRIT_ERR: cmcTool failed to run!\n\n");
end


% FORWARD DYNAMICS TOOL PATHS %
forwardDynamicsFolder = "ForwardDynamics\";
forwardDynamicsSetup = forwardDynamicsFolder+"forwardDynamics_setup.xml";
forwardDynamicsResultsFolder = forwardDynamicsFolder+"Results\";

% FORWARD DYNAMICS TOOL %
fprintf("THIS MARKS THE BEGINNING OF THE FORWARD TOOL!\n");
forwardTool = ForwardTool(forwardDynamicsSetup); % Initialize Forward Tool
% manager = Manager(model);
% forwardTool.setManager(manager);
% % AbstractTool methods %
% forwardTool.setModel(model);
% %forwardTool.setExternalLoads(externalLoads);
% forwardTool.setResultsDir(forwardDynamicsResultsFolder);

if (forwardTool.run())
    fprintf("\n\nHooray forwardTool ran!\n\n");
else
    fprintf("\n\nCRIT_ERR: forwardTool failed to run!\n\n");
end

