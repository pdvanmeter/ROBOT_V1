%Givens 
%J, the robot actuation
%r, the radius of the sphere
%C, the center of the sphere
% + The DH Parameters and the tool model

%Compute the distance to the surface impact point from the laser emission
%point.
J =  [-0.229685329562454
       -0.0996233937038363
          2.07055390481095
                         0
          1.17064468919016
         -1.38090450417791];
r=6.35;
C=[1252.82 -315.0603 121.7427]';

max_reading=100;
reading=0;
%reading=61.04;
keepOn=1;

z= transformRobot(modelRobot(),J)*transformTool(modelSensor())*[0;0;1;0];
z=z(1:3);

O= transformRobot(modelRobot(),J)*transformTool(modelSensor())*[0;0;0;1];
O=O(1:3);
syms k;
 
expr= ((O+k*z-C).*(O+k*z-C) -r*r);
reading = min(double(solve(expr(3))))


