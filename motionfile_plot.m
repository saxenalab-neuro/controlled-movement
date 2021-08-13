function [] = motionfile_plot(number)

% This function is to generate the plot of the joint angle position for the specified motion file
% Input: Plot number
% Output: Visual plot of joint angle position


% motion properties = [f, ti, tf, dt, t]; but in struct formation
% motiondata = [t, shoulder, elbow];



% Generate all the desired motions
motions = motion_properties_generator();

% Calculate Motion Data for each function
motiondata = motiongenerator(motions{number});
t = motiondata(:,1);
shoulder = motiondata(:,2);
elbow = motiondata(:,3);


% Calculate the derivatives
dshoulder = gradient(shoulder(:)) ./ gradient(t(:));
delbow = gradient(elbow(:)) ./ gradient(t(:));

figurename = "Desired Kinematics " + num2str(number);
figure('Name', figurename, 'NumberTitle', 'off');

% Make the plots
subplot(1,2,1)
plot(t, elbow, t, shoulder)
legend("Elbow", "Shoulder");


subplot(1,2,2)
plot(t, delbow, t, dshoulder)
legend("d Elbow", "d Shoulder");

end