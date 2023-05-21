classdef constant_bearingRate < true_motion
    
    % Ordered as [bearing, bearing_rate] OR [bearing, elev, bear_rate, elev_rate]
    properties

    end
    methods
        function F = get_F(obj, t)
            switch obj.coord_dim
                case 1
                    F = [1, t;...
                        0, 1];
                    
                case 2
                    F = [1, 0, t, 0;...
                        0, 1, 0, t;...
                        0, 0, 1, 0;...
                        0, 0, 0, 1];                        
                case 3
                    error('Bearing rate models with more than 2 coordinate dimensions (azimuth, elevation) are not supported')
					% Write your own code
            end
        end
        function Q = get_Q(obj, t)
            switch obj.coord_dim
                case 1
                    Q = obj.q_tilde .* [t^3/3, t^2/2;...         
                                        t^2/2, t];
                    
                case 2
                    Q = obj.q_tilde .* [t^3/3, 0, t^2/2, 0;...
                                        0, t^3/3, 0, t^2/2;...
                                        t^2/2, 0, t, 0;...
                                        0, t^2/2, 0, t];
                case 3
                    error('Bearing rate models with more than 2 coordinate dimensions (azimuth, elevation) are not supported')
					% Write your own code
            end
        end
        
        function gen_truth(obj)
            num_samples = numel(1:obj.sampling_time:obj.simulation_time);
            obj.x_truth = zeros(obj.coord_dim*2, num_samples);
            
            switch obj.coord_dim
                case 1
                    obj.x_initial = [obj.bear_initial, obj.bear_rate_initial]';
                case 2
                    obj.x_initial = [obj.bear_initial, obj.elev_initial, obj.bear_rate_initial, obj.elev_rate_initial]';
            end
  
            obj.x_truth(:,1) = obj.x_initial; % x_initial has to be a column vector
            
            F = obj.get_F(obj.sampling_time);
            Q = obj.get_Q(obj.sampling_time);
            for i = 2:num_samples
                obj.x_truth(:,i) = F * obj.x_truth(:,i-1) + mvnrnd(zeros(obj.coord_dim*2,1), Q)';
            end
        end
    end
end