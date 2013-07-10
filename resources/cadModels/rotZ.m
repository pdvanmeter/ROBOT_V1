function [ rotationMatrix ] = rotZ( theta )
%Creates a rotation matrix.
rotationMatrix=[ cos(theta) -sin(theta)  0 0;
                 sin(theta)  cos(theta)  0 0;
                         0           0   1 0;
                         0           0   0 1];
end