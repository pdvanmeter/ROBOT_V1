function [ errorVector ] = errorToolPose(J, targetTransform, robotPars, toolPars)
%Use this if you want to do inverse kinematics the same way the controller
%does.
T = transformRobot(robotPars,J)*transformTool(toolPars);
errorVector = T-targetTransform;
end
