clear;clc;


Fs = 5;
dt = 1/Fs;
N = 50;
t = dt*(0:N-1);
u = [1 zeros(1,N-1)];

Kp = 4;
Ki = 2;


sys = tf(pid(Kp, Ki));

[num,den] = tfdata(sys,'v');
[A,B,C,D] = tf2ss(num,den);

[n,d] = ss2tf(A,B,C,D);


%%% WHAT IS THE CORRECT WAY TO CONVERT A PID TO SS?

x = [0];
for k = 1:N
    x = A*x + B*u(k);
    y(k) = C*x + D*u(k);
end



