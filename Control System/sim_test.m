clear;clc;

system_order = 8;

HPGMdir = "//client/c$/Users/Jaxton/Desktop/sysid/systems/";
%HPGMdir = "C:/Users/Jaxton/Desktop/sysid/systems/";

% --- IMPORT TRANSFER FUNCTIONS --- %

sysfilename = HPGMdir + "sys_" + num2str(system_order) + "_5000" + ".mat";
sys_idss = load(sysfilename).sys;

tffilename = "systems/sys_" + num2str(system_order) + "_tf.mat";
sys_tf = load(tffilename).sys_tf;

% Import estimated initial states
x0filename = "systems/sys_" + num2str(system_order) + "_report.mat";
x0 = load(x0filename).report.Parameters.X0;
x0 = sys_idss.Report.Parameters.X0;

initial(sys_idss, x0(2))


% u = load("u.mat").u;
% u = transpose(u);
% 
% t = 0:0.001:10;
% 
% 
% a = transpose(lsim(sys_tf, u, t, x0(:,1)));
% b = transpose(lsim(sys_tf, u, t, x0(:,2)));
% test = [a(:,1) b(:,2)];
% test_deg = rad2deg(test);
% 
% 
% simOpt = simOptions('InitialCondition',x0(:,1));
% pos_sim = sim(sys_idss, u, simOpt);
% 
% simOpt = simOptions('InitialCondition',x0(:,2));
% vel_sim = sim(sys_idss, u, simOpt);
% 
% y_sim = [pos_sim(:,1) vel_sim(:,2)];
% 
% plot(t,y_sim)
