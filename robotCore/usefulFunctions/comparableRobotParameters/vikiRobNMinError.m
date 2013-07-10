function robot=vikiRobNMinError()
robot=[
      0     0      0      0;
    -89.9883  .0599 -0.0256   0.7034;
    0.0131    625.5037   0.0139 -0.0341;
    -89.9781  -0.0006  0.0406   626.2587;
    90.0193   -0.5274   -0.0884   0.5587;
    -90.0176  0.5365    0     0 ;
    ];
robot(:,1)=deg2rad(robot(:,1));
robot(:,3)=deg2rad(robot(:,3));
robot(3,4)=deg2rad(robot(3,4));
        end