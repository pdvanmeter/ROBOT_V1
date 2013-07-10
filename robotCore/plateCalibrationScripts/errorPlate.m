function [ errorVector ] = errorPlate(parameterSetMaster, fixedPars, dataSetMaster)
% this function returns the error for the given parameter set (dh+sensor+
% plate(position and orientation)) The fixed parameters are given by
% definition, the are the first dh parameters and some sensor parameters.
% An important note is that this function fits for the spheres and the
% position of the spheres all at once. Thus, in order for this function to
% work, one must know very precisly the relative positions of the spheres
% and their radii.

% Identify the amount of data collected
numplatePoses=(length(parameterSetMaster)-24)/6; %identify the number of plate poses
planePoints=modelPlate(); % retrive the plate model
numPlatePoints= length(planePoints); % number of spheres
numMeasPoses=length(dataSetMaster)*numplatePoses/(numPlatePoints*numplatePoses);%poses/sphere
errorVector =zeros(numplatePoses*numPlatePoints*numMeasPoses,1); %initialize error Vector

%unpack the parameters
robot=[parameterSetMaster(1:14) fixedPars(5) parameterSetMaster(15:18) fixedPars(6)]; 
robot=reshape(robot,[5,4]);
robot=[fixedPars(1:4); robot];
sensor=parameterSetMaster(19:23);
sensorScale=parameterSetMaster(24);
radius=fixedPars(7);
sensorScaleOffset=fixedPars(8);

indexError=1;
for pos=1:numplatePoses
    dataSet=dataSetMaster(:,7*pos-6:7*pos);
    O=parameterSetMaster(25+6*pos-6:25+6*pos-4);
    R=parameterSetMaster(28+6*pos-6:28+6*pos-4);
    
    i=1;
    planeToLab=makeTransform(O(1),O(2),O(3),R(1),R(2),R(3));
    %for each sphere find the error in the predicted vs the measured laser distance
    for k=1:numPlatePoints 
        planePoint = planePoints(:,k);
        sphereCenter = planeToLab*planePoint;
%         For each pose of the sensor, measure the error in the theoretical distance to
%         the sphere, and the measured distance to the sphere
        for n=1:numMeasPoses;
            
            %Part 2: Do the forward kinematics with J, theRobot, and
            % theSensor to find the laser impact point.
                x_0=sphereCenter(1);
                y_0=sphereCenter(2);
                z_0=sphereCenter(3);
                measuredLaserLength=sensorScale*(dataSet(i,7)-sensorScaleOffset);
                sensorPose=transformRobot(robot,dataSet(i,1:6))*transformTool(sensor)*transXYZ(0,0,measuredLaserLength);
                x=sensorPose(1,4);
                y=sensorPose(2,4);
                z=sensorPose(3,4);
%                 errorCenter calculates the distance between the laser dot
%                 measured on the surface, and the theoretical laser dot on
%                 the surface
                errorCenter=(x-x_0)^2+(y-y_0)^2+(z-z_0)^2-radius^2;
                if ~isreal(dataSet(i,7))
                    errorCenter=0; %this is for modeling use only, It ignores the data when the sensor does not actually hit the sphere. (see collectData)
                end
                if dataSet(i,1:6)==zeros(1,6)
                    errorCenter=0; %this is for modeling use only, eliminating when the point is out of range (see collectData and ikineToolPoseAna)
                end
                %Part 3: Return the residue
                errorVector(indexError)=errorCenter;
                i=i+1;
                indexError=indexError+1;
            
        end
        
    end
    
end
    norm( errorVector)^2 % dump this to the screen each funEval. (it's just interesting to see)

end
