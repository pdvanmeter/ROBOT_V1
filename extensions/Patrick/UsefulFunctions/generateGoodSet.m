function [ good_set ] = generateGoodSet(x,y,z,yaw,pitch,roll,toolLength)
%Creates a good set of actuations based on input parameters.
%   All rows in the returned matrix should be good actuations.

% Create position matrix
tp = makeTransform(x,y,z,yaw,pitch,roll);
pose = ikineToolPoseAna(tp, modelRobot, modelLaser, toolLength);

% Generate a set of only good actuations
good_set = goodSet(pose);

end

