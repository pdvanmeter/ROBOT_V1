function [ y p r ] = matrixToAngles( rotationMatrix )
%Turns a rotation matrix into yaw,pitch,roll angles.
%To derive these equations, inspect:
%syms r p y;
%rotMatrix=eye(3);
%T=rotZ(y)*rotY(p)*rotZ(r);
%T=T(1:3,1:3)
p=acos(rotationMatrix(3,3));
r=atan2(rotationMatrix(3,2),-rotationMatrix(3,1));
y=atan2(rotationMatrix(2,3),rotationMatrix(1,3));
end
