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



% Gather the key properties from the motion struct
tstart = motion.tstart;
tend = motion.tend;
stepsize = motion.stepsize;
posstart = motion.posstart;
posfunc = motion.posfunc;


% Create the time array and create a zeros array for the shoulder
t = transpose(tstart:stepsize:tend);
shoulder = zeros(numel(t),1);

% Create the position function from the key properties and generate the data points
f = @(t) posfunc(t) + posstart;
elbow = f(t);

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