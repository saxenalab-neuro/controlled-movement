clear;clc;

% forwardtooltest

% OpenSim boiler plate
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry'); % Add geometry to remove visualization error
model = Model("arm26.osim"); % Add the model


controlsfile = "Tools/CMC_Results/cmc_output_controls.xml";
controls = xml2struct(controlsfile);


%controlsfile = "ComputedMuscleControl/Results/cmc_output_controls.sto"; % Assign the file name
%controls = importdata(controlsfile,' ', 7).data; % Import the data from the file
%row = kinematics(1,:);


% FORWARD DYNAMICS TOOL PATHS %
fdFolder = "Tools\";
fdSetup = fdFolder+"fd_setup.xml";
fdResultsFolder = fdFolder+"FD_Results\";

% FORWARD DYNAMICS TOOL QUICK INITIALIZE%
fprintf("THIS MARKS THE BEGINNING OF THE ERR... MANAGER? TOOL!\n");

% SET MODEL STUFF
model.getMultibodySystem().realize(s,


maxSteps = 30000;
maxDT = 1;
minDT = 1.0e-8;
errorTolerance = 1.0e-5;

s = model.initSystem(); % s = SimTK::State&

manager = manager(model);
setManager(manager);
manager.setSessionName(getName());
manager.setWriteToStorage(false);
manager.setIntegratorInternalStepLimit(maxSteps);
manager.setIntegratorMaximumStepSize(maxDT);
manager.setIntegratorMinimumStepSize(minDT);
manager.setIntegratorAccuracy(errorTolerance);
manager.setUseSpecifiedDT(true);
manager.setDTArray(SimTK::Vector_<double>(aYStore->getSize() - 1, &dtArray[0]), tArray[0]);


if (forwardTool.run())
    fprintf("\n\nHooray forwardTool ran!\n\n");
else
    fprintf("\n\nCRIT_ERR: forwardTool failed to run!\n\n");
end