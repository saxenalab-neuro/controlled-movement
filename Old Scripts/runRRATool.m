function [run_successfully] = runRRATool(run_number, ti, tf)


% IMPORTANT:
% File paths are weird for the tools. The root directory is initialized as
% C:\Users\Jaxton\OneDrive\controlled-movement\System Identification
% as this is the path of the RRATool setup file
% Any further paths must be RELATIVE to this main path at all times


% Setup OpenSim
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry');
model = Model("arm26.osim"); % Add the model


% Set File Paths
motionfilename = "Motion Files\script_" + num2str(run_number) + ".mot";
rrasetup = "System Identification\rra_motiongen_setup.xml";


% Setup the RRA Tool
rraTool = RRATool(rrasetup);
rraTool.setModel(model);
rraTool.setName("rra_" + num2str(run_number));
rraTool.setDesiredKinematicsFileName(motionfilename);
rraTool.setInitialTime(ti);
rraTool.setFinalTime(tf);


% Run the RRA Tool
run_successfully = rraTool.run();


% Error Reporting
if (run_successfully == 0)
    fprintf("CRIT_ERR: RRA Tool failed to run on script %d", run_number); 
end

end