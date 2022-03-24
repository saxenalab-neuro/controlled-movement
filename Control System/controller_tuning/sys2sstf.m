clear;clc;


HPGMdir = "//client/c$/Users/Jaxton/Desktop/sysid/systems/";
systemsdir = "../systems/";

% Check if directory exists, if not, mkdir
if not(isfolder(systemsdir))
    mkdir(systemsdir)
end


for order=1:15
    % Using a try catch is lazy because not all the systems exist, some
    % were awful like 7 or something like that
    try
        sysfilename = HPGMdir + "sys_" + num2str(order) + "_5000" + ".mat";
        sys_idss = load(sysfilename).sys;
    catch
        continue
    end


    % Create systems
    sys_ss = ss(sys_idss);
    sys_tf = tf(sys_idss);
    report.Fit = sys_idss.Report.Fit;
    report.Parameters = sys_idss.Report.Parameters;

    % Save systems and report
    ssfilename = systemsdir + "sys_" + num2str(order) + "_ss.mat";
    tffilename = systemsdir + "sys_" + num2str(order) + "_tf.mat";
    reportfilename = systemsdir + "sys_" + num2str(order) + "_report.mat";

    save(ssfilename, 'sys_ss');
    save(tffilename, 'sys_tf');
    save(reportfilename, 'report');
    
    fprintf("Saved system order %d\n", order);

end
