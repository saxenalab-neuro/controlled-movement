classdef PID
    %PID Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Kp
        Ki
        Kd
        Ti
        Td
        e
        u
    end
    
    methods
        function obj = PID(Kp, Ki, Kd)
            %PID Construct an instance of this class
            %   Detailed explanation goes here
            obj.Kp = Kp;
            obj.Ki = Ki;
            obj.Kd = Kd;
            obj.Ti = Kp/Ki;
            obj.Td = Kd/Kp;
            obj.e = zeros(1,100);
            obj.u = zeros(1,100);
        end
        
        function control_value = getControls(obj, t_k, dt)
            %getControls Summary of this method goes here
            %   Detailed explanation goes here
            first_part = (1 + dt / obj.Ti + obj.Td / dt) * obj.e(t_k);
            second_part = (-1 - 2 * obj.Td / dt) * obj.e(t_k-1);
            third_part = obj.Td / dt * obj.e(t_k-2);

            obj.u(t_k) = obj.u(t_k-1) + obj.Kp * (first_part + second_part + third_part);
            
            control_value = obj.u(t_k);
        end
    end
end

