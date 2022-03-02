s = tf('s');
G = 1/(75*s+1)*[87.8 -86.4; 108.2 -109.6];
G.InputName = {'qL', 'qV'};
G.OutputName = 'y';

D = tunableGain('Decoupler', eye(2));
D.InputName = 'e';
D.OutputName = {'pL','pV'};

PI_L = tunablePID('PI_L', 'pi');
PI_L.InputName = 'pL';
PI_L.OutputName = 'qL';
  
PI_V = tunablePID('PI_V', 'pi'); 
PI_V.InputName = 'pV';
PI_V.OutputName = 'qV'; 

sum1 = sumblk('e = r - y', 2);

C0 = connect(PI_L, PI_V, D, sum1, {'r','y'}, {'qL','qV'});

wc = [0.1, 1];
[G, C, gam, Info] = looptune(G, C0, wc);

showTunable(C)

T = connect(G, C, 'r', 'y');
step(T)

figure('Position', [100, 100, 520, 1000])
loopview(G, C, Info)