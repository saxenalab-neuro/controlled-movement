A = [0.5 0; 0 1];
B = [1 ; 0];
C = [1 -1]; D = 0;
sys = ss(A,B,C,D,-1);
y = impulse(sys,0:15);
stem(0:15,y,'filled');