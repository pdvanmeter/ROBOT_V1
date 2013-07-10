function [ err ] = errorEmre(Measurements, robotPars, sensorPars, C, y,p,r)
%Invariants:
SphereGridPlaneFrame = [0 10 20 30 30 30 20 10 0 0;
                        0 0 0 0 6.5 13 13 13 13 6.5;
                        0.0 0.0  0.0 0.0 .005 .005 .005 .005 .005 .005
                        1   1    1    1    1   1    1    1    1    1]

SphereGridPlaneFrame = [SphereGridPlaneFrame(1:3,:)*25.4;ones(1,10)]
SphereRadius = 6.35;

SphereCount = size(Measurements,2);
DataPointsPerSphere = size(Measurements,3);
impactPoint = zeros(4,SphereCount);

jointMatrix=transXYZ(C(1),C(2),C(3))*rotZ(y)*rotY(p)*rotZ(r)
%Pick a point on each sphere, and then solve for the J,d needed to hit it
%with the laser.
SphereGridLabFrame=jointMatrix*SphereGridPlaneFrame
err = zeros(1,SphereCount*DataPointsPerSphere);
for i=1:SphereCount
    for j=1:DataPointsPerSphere
    %Derive the center of this sphere
    impactPoint(:,i,j) = transformRobot(robotPars, Measurements(1:6,i,j))*transformTool(sensorPars)*[0;0;Measurements(7,i,j);1];
    %impactPoint(:,i) = transformRobot(modelRobot(), SurfacePointSolutions(1:6,i))*[0;0;SurfacePointSolutions(7,i);1];
    err((i-1)*DataPointsPerSphere+j )= norm(impactPoint(1:3,i,j) - SphereGridLabFrame(1:3,i),2) - SphereRadius
    end
    
end

