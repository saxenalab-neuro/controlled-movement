clear;clc;

import org.opensim.modeling.* % Import OpenSim Libraries
ModelVisualizer.addDirToGeometrySearchPaths('C:\OpenSim 4.2\Geometry'); % Add geometry to remove visualization error
model = Model("arm26.osim"); % Add the model
model.initSystem();
brain = PrescribedController();


muscleSet = model.getMuscles();
forceSet = model.getForceSet();
bodySet = model.getBodySet();
jointSet = model.getJointSet();
contactGeometrySet = model.getContactGeometrySet();

for j = 1:muscleSet.getSize()
    func = Constant(1);
    f = Function(func);
    muscleSet.get(1)
    func.getValue()
    brain.addActuator(muscleSet.get(j));
    brain.prescribeControlForActuator(j, func);
    maxforces.append(muscleSet.get(j).getMaxIsometricForce())
    curforces.append(1.0)
end

model.addController(brain)




if np.any(np.isnan(action)):
    raise ValueError("NaN passed in the activation vector. Values in [0,1] interval are required.")
end

action = np.clip(np.array(action), 0.0, 1.0)
last_action = action

brain = PrescribedController.safeDownCast(model.getControllerSet().get(0))
functionSet = brain.get_ControlFunctions()

for j =1:functionSet.getSize()
    func = Constant.safeDownCast(functionSet.get(j))
    func.setValue(float(action(j)))
end

functionSet = brain.get_ControlFunctions();

for i = 1:functionSet.getSize()-1
	func = functionSet.get(i);
	func.setValue(action(i));
end

def step(self, action):
activate_muscles(action)

% Integrate one step
if istep == 0
	fprintf("Initializing the model!");
	manager = opensim.Manager(model);
	state.setTime(stepsize * istep)
	manager.initialize(state)
end

state = manager.integrate(stepsize * (istep + 1))

istep = istep + 1;

