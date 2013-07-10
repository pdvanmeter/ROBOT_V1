function toolPose=whereTool(robotObj,StandardRobotPars,toolPars, toolLength)
% returns the pose of the tool
[J R]=robotObj.where();
toolPose=transformRobotSt(StandardRobotPars,J)*transformTool(toolPars,toolLength);
end