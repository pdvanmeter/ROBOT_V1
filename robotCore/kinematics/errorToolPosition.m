function [ errVector ] = errorToolPosition( dataPacket,targetPoint, robotParameters, toolParameters)
%Computes the error in the laser dot position.
%Use this if you want to hit a certain spot with the laser and all
%orientations are allowed.

%dataPacket: J[6] d [1]
J=dataPacket(1:6);
d=dataPacket(7);
%The robot (modeled by robotParameters) has actuation J.
%The laser (whose mount is modeled by laserParameters) has beam length d.

T = transformRobot(robotParameters,J) * transformTool(toolParameters);
hitPoint = T*[0;0;d;1];
%hitPoint is the end of the beam.

errVector = targetPoint - hitPoint;
end

