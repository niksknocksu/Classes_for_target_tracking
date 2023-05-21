% Author : Nikhil Sharma, nikhil.sharma.mcmaster@gmail.com
classdef radar_sensor < sensor_model
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
                   error("Dimension value 1 supplied for radar sensor, need at least two (range, azimuth). Maximum 3 (range, azimuth, elevation).")
               case 2
                   R = diag([object.sigma_r^2, object.sigma_azim^2]);
                   z = [sqrt( (target_x - object.x_pos)^2 + (target_y - object.y_pos)^2);...
                        atan2(target_y - object.y_pos, target_x - object.x_pos)] + mvnrnd(zeros(object.dim,1), R)';
                       
               case 3
                   R = diag([object.sigma_r^2, object.sigma_azim^2, object.sigma_elev^2]);
                   z = [sqrt( (target_x - object.x_pos)^2 + (target_y - object.y_pos)^2 + (target_z - object.z_pos)^2 );...
                        atan2(target_y - object.y_pos, target_x - object.x_pos);...
                        atan2(target_z - object.z_pos, sqrt(( target_x - object.x_pos)^2 + (target_y - object.y_pos)^2))] + mvnrnd(zeros(object.dim,1), R)';
               case 4
                   error("Dimension value 4 supplied for radar sensor, need at most 3 (range, azimuth, elevation).")
           end
                   
       end
       
       function R = get_R(object)
          switch object.dim
              case 2
                  R = diag([object.sigma_r^2, object.sigma_azim^2]);
              case 3
                  diag([object.sigma_r^2, object.sigma_azim^2, object.sigma_elev^2]);
          end
       end
   end
    
end