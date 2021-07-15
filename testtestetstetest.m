clear;clc;






Kp = 200;
Ki = 400;
Kd = 40;

s = tf('s');
sys = Kp + Ki/s + Kd*s/(1+0.00001*s);

[num,den] = tfdata(sys, 'v');

%den = [0.0001, 1, 0];

[A,B,C,D] = tf2ss(num,den);



coordinates.target = 130;
coordinates.actual = 0;
coordinates.error = coordinates.target - coordinates.actual;


u = zeros(1,6);




for k = 1:N
    x = A*x + B*u(k);
    y(k) = C*x + D*u(k);
end



% Kp - proportional gain
% Ki - integral gain
% Kd - derivative gain
% dt - loop interval time
% previous_error := 0
% integral := 0
% 
% loop:
%     error := setpoint − measured_value
%     proportional := error;
%     integral := integral + error × dt
%     derivative := (error − previous_error) / dt
%     output := Kp × proportional + Ki × integral + Kd × derivative
%     previous_error := error
%     wait(dt)
%     goto loop