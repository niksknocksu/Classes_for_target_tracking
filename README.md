# Classes_for_target_tracking

Generating target data for object tracking simulation is often a cumbersome task. The user has to write various matrices for already existing motion models in the literature. For multiple targets and sensor models, it is best to use an object oriented approach. This repository aims to handle this problem.

You can add your own classes for non-existing models.

## Target and Sensor Parameters
The parameters like the measurement noise statistic, target initial location , speed, process noise intensity etc. are provided in their respective .xml files. These are present in the folder _config_target_ for targets and _config_sensor_ for sensors. For parsing .xml files, [xml2struct.m](https://www.mathworks.com/matlabcentral/fileexchange/28518-xml2struct) is used.

## Existing models
### Targets : 
  Nearly Constant Velocity (2D/3D).
  
  Nearly Constant Acceleration (2D/3D).
  
  Nearly Constant Bearing rate (non-Cartesian).

### Sensors : 
  Radar (2D/3D).
  
  Bearings sensor (azimuth/ azimuth + elevation).

See _MAIN_class_usage.m_ for a simple usage. 
