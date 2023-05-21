classdef constant_vel < true_motion
   % ordering [x,y,..,x_vel,y_vel,..,x_acc, y_acc...] 
   properties
   end
   methods
      function F = get_F(obj, t)
           switch obj.coord_dim
               case 2
                   F = [1, 0, t, 0;...
                        0, 1, 0, t;...
                        0, 0, 1, 0;...
                        0, 0, 0, 1
                       ];
               case 3
                   F = [1,0,0,t,0, 0;...
                        0,1,0,0,t,0;...
                        0,0,1,0,0,t;...
                        0, 0, 0, 1, 0, 0;...
                        0, 0, 0, 0, 1, 0;...
                        0, 0, 0, 0, 0, 0];
           end
       end
       function Q = get_Q(obj, t)
           switch obj.coord_dim
               case 2
                   Q = obj.q_tilde .* [t^3/3, 0, t^2/2, 0;...
                                        0, t^3/3, 0, t^2/2;...
                                        t^2/2, 0, t, 0;...
                                        0, t^2/2, 0, t];
                       
               case 3
                   Q = obj.q_tilde .* [t^3/3, 0, 0, t^2/2, 0, 0;...
                        0, t^3/3, 0, 0, t^2/2, 0;...
                        0, 0, t^3/3, 0, 0, t^2/2;...
                        t^2/2, 0, 0, t, 0, 0;...
                        0, t^2/2, 0,  0, t, 0;...
                        0, 0, t^2/2, 0, 0, t];
           end
       end
       
       function gen_truth(obj)
           switch obj.coord_dim
               case 2
                   obj.x_initial = [obj.x_initial_pos, obj.y_initial_pos,...
                                    obj.x_initial_vel, obj.y_initial_vel]';
               case 3
                   obj.x_initial = [obj.x_initial_pos, obj.y_initial_pos, obj.z_initial_pos,...
                                    obj.x_initial_vel, obj.y_initial_vel, obj.z_initial_vel]';
           end
           
           num_samples = numel(1:obj.sampling_time:obj.simulation_time);
           obj.x_truth = zeros(obj.coord_dim*2, num_samples);
           obj.x_truth(:,1) = obj.x_initial;
           
           F = obj.get_F(obj.sampling_time);
           Q = obj.get_Q(obj.sampling_time);
           for i = 2:num_samples
               obj.x_truth(:,i) = F * obj.x_truth(:,i-1) + mvnrnd(zeros(obj.coord_dim*2,1), Q)';
           end
       end 
       
   end
end