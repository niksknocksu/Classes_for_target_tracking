classdef angle_sensor <  sensor_model
   properties
   end
   methods
       function z = get_meas(object, varargin)
           target_x = varargin{1};
           target_y = varargin{2};
           if numel(varargin) > 2
            target_z = varargin{3};
           end
           switch object.dim
               case 1
                   R = object.sigma_azim^2;
                   z = atan2(target_y - object.y_pos, target_x - object.x_pos) + mvnrnd(zeros(object.dim,1), R)';
               case 2
                   R = diag([object.sigma_azim^2, object.sigma_elev^2]);
                   z = [atan2(target_y - object.y_pos, target_x - object.x_pos);...
                       atan2(target_z - object.z_pos, sqrt(( target_x - object.x_pos)^2 + (target_y - object.y_pos)^2))] + mvnrnd(zeros(object.dim,1), R)';
               case 3
                   error("Supplied dimension 3. Maximum dimension for angle sensor is 2 (theta,elevation)")
           end
       end
       
       function H = get_Jacobian(obj, target_state)
           x_rel = target_state(1) - obj.x_pos;
           y_rel = target_state(2) - obj.y_pos;
           z_rel = target_state(3) - obj.z_pos;
          switch obj.dim
              case 1
                  % 2-D target
                  H = [-y_rel/(x_rel^2 + y_rel^2), x_rel/(x_rel^2 + y_rel^2), zeros(1,numel(target_state) - 2)];
              case 2
                  % 3-D target
                  r = sqrt(x_rel^2 + y_rel^2 + z_rel ^2); r_xy = sqrt(x_rel^2 + y_rel^2);
                  H = [-y_rel/(x_rel^2 + y_rel^2), x_rel/(x_rel^2 + y_rel^2), zeros(1,numel(target_state) - 2);...
                        -x_rel * z_rel / (r^2 * r_xy),-y_rel * z_rel / (r^2 * r_xy), zeros(1,numel(target_state) - 2)];
          end
       end
   end
end