% To find the error in the position and orientation of the robot, I follow
% what is done in the paper "An Automated Method to Calibrate Industrial
% Robots Using a Virtual Closed Kinematic Chain" By Gatla etc. (part V) 
% The idea is make two robots, and move one to a pose, then the other to
% the same pose but with the maximum joint error possible. Then take the
% norm of the difference in posistion and orientation.
% From the "RX130 Series Manual" the joint resolutions are;
% Joint   Count's/deg    Resolution (deg)
% 1       1472            6.79e-4
% 2       1472            6.79e-4
% 3       1150            8.69e-4
% 4       1001            9.99e-4
% 5       512             1.95e-3
% 6       364             2.75e-3

sensor=[0,0,0,-80]; %displacement sensor
toolLength=180; %link 6 + displacement sensor + laserbeam at optimal length
robot=modelRobot();
% % Resolution of joints
% joint(1)=deg2rad(6.79e-4);
% joint(2)=deg2rad(6.79e-4);
% joint(3)=deg2rad(8.69e-4);
% joint(4)=deg2rad(9.99e-4);
% joint(5)=deg2rad(1.95e-3);
% joint(6)=deg2rad(2.75e-3);
% Measured Error in Joints
jointE=deg2rad([-3.1071e-05;
    -2.3871e-05;
    -2.5616e-05;
    -4.7744e-05;
    -1.41205e-05;
    -2.00512e-05;]);
jointStd=deg2rad(1e-3*[0.3107;
    0.3942;
    0.2854;
    0.3607;
    0.3603;
    0.8864]);

% Resolution of displacement reader
laserError=4e-3;

for i=1:30000
    workSpaceAct=randomActuation();
    perfectPose=transformRobot(robot,workSpaceAct)*transformTool(sensor,toolLength);
    ErrorAct=workSpaceAct+normrnd(jointE',jointStd');
    maxErrorLength=toolLength+laserError;
    maxErrorPose=transformRobot(robot,ErrorAct)*transformTool(sensor,maxErrorLength);
    normalO(i)=norm(maxErrorPose(1:3,4)-perfectPose(1:3,4));
    normalR(i)=norm(matrixToAngles(perfectPose)-matrixToAngles(maxErrorPose));
end
meanO=mean(normalO)
stdvO=std(normalO)
meanR=(mean(normalR))
stdvR=(std(normalR))
