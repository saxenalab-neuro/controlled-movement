function [error, y] = modfuncmaker(numfeatures, timelower, timeupper, dt, setinitial, initial)

tic
error = 0;

% Define bounds
anglelower = 0; % degrees
angleupper = 140; % degrees
gradbound = 200; % degrees/second
%timelower = 0; % seconds
%timeupper = 1; % seconds
%dt = 0.001; % seconds


% Feature randomization
features = randi([0 1], 1, numfeatures); % 0 - constant, 1 - slope, 2 - parabola

% Actual values
t = transpose(timelower:dt:timeupper);
y = zeros(size(t));

% Establish time points of features
rt = linspace(timelower, timeupper, numfeatures+1);
ind = floor(rt .* (numel(t)-1) + 1);
rtdiffs = diff(rt);


ry = zeros(size(rt));

if (setinitial)
    % Start by setting the first value to a constant
    ry(1) = initial;
else
    % Start by generating the first random value
    ry(1) = anglelower + (angleupper-anglelower) .* round(rand(1),3);
end

% GO FEATURE BY FEATURE
for i=1:numfeatures
    
    % CONSTANT %
    if (features(i) == 0)
        ry(i+1) = ry(i); % Calculate constant slope
        y(ind(i):ind(i+1),1) = ry(i); % Assign y values for output
        continue % Go to next feature
    end
    
    
    % Generate next random value for all other features
    ry(i+1) = anglelower + (angleupper-anglelower) .* round(rand(1),3);
    
    % Regenerate random value until the gradient is not horrible
    while (abs(ry(i+1) - ry(i)) / rtdiffs(i)) > gradbound
        ry(i+1) = anglelower + (angleupper-anglelower) .* round(rand(1),3); % Regenerate random value
    end
    
    
    % LINEAR SLOPE %
    if (features(i) == 1)
        slope = linspace(ry(i), ry(i+1), ind(i+1)-ind(i)+1); % Calculate slope
        y(ind(i):ind(i+1),1) = slope; % Assign y values
        continue % Go to next feature
    end
    
    
    % PARABOLA %
    if (features(i) == 2)
        % Generate the parabola
        while true
            % Generate the vertex point of the parabola
            lowbound = rt(i) + rtdiffs(i)*0.1; % Modify beginning time point by adding 10% of the difference between the two
            highbound = rt(i+1) - rtdiffs(i)*0.1; % Modify ending time point by subtracting 10% of the difference between the two
            tmpx = (highbound - lowbound) .* rand(1) + lowbound; % Create random x coordinate for vertex
            tmpy = (angleupper - anglelower) .* rand(1) + anglelower; % Create random y coordinate for vertex
            
            % Create and solve equation
            A = [rt(i)^2 rt(i) 1;
                tmpx^2 tmpx 1;
                rt(i+1)^2 rt(i+1) 1];
            b = [ry(i); tmpy; ry(i+1)];
            sol = A\b;
            
            % Use solved function to get parabola points
            func = @(x) sol(1)*x.^2 + sol(2)*x + sol(3);
            tmpt = t(ind(i):ind(i+1),1);
            tmpy = func(tmpt);
            
            % Make sure no values are larger than 140 and smaller than 0
            if any(tmpy > 140) || any(tmpy < 0)
                if (toc > 5)
                    error = 1;
                    break % get out of this asap
                end
                
                continue % bad parabola, let's try again
            end
            
            % Check gradient of parabola time points
            grad = diff(tmpy) ./ diff(tmpt);
            if all(grad < gradbound)
                break % This was a good parabola
            end
        end
        
        y(ind(i):ind(i+1),1) = tmpy; % Assign y values
        continue % Go to next feature
    end
    
end % End feature recognition



% SMOOTH Y VALUES%
% Moving Average Filter w/ a Span of 40
%y = smooth(y, 40);

end
