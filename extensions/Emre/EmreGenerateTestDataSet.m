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
%yaw, pitch, roll
y=pi/2;
p=0;
r=0;

jointMatrix=transXYZ(C(1),C(2),C(3))*rotZ(y)*rotY(p)*rotZ(r)
%Pick a point on each sphere, and then solve for the J,d needed to hit it
%with the laser.
SphereGridLabFrame=jointMatrix*SphereGridPlaneFrame

DataPointsPerSphere=4;

SphereCount = size(SphereGridLabFrame,2);
SurfacePoint=ones(3,SphereCount,DataPointsPerSphere);
SphereRadius=6.35;

CenterPoint = ones(4,SphereCount,DataPointsPerSphere);


for i=1:SphereCount
for j=1:DataPointsPerSphere
    CenterPoint(1:3,i,j)=SphereGridLabFrame(1:3,i);
    dirVector= rand(3,1);
    dirVector= dirVector / norm(dirVector,2);
    SurfacePoint(:,i,j) = CenterPoint(1:3,i,j) + SphereRadius*dirVector;
end
end
SurfacePointSolutions = zeros(7,SphereCount);

J =  [-0.229685329562454
       -0.0996233937038363
          2.07055390481095
                         0
          1.17064468919016
         -1.38090450417791
         60]';

 for i=1:SphereCount
     for j=1:DataPointsPerSphere
    %SurfacePointSolutions(:,i)= ikineToolPosition([SurfacePoint(:,i);1], modelRobot(),modelSensor(),J)
    %Find a solution for which 
    %SurfacePointSolutions(:,i)= ikineToolPosition([SurfacePoint(:,i);1], modelRobot(),modelSensor(),J)
     z_axis= [SurfacePoint(:,i,j)] - CenterPoint(1:3,i,j);
     z_axis=-z_axis/norm(z_axis,2)

     targetPose = [1 0;
                  0 1;
                  0 0;
                  0 0];
    targetPose= [targetPose [z_axis; 0]];
    targetPose= [targetPose [SurfacePoint(:,i,j);1]]
    
    %Turn the following line back on to hit the sphere at normal incidence.
    %SurfacePointSolutions(:,i)= ikineToolPose(targetPose, modelRobot(),modelSensor(),J)
    
    %The following hits the sphere at arbitrary incidence.
    SurfacePointSolutions(:,i,j)= ikineToolPosition([SurfacePoint(:,i,j);1], modelRobot(),modelSensor(),J)
     end
    
end
%pause;
%Given the data and the parameters, compute the error.
impactPoint = zeros(4,SphereCount,DataPointsPerSphere)
err = zeros(1,SphereCount*DataPointsPerSphere)
for i=1:SphereCount
    for j=1:DataPointsPerSphere
    %Derive the center of this sphere
    SurfacePointSolutions(:,i,j);
    impactPoint(:,i,j) = transformRobot(modelRobot(), SurfacePointSolutions(1:6,i,j))*transformTool(modelSensor())*[0;0;SurfacePointSolutions(7,i,j);1];
    %impactPoint(:,i) = transformRobot(modelRobot(), SurfacePointSolutions(1:6,i))*[0;0;SurfacePointSolutions(7,i);1];
    err((i-1)*DataPointsPerSphere+j)= norm(impactPoint(1:3,i,j) - CenterPoint(1:3,i,j),2) - SphereRadius
end
end
%functionError = errorEmre(SurfacePointSolutions, modelRobot(), modelSensor(), C, y,p,r)
pause;
fitParams = zeros(1,29);
robPars = modelRobot();
fitParams(1:24)=reshape(robPars,1,24);
fitParams(25:29)=reshape(modelSensor(),1,5);
fitParams(30:32)=C(1:3)';
fitParams(33:35)=[y p r];
fitParams=fitParams;
%function [ err ] = errorEmre(Measurements, robotPars, sensorPars, C, y,p,r)

modelError=@(x)errorEmre(SurfacePointSolutions, reshape(x(1:24),6,4), reshape(x(25:29),1,5), reshape(x(30:32),1,3),x(33) ,x(34),x(35))
%modelError=@(x)errorEmre(SurfacePointSolutions, modelRobot(), modelSensor(), C,y ,p,r)
options=optimset('MaxFunEvals',10000000,'MaxIter',10000000,'Algorithm',{'levenberg-marquardt',1e-51},'Display','off');
theFit = lsqnonlin(modelError,fitParams,[],[],options);
theFit
reshape(theFit(1:24),6,4) - (modelRobot())
%CenterPoint(:,1)
%SurfacePoint(:,1)
%norm(CenterPoint(1:3,1)-SurfacePoint(1:3,1),2)


