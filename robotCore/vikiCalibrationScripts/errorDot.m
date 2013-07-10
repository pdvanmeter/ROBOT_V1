function [ errVector ] = errorDot( parameterSet, dataSet, d)
fixedRobotPars=modelRobot;
robot=[parameterSet(1:14) fixedRobotPars(6,3) parameterSet(15:18) fixedRobotPars(6,4)];
robot=reshape(robot,[5,4]);
robot=[fixedRobotPars(1,1:4); robot];
theLaser=parameterSet(19:22);
point1=parameterSet(23:25);
translationAngles=parameterSet(26:27);
% Pars (18) Robot Model
% Laser (4) Laser Model
% P (3) lab coordinates of first target point.
% M (2) angles describing the vector pointing from target 1 to target 2.
%Half the data set is for P,
%The other half is for the second point.
%d is the distance between the points.
acts=size(dataSet,1);
errVector=zeros(1,acts);
for i=1:acts
    T=transformRobot(robot,dataSet(i,:))*transformLaser(theLaser);
    P=point1;
    if(i>acts/2)
        P=P-d*[cos(translationAngles(1))*cos(translationAngles(2)) sin(translationAngles(1))*cos(translationAngles(2)) -sin(translationAngles(2))];
    end
    x1=T(1:3,4);
    x2=T*[0;0;1;1];
    x2=x2(1:3);
    P=P';
    %Our error measure is the minimum distance between the target point and
    %the laser ray.
    distance=norm(cross(P-x1,P-x2))/norm(x2-x1);
    errVector(i)=distance;
end
norm(errVector)

end

