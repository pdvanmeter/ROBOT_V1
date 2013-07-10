%Given the parameter set, generate a data set that fits them exactly.
%Position of first sphere center.
%Orientation of Plane

%Find all the sphere centers in space.
SphereGridRaw = [0 10 20 30 30 30 20 10 0 0;
              0 0 0 0 6.5 13 13 13 13 6.5;
             .99 .99  .99 .99 .995 .995 .995 .995 .995 .955
              1   1    1    1    1   1    1    1    1    1]

SphereGridPlaneFrame = [0 10 20 30 30 30 20 10 0 0;
                        0 0 0 0 6.5 13 13 13 13 6.5;
                        0.0 0.0  0.0 0.0 .005 .005 .005 .005 .005 .005
                        1   1    1    1    1   1    1    1    1    1]
SphereGridPlaneFrame = [SphereGridPlaneFrame(1:3,:)*25.4;ones(1,10)]
          %x-axis connects spheres 1 and 2.
%y-axis connects spheres 1 and 9.
%z axis is x cross y

%Plane Parameters
%First sphere coordinates in world frame.
C=[1252.82; -315.0603; 121.7427;1];