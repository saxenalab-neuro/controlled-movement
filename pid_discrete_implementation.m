clear;clc;

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


% velocity algorithm for implementation of the discretized PID controller - https://en.wikipedia.org/wiki/PID_controller#Discrete_implementation

Kp = 5.2;
Ki = 2.4;
Kd = 0;
dt = 0.001;

setpoint = 130;

u = [0,0,0];
e = [0,0,0];

Ti = Kp/Ki;
Td = Kd/Kp;

N = 500;


% Initialize PID controllers

Kp = [6,5,4,3,2,1];
Ki = Kp .* 0.5;
Kd = Ki .* 0.5;

numpids = numel(Kp);
pid_array = zeros(1,numpids);

for i = 1:numpids
    pid_array(i) = PID(Kp(i), Ki(i), Kd(i));
end

r = 130;                    % setpoint
e = 0;                      % error
u = zeros(1,numpids);       % controls
y = 0;                      % state/proccess variable



for t_k = 1+2:N+2

%     first_part = @(t_k, e, dt, Ti, Td) (1 + dt / Ti + Td / dt) * e(t_k);
%     second_part = @(t_k, e, dt, Td) (-1 - 2 * Td / dt) * e(t_k-1);
%     third_part = @(t_k, e, dt, Td) Td / dt * e(t_k-2);
% 
%     u(t_k) = @(t_k, u, Kp, e, dt, Ti, Td) u(t_k-1) + Kp * (first_part(t_k, e, dt, Ti, Td) + second_part(t_k, e, dt, Td) + third_part(t_k, e, dt, Td));
    
    for i = 1:numpids
        pid_array(i) = PID(Kp(i), Ki(i), Kd(i));
    end
    
    % do something with u(t_k) = controls
    
    % Result is y = forwardtoolloop(ForwardTool, controls, ti, dt);
    % e(t_k) = setpoint - measured_value;

end

%u(t_k) = u(t_k-1) + Kp* ((1 + dt/T_i + T_d/dt)*e(t_k)...
%...+ (-1 - 2*t_d/dt)*e(t_k-1) + T_d/dt * e(t_k-2));




