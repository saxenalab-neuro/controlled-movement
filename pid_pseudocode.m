clear;clc;

% simple software loop that implements a PID algorithm - https://en.wikipedia.org/wiki/PID_controller#Pseudocode

Kp = 5.2;
Ki = 2.4;
Kd = 0;
dt = 0.001;

setpoint = 130;
measured_value = 0;

previous_error = 0;
integral = 0;

N=500;

for i = 1:N
    
    error = setpoint - measured_value;
    proportional = error;
    integral = integral + error * dt;
    derivative = (error - previous_error) / dt;
    controls = Kp * proportional + Ki * integral + Kd * derivative;
    previous_error = error;
    %wait(dt)
    
end

%%

Kp = [6,5,4,3,2,1];
Ki = Kp .* 0.5;
Kd = Ki .* 0.5;
dt = 0.001;

setpoint = 130;
measured_value = 0;
previous_error = 0;

numpids = numel(Kp);
integral = zeros(1,numpids);
controls = zeros(1,numpids);

N=500;

while true
    
    for i = 1:numpids
        error = setpoint - measured_value;
        proportional = error;
        integral(i) = integral(i) + error * dt;
        derivative = (error - previous_error) / dt;
        controls(i) = Kp(i) * proportional + Ki(i) * integral(i) + Kd(i) * derivative;
        previous_error = error;
    end
    
    measured_value = forwardtoolloop(ForwardTool, controls, ti, dt);
    
    
end