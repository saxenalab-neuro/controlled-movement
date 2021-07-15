% Setup OpenSim
import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry'); % Add geometry to remove visualization error
%model = Model("C:\Users\Jaxton\Desktop\monkeyArmModel\monkeyArm.osim"); % Add the model
model = Model("arm26.osim");
model.initSystem();
model.setUseVisualizer(true);