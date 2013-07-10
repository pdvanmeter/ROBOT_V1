function [dataSet pointsOutOfRange missSphere missActuation  missWhichSphere missWhichActuation errorVector ] = collectData(mover, parameterSet, fixedPars, plate,d_plate,actualParameterSet)
robot=[parameterSet(1:14) fixedPars(5) parameterSet(15:18) fixedPars(6)];
robot=reshape(robot,[5,4]);
robot=[fixedPars(1:4); robot];
sensor=parameterSet(19:23);
sensorScaleOffset=fixedPars(8);
radius=fixedPars(7);

numplatePoses=(length(parameterSet)-24)/6;
for pos=1:numplatePoses
    origin=parameterSet(25+6*pos-6:25+6*pos-4);
    orientation=parameterSet(28+6*pos-6:28+6*pos-4);
end
for pos=1:numplatePoses
    d_origin=actualParameterSet(25+6*pos-6:25+6*pos-4);
    d_orientation=actualParameterSet(28+6*pos-6:28+6*pos-4);
end



theRobot=[actualParameterSet(1:14) fixedPars(5) actualParameterSet(15:18) fixedPars(6)];
theRobot=reshape(theRobot,[5,4]);
theRobot=[fixedPars(1:4); theRobot];
theSensor=actualParameterSet(19:23);
d_sensorScale=actualParameterSet(24);

planeToLab=makeTransform(origin(1),origin(2),origin(3),orientation(1),orientation(2),orientation(3));
d_planeToLab=makeTransform(d_origin(1),d_origin(2),d_origin(3),d_orientation(1),d_orientation(2),d_orientation(3));

numPlatePoints=length(plate(1,:));
dataSet = zeros(numPlatePoints,7);
targetPoint=zeros(4,numPlatePoints);
d_targetPoint=zeros(4,numPlatePoints);

retreatPlate=plate;
retreatPlate(3,:)=10*ones(1,numPlatePoints);

for k=1:numPlatePoints,
    targetPoint(:,k)= planeToLab*plate(:,k);
    retreatPoint(:,k)=planeToLab*retreatPlate(:,k);
    d_targetPoint(:,k)= d_planeToLab*d_plate(:,k);
end

dataPoints=1;
missSphere=0;
missActuation=0;
missWhichActuation=[];
pointsOutOfRange=0;
missWhichSphere=[];
for k=1:numPlatePoints,
    targetPose=makeTransform(targetPoint(1,k), targetPoint(2,k), targetPoint(3,k), 0,0,0);
    retreatPose=makeTransform(retreatPoint(1,k), retreatPoint(2,k), retreatPoint(3,k), 0,0,0);
    d_targetPose=makeTransform(d_targetPoint(1,k), d_targetPoint(2,k), d_targetPoint(3,k), 0,0,0);
    p=1;
    for m=-1:2:1
        for n=-1:1:1
            for r=1:4
                for q=1:4
                    %             r=round(rand*4);
                    %             q=round(rand*4);
                    s_targetPose=targetPose;
                    rotXYZ=rotX(m*pi()/(6))*rotY(n*pi/(6))*rotZ(q*2*pi/4);
                    targetRot =makeTransform(0,0,0,orientation(1),orientation(2),orientation(3))*rotY(pi)*rotXYZ;
                    s_targetPose(1:3,1:3)=targetRot(1:3,1:3);
                    results = ikineToolPoseAna(s_targetPose,robot,sensor,(r-1)*10);
                    if results==0
                        results=zeros(8,6);
                        pointsOutOfRange=pointsOutOfRange+1;
                    end
                    for che=1:length(results(:,1))
                        goodones(che)=actuationGood(results(che,:));
                        realgood=find(goodones);
                    end
                    if isempty(realgood)
                        J=zeros(1,6);
                        missActuation=missActuation+1;
                        missWhichActuation=[missWhichActuation dataPoints];
                    else
                        
                        J=normrnd(results(6,:),deg2rad(0.001)/2); %Add noise
%                         J=results(6,:);
%                         if J~=zeros(1,6)
%                             mover.moveJ(J);
%                         end
                    end
                    actualPose=transformRobot(theRobot,J)*transformTool(theSensor);
                    actualMeasuredLaserLength=(d_targetPose(1:3,4)-actualPose(1:3,4))'*actualPose(1:3,3)-sqrt(((d_targetPose(1:3,4)-actualPose(1:3,4))'*actualPose(1:3,3))^2-(actualPose(1:3,4)-d_targetPose(1:3,4))'*(actualPose(1:3,4)-d_targetPose(1:3,4))+radius^2);
                    if ~isreal(actualMeasuredLaserLength)
                        actualMeasuredLaserLength
                        missWhichSphere=[ missWhichSphere k];
                        missSphere=missSphere+1
                        
                    end
                    recordedLength=actualMeasuredLaserLength/d_sensorScale+sensorScaleOffset;
                    recordedLength=normrnd(recordedLength,2);
                    recordedLength=round(recordedLength);
                    %                             recordedLength=micro.getReading();
                    dataSet(dataPoints,:)=[J recordedLength];
                    
                    
                    [k dataPoints]
                    
                    x_0=targetPoint(1,k);
                    y_0=targetPoint(2,k);
                    z_0=targetPoint(3,k);
                    Zmagnitude=d_sensorScale*(dataSet(dataPoints,7)-sensorScaleOffset);
                    sensorPose=transformRobot(theRobot,dataSet(dataPoints,1:6))*transformTool(theSensor)*transXYZ(0,0,Zmagnitude);
                    x=sensorPose(1,4);
                    y=sensorPose(2,4);
                    z=sensorPose(3,4);
                    errorCenter=(x-x_0)^2+(y-y_0)^2+(z-z_0)^2-radius^2;
                    if ~isreal(dataSet(dataPoints,7))
                        errorCenter=0;
                    end
                    if dataSet(dataPoints,1:6)==zeros(1,6)
                        errorCenter=0;
                    end
                    %Part 3: Return the residue
                    errorVector(dataPoints)=errorCenter;
                    
                    dataPoints=dataPoints+1;
                    
%                     retreatPose(1:3,1:3)=targetRot(1:3,1:3);
%                     results = ikineToolPoseAna(retreatPose,robot,sensor,d+(r-1)*10);
%                     if results==0
%                         results=zeros(8,6);
%                         missActuation=missActuation+1;
%                     end
%                     for che=1:length(results(:,1))
%                         goodones(che)=actuationGood(results(che,:));
%                         realgood=find(goodones);
%                     end
%                     if isempty(realgood)
%                         J=zeros(1,6);
%                     else
%                         J=results(realgood(end),:);
%                         if J~=zeros(1,6)
%                             mover.moveJ(J);
%                         end
%                     end
                    
                end
            end
            
        end
    end
end
end