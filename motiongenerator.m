function [motiondata] = motiongenerator(motion)

% This function uses the key properties from the motion structs generated in "motionpropertiesgenerator.m"
% This function outputs the motion data which includes the time and positions of each joint
% This data will be used as an "ideal" motion file
% 
% motiondata = [t, shoulder, elbow];
%     t is the time
%         tstart, stepsize, tend
%     shoulder is the position values of the shoulder joint w/r to time
%         Contsraints: -90 to 180
%         What I desire: I'm doing a bicep curl so make all the position values zero
%     elbow is the position values of the elbow joint w/r to time
%         Constraints: 0 to 140
%         Vary the position values with time, perhaps add some acceleration in to give more unique motion files



% Create the time data
t = transpose(motion.ti:motion.dt:motion.tf);

% Create an array of zeros for the shoulder as I want to have it NOT move for now [TAG: HARDCODED]
shoulder = zeros(numel(t),1);

% Create the elbow position data from the provided function handle
elbow = motion.f(t);

% Make sure the elbow position values are within range
for i = 1:numel(elbow)
    if elbow(i) > 140
        elbow(i) = 140;
    elseif elbow(i) < 0
        elbow(i) = 0;
    end        
end

% Check that the number of rows match
assert(numel(t) == numel(shoulder));
assert(numel(t) == numel(elbow));

% Return the motion data in a nice vertical matrix
motiondata = [t, shoulder, elbow];

end