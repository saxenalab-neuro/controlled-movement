clear;clc;

order = 4;



HPGMdir = "\\client\c$\Users\Jaxton/Desktop/sysid/systems/";
sysfilename = HPGMdir + "sys_" + num2str(order) + "_5000" + ".mat";
sys_idss = load(sysfilename).sys;


% Create ss
sys_ss = ss(sys_idss);

[A,B,C,D,K,x0] = idssdata(sys_idss);
[E,F,G,H,Ts] = ssdata(sys_ss);

X = [isequal(A, E), isequal(B, F), isequal(C, G), isequal(D, H)]


sys_idtf = idtf(sys_idss);
[num_idtf, den_idtf] = tfdata(sys_idtf);

sys_tf = tf(sys_idss);
[num_tf, den_tf] = tfdata(sys_tf);

Y = [isequal(num_idtf, num_tf), isequal(den_idtf, den_tf)]


% Save state space (ss) systems
idssfilename = "sys_" + num2str(order) + "_idss.mat";
ssfilename = "sys_" + num2str(order) + "_ss.mat";

save(idssfilename, 'sys_idss');
save(ssfilename, 'sys_ss');


% Save transfer functions (tf)
idtffilename = "sys_" + num2str(order) + "_idtf.mat";
tffilename = "sys_" + num2str(order) + "_tf.mat";

save(idtffilename, 'sys_idtf');
save(tffilename, 'sys_tf');

% Save ss data
% ssdatafilename = "sys_" + num2str(order) + "_ssdata.mat";
% save(ssdatafilename, 'A','B','C','D','K','x0','Ts');

