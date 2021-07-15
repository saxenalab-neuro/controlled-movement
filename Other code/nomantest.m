clear;clc;

% Setup OpenSim
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry'); % Add geometry to remove visualization error
model = Model("arm26.osim"); % Add the model


fprintf("There are %d coordinates in the model\n\n", model.getNumCoordinates());
 

jointset = model.getJointSet();

jointset = JointSet.safeDownCast(jointset);



for i = 1:jointset.getSize()
    fprintf("Joint #%d name: %s\n", i, jointset.get(i-1).getName());
end

fprintf("\nThe offset 'joint' is simply a body to raise the entire model above the visual floor in the OpenSim visualizer\n\n");


fprintf("For the shoulder, there are %d coordinates\n", jointset.get(1).numCoordinates());
fprintf("These coordinates are: %s\n\n", jointset.get(1).getCoordinate().getName());


fprintf("For the elbow, there are %d coordinates\n", jointset.get(2).numCoordinates());
fprintf("These coordinates are: %s\n\n", jointset.get(2).getCoordinate().getName());
