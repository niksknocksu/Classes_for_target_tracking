% Author : Nikhil Sharma, nikhil.sharma.mcmaster@gmail.com


% To use the relevant classes, make sure you have the config files containing class parameters.
% Declare objects as you normally do, with config files as arguments.

% See the class structure and config files to understand the code.

target_1 = constant_vel('config_target/config_cv.xml'); target_1.initialize(); target_1.gen_truth();
target_2 = constant_acc('config_target/config_ca.xml'); target_2.initialize(); target_2.gen_truth();

radar_1 = radar_sensor('config_sensor/config_radar.xml'); radar_1.initialize();


z = radar_1.get_meas(target_1.x_truth(1,3), target_1.x_truth(2,3)); %[r;theta]