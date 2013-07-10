function [ errVector ] = errorToolPosition( dataPacket,targetPoint, robotParameters, toolParameters,varargin)
if nargin<5
    %Computes the error in the laser dot position.
    %Use this if you want to hit a certain spot with the laser and all
    %orientations are allowed.
    
    %dataPacket: J[6] d [1]
    J=dataPacket(1:6);
    d=dataPacket(7);
    %The robot (modeled by robotParameters) has actuation J.
    %The laser (whose mount is modeled by laserParameters) has beam length d.
    
    T = transformRobot(robotParameters,J) * transformLaser(toolParameters);
    hitPoint = T*[0;0;d;1];
    %hitPoint is the end of the beam.
    
    errVector = targetPoint - hitPoint;
else
    initialGuess=varargin{1};
    variableJoints=varargin{2}{1};
    J=zeros(1,6);
%     index=1;
    varIndex=1;
    for i=1:6
        if (varIndex<=numel(variableJoints))&&(variableJoints(varIndex)==i)
            J(i)=dataPacket(varIndex);
            varIndex=varIndex+1;
        else
            J(i)=initialGuess(i);
        end
    end
    d=dataPacket(end);
    %The robot (modeled by robotParameters) has actuation J.
    %The laser (whose mount is modeled by laserParameters) has beam length d.
    
    T = transformRobot(robotParameters,J) * transformLaser(toolParameters);
    hitPoint = T*[0;0;d;1];
    %hitPoint is the end of the beam.
    
    errVector = targetPoint(1:3) - hitPoint(1:3);
%     norm(errVector)
end

