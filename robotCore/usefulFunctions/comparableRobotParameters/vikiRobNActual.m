function robot=vikiRobNActual()
robot=[
      0     0      0      0;
    -89.99  .05 -0.03   0.70;
    0.01    625.5   0.01 -0.04;
    -89.98  -0.001  0.036   626.25;
    90.01   -0.53   -0.09   0.55;
    -90.02  0.53    0     0 ;
    ];
robot(:,1)=deg2rad(robot(:,1));
robot(:,3)=deg2rad(robot(:,3));
robot(3,4)=deg2rad(robot(3,4));
        end