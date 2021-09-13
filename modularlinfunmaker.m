function [t, y] = modularlinfunmaker(numfeatures)
%numfeatures = 3;

% Define bounds
lower = 0; % degrees
upper = 140; % degrees
gradbound = 300; % degrees/second
timeupper = 1; % seconds
timelower = 0; % seconds
dt = 0.001; % seconds

features = randi([0 2], 1, numfeatures); % 0 - constant, 1 - slope (+/- depending on generated numbers)
% TODO: Expand possible features




% Generate (num features - 1) random time points
% rt = zeros(1,numfeatures+1);
% rt(1) = timelower;
% rt(numel(rt)) = timeupper;
% rt(2:numfeatures) = sort(timelower + (timeupper - timelower) .*  transpose(round(rand(numfeatures-1,1),3)));
% rtdiffs = diff(rt);
% 
% TODO: This is a little arbitrary
% while any(rtdiffs < 0.05)
%     rt(2:numfeatures) = sort(timelower + (timeupper - timelower) .*  transpose(round(rand(numfeatures-1,1),3)));
%     rtdiffs = diff(rt);
% end






% Actual parts
t = transpose(0:.001:1);
y = zeros(size(t));


rt = linspace(timelower, timeupper, numfeatures+1);
ind = floor(rt .* (numel(t)-1) + 1);
rtdiffs = diff(rt);



% Start by generating the first random value
ry = zeros(size(rt));
ry(1) = lower + (upper-lower) .* round(rand(1),3);




% GO FEATURE BY FEATURE
for i=1:numfeatures
    % Generate Constant between connective points
    if (features(i) == 0)
        ry(i+1) = ry(i);
        %ind = rt .* 1000 + 1;
        y(ind(i):ind(i+1),1) = ry(i);
        continue
    end
    
    
    % All other features need a next random value
    % Generate the next random value
    ry(i+1) = lower + (upper-lower) .* round(rand(1),3);

    while (abs(ry(i+1) - ry(i)) / rtdiffs(i)) > gradbound
        % Regenerate random value until the gradient isn't horrible
        ry(i+1) = lower + (upper-lower) .* round(rand(1),3);
    end
    
    
    
    
    % Generate Linear Slope between connective points
    if (features(i) == 1)
        slope = linspace(ry(i), ry(i+1), ind(i+1)-ind(i)+1); % Calculate slope
        
        y(ind(i):ind(i+1),1) = slope; % Assign y values
        continue % Go to next feature
    end
    
    
    % Generate parabola between two points
    if (features(i) == 2)
        
        while true
            % Get three points to fit polynomial to
            
            lowbound = rt(i) + rtdiffs(i)*0.1;
            highbound = rt(i+1) - rtdiffs(i)*0.1;
            tmpx = (highbound - lowbound) .* rand(1) + lowbound;
            tmpy = (upper - lower) .* rand(1) + lower;
            
            px = [rt(i), tmpx, rt(i+1)];
            py = [ry(i), tmpy, ry(i+1)];
            
            A = [rt(i)^2 rt(i) 1;
                tmpx^2 tmpx 1;
                rt(i+1)^2 rt(i+1) 1];
            b = [ry(i); tmpy; ry(i+1)];
            sol = A\b;
            func = @(x) sol(1)*x.^2 + sol(2)*x + sol(3);
            tmpt = t(ind(i):ind(i+1),1);
            tmpy = func(tmpt);
            
%             % Fit a polynomial to the three points
%             p = polyfit(px,py,2);
%         
%             % Get t and parabola y vals for the region of interest
%             tmpt = t(ind(i):ind(i+1),1);
%             
%             % Evaluate the polynomial on the actual grid
%             tmpy = polyval(p, tmpt);
            
            if any(tmpy > 140)
                continue
            end
            
            if any(tmpy < 0)
                continue
            end
            
            % Calculate gradient
            dtmpt = diff(tmpt);
            dtmpy = diff(tmpy);
            grad = dtmpy ./ dtmpt;
            
            % Check if we need to regenerate the vertex
            if all(grad < gradbound)
                break % Stop the while loop, this was a good random vertex
            end
        end
        
        
%         while true
%             % Generate a random vertex for the parabola
%             vertex = [(rt(i)*1.05) + (rt(i+1)*.95 - rt(i)*1.05) .* round(rand(1),3), lower + (upper - lower) .* round(rand(1),3)];
%             
%             tmpinput = [rt(i), (rt(i)*1.05) + (rt(i+1)*.95 - rt(i)*1.05) .* round(rand(1),3), rt(i+1)];
%             tmpoutput = [ry(i), lower + (upper - lower) .* round(rand(1),3), ry(i+1)];
%             
%             p = polyfit(x,y,2);
%             
%             
%             
%             % Solve for a,b,c constants in y = ax^2 + bx + c
%             A = [rt(i)^2, rt(i), 1;
%                 rt(i+1)^2, rt(i+1), 1;
%                 vertex(1)^2, vertex(1), 1];
%                 
% 
%             b = [ry(i); ry(i+1); vertex(2)];
% 
%             vals = A\b; % Solve
%             
%             % Get t and parabola y vals for the region of interest
%             tmpt = t(ind(i):ind(i+1),1);
%             tmpy = vals(1)*tmpt.^2 + vals(2)*tmpt + vals(3);
%             
%             % Calculate gradient
%             dtmpt = diff(tmpt);
%             dtmpy = diff(tmpy);
%             grad = dtmpy ./ dtmpt;
%             
%             % Check if we need to regenerate the vertex
%             if all(grad < gradbound)
%                 break % Stop the while loop, this was a good random vertex
%             end
%         end
        

        y(ind(i):ind(i+1),1) = tmpy; % Assign y values
        continue % Go to next feature
    end
    
    
    
    
    % Generate 
end

end
