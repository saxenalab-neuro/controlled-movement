clear;clc;

% math

Kp = 200;
Ki = 400;
Kd = 40;
Tf = 0; % No filter on the derivative action
Ts = 0.01; % Sample time


coordinates.target = [0, 130];
coordinates.actual = [0, 0];
coordinates.error = coordinates.target - coordinates.actual;

%U = Ki.*coordinates.error + Ki *
C = pid(5,2.4,'Ts',0.1);


sys = feedback(C,1); % No system, just the controller and feedback. HOW THE HECK DO I MODEL MY SYSTEM


step(sys)


[num,den] = tfdata(sys,'v');
[A,B,C,D] = tf2ss(num,den);

N = 50;

for k = 1:N
    % PID? Or System too?
    x(k+1) = A*x(k)+B*u(k);
    y(k) = C*x(k)+D*u(k);
    
    % System function
    result = pid_result + 5;
    
end

Cc = pid(4);
T = feedback(Cc,1);
t = 0:0.01:2;
step(T)




setpoint = 130;


loop
    PID
    
    function
end loop













objective function - 0 to 130
    difference in angle vs desired
    P:1 -> P:1.01 -> observe objective function, is it better or worse?
    take output from plant and PID parameters, simulink + scripting together?
    
    

