function [ errorVector ] = errorRobotPose(J, targetTransform, theRobot)
%Use this if you want to do inverse kinematics the same way the controller
%does.
T = transformRobot(theRobot,J);
errorVector = T-targetTransform;
end
