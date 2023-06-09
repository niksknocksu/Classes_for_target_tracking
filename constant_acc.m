classdef constant_acc < true_motion
    % ordering [x,y,..,x_vel,y_vel,..,x_acc, y_acc...]
    properties
    end
    methods
        function F = get_F(object, t)
            switch object.coord_dim
                case 2
                    F = [1,0,t,0,(t^2)/2,0;...
                        0,1,0,t,0,(t^2)/2;...
                        0,0,1,0,t,0;...
                        0,0,0,1,0,t;...
                        0,0,0,0,1,0;...
                        0,0,0,0,0,1];
                case 3
                    F = [1,0,0,t,0,0,(t^2)/2,0,0;...
                        0,1,0,0,t,0,0,(t^2)/2,0;...
                        0,0,1,0,0,t,1,0,(t^2)/2;...
                        0,0,0,1,0,0,t,0,0;...
                        0,0,0,0,1,0,0,t,0;...
                        0,0,0,0,0,1,0,0,t;...
                        0,0,0,0,0,0,1,0,0;...
                        0,0,0,0,0,0,0,1,0;...
                        0,0,0,0,0,0,0,0,1];
            end
        end
        
        function Q = get_Q(object, t)
            switch object.coord_dim
                case 2
                    Q = object.q_tilde.*[(t^5)/20, 0, (t^4)/8, 0, (t^3)/6, 0;...
                        0, (t^5)/20, 0, (t^4)/8, 0, (t^3)/6;...
                        (t^4)/8, 0, (t^3)/3, 0, (t^2)/2, 0;...
                        0, (t^4)/8, 0, (t^3)/3, 0, (t^2)/2;...
                        (t^3)/6, 0, (t^2)/2, 0, t, 0;...
                        0, (t^3)/6, 0, (t^2)/2, 0, t];
                case 3
                    Q = object.q_tilde.*[(t^5)/20, 0, 0, (t^4)/8, 0, 0, (t^3)/6, 0, 0;...
                        0, (t^5)/20, 0, 0, (t^4)/8, 0, 0, (t^3)/6, 0;...
                        0, 0, (t^5)/20, 0, 0, (t^4)/8, 0, 0, (t^3)/6;
                        (t^4)/8, 0, 0, (t^3)/3, 0, 0, (t^2)/2, 0, 0;...
                        0, (t^4)/8, 0, 0, (t^3)/3, 0, 0, (t^2)/2, 0;...
                        0, 0, (t^4)/8, 0, 0, (t^3)/3, 0, 0, (t^2)/2;...
                        (t^3)/6, 0, 0, (t^2)/2, 0, 0, t, 0, 0;...
                        0, (t^3)/6, 0, 0, (t^2)/2, 0, 0, t, 0;...
                        0, 0, (t^3)/6, 0, 0, (t^2)/2, 0, 0, t];
            end
        end
        
        function gen_truth(obj)
%             if isempty(obj.x_initial)
%                 error('x_initial needs to be supplied first')
%             end
            
            switch obj.coord_dim
                case 2
                    obj.x_initial = [obj.x_initial_pos, obj.y_initial_pos,...
                                     obj.x_initial_vel, obj.y_initial_vel,...
                                     obj.x_initial_acc, obj.y_initial_acc]';
                case 3
                    obj.x_initial = [obj.x_initial_pos, obj.y_initial_pos, obj.z_initial_pos,...
                                     obj.x_initial_vel, obj.y_initial_vel, obj.z_initial_vel,...
                                     obj.x_initial_acc, obj.y_initial_acc, obj.z_initial_acc]';
            end
            
            num_samples = numel(1:obj.sampling_time:obj.simulation_time);
            obj.x_truth = zeros(obj.coord_dim*3, num_samples);
%             if size(obj.x_initial,2) > 1
%                 obj.x_initial = obj.x_initial';
%             end
            if numel(obj.x_initial) ~= obj.coord_dim*3
                error("Check the dimension of the initial point, has to be dimension*3 for CA model")
            end
            obj.x_truth(:,1) = obj.x_initial; % x_initial has to be a column vector
            F = obj.get_F(obj.sampling_time);
            Q = obj.get_Q(obj.sampling_time);
            for i = 2:num_samples
                obj.x_truth(:,i) = F * obj.x_truth(:,i-1) + mvnrnd(zeros(obj.coord_dim*3,1), Q)';
            end
        end
    end
    
end