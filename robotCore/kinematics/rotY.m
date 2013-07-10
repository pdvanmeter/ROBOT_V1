function [ rotationMatrix ] = rotY( theta )
%Creates a rotation matrix.
rotationMatrix=[ cos(theta) 0 sin(theta)  0;
                         0  1          0   0; 
                -sin(theta)  0  cos(theta)  0;
                         0  0          0   1];
end