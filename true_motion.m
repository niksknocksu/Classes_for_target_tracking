classdef true_motion < handle
    % Class to create target motion for a discretized models.
    % Near constant velocity and near constant acceleration models are ...
    % supported
    
    properties(Access=public)
        file_name;
        coord_dim = 2; % number of coordinates
        x_initial; % initial state vec, as a column vector with ordering [x,y,..,x_vel,y_vel,..,x_acc, y_acc...]
        sampling_time = 1; % for truth generation
        q_tilde = 1E-3;
        simulation_time = 120; % seconds
        x_truth = 0;
        model_type;
        x_initial_pos = 0;
        y_initial_pos = 0;
        z_initial_pos = 0;
        x_initial_vel = 0;
        y_initial_vel = 0;
        z_initial_vel = 0;
        x_initial_acc = 0;
        y_initial_acc = 0;
        z_initial_acc = 0;
        
        bear_initial = 0;
        bear_rate_initial = 0;
        
        elev_initial = 0;
        elev_rate_initial = 0;
		
		% Add your own
    end
    
    methods
%         function object = true_motion(dim_in)
%             object.coord_dim = dim_in;
%         end
        function object = true_motion(file_name_in)
            object.file_name = file_name_in;
        end
        function initialize(obj)
            myFile_struct = xml2struct(obj.file_name);
            obj.model_type = (myFile_struct.MotionParam.model_type.Text);
            obj.x_initial_pos = str2double(myFile_struct.MotionParam.x_initial_pos.Text);
            obj.y_initial_pos = str2double(myFile_struct.MotionParam.y_initial_pos.Text);
            obj.z_initial_pos = str2double(myFile_struct.MotionParam.z_initial_pos.Text);
            
            obj.x_initial_vel = str2double(myFile_struct.MotionParam.x_initial_vel.Text);
            obj.y_initial_vel = str2double(myFile_struct.MotionParam.y_initial_vel.Text);
            obj.z_initial_vel = str2double(myFile_struct.MotionParam.z_initial_vel.Text);
            
            obj.x_initial_acc = str2double(myFile_struct.MotionParam.x_initial_acc.Text);
            obj.y_initial_acc = str2double(myFile_struct.MotionParam.y_initial_acc.Text);
            obj.z_initial_acc = str2double(myFile_struct.MotionParam.z_initial_acc.Text);
            
            obj.bear_initial = str2double(myFile_struct.MotionParam.bear_initial.Text);
            obj.bear_rate_initial = str2double(myFile_struct.MotionParam.bear_rate_initial.Text);
            
            obj.elev_initial = str2double(myFile_struct.MotionParam.elev_initial.Text);
            obj.elev_rate_initial =  str2double(myFile_struct.MotionParam.elev_rate_initial.Text);
            
            obj.coord_dim = str2double(myFile_struct.MotionParam.coord_dim.Text);
            obj.q_tilde = str2double(myFile_struct.MotionParam.q_tilde.Text);
            obj.sampling_time = str2double(myFile_struct.MotionParam.sampling_time.Text);
            obj.simulation_time = str2double(myFile_struct.MotionParam.simulation_time.Text);

        end
    end
end