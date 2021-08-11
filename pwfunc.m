classdef pwfunc
    %pwfunc Summary of this class goes here
    %   Detailed explanation goes here
    % https://www.mathworks.com/matlabcentral/answers/181763-class-property-assignment-and-read
    
    properties
        numargs
        args
        bounds
    end
    
    methods
        function this = pwfunc()
            %pwfunc Construct an instance of this class
            %   Detailed explanation goes here
            this.numargs = 0;
            this.args = strings(1,10);
            this.bounds = zeros(10,2);
        end
        
        function [this] = AddArg(this, arg, lowerbound, upperbound)
            %AddArg Summary of this method goes here
            %   Detailed explanation goes here
            tmpnumargs = this.numargs + 1;
            
            this.args(tmpnumargs) = arg; % Assign the arg
            this.bounds(tmpnumargs, 1) = lowerbound; % Assign the lower bound
            this.bounds(tmpnumargs, 2) = upperbound; % Assign the upper bound
            this.numargs = tmpnumargs;
        end
        
        function value = getNumArgs(this)
            value = this.numargs;
        end
        
        function value = getArgs(this)
            value = this.args;
        end
        
        function value = getBounds(this)
            value = this.bounds;
        end
    end
end