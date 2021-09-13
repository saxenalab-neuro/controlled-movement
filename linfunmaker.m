function [y,t] = linfunmaker()

% Define bounds
lower = 0; % degrees
upper = 140; % degrees
df = 400; % degrees/second
timeupper = 1; % seconds
timelower = 0; % seconds
dt = 0.001; % seconds





% Randomly pick two points between 0 and 140
ry = lower + (upper-lower) .*  round(rand(2,1),3);


rdiff = ry(2) - ry(1);

% What is the limit of the rate of this difference wrt time
tdiffmin = abs(rdiff/df);


tdiffs =  [tdiffmin, timeupper-timelower];

% So the difference of my two corresponding time values needs to be within this range

% Randomly pick two time points between tdiff and time
rt = sort(timelower + (timeupper - timelower) .*  round(rand(2,1),3));

tdiff = rt(2) - rt(1);

while tdiff < tdiffmin
    rt = sort(timelower + (timeupper - timelower) .*  round(rand(2,1),3));
    tdiff = rt(2) - rt(1);
end

assert(tdiff >= tdiffmin)


% Okay so now I have 2 key points with 2 corresponding key time points
% For the simple example, give constant value u     p to the first point and constant value from the second point

t = transpose(0:.001:1);
y = zeros(size(t));


% FEATURES

% Connective Points
ind = rt .* 1000 + 1;


% First Constant Part
y(1:ind(1),1) = ry(1);


% Slope
slope = linspace(ry(1), ry(2), ind(2)-ind(1)+1);
y(ind(1):ind(2),1) = slope;


% Second Constant Part
y(ind(2):numel(y), 1) = ry(2);



end

