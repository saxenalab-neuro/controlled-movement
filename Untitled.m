clear;clc;


Kp = [1 1 1 2 2 2];
Ki = [5 2 9 5 2 9];
pi_array = pid(Kp, Ki, 'Ts', 0.1);
size(pi_array)

Cc = pid(4);
T = feedback(Cc,1);
t = 0:0.01:2;
step(T)