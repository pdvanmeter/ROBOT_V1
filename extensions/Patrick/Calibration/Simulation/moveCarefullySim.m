function [ robotCrashes ] = moveCarefullySim( realModel, model, actuationGoal )
%MOVECAREFULLYSIM This is a function to break a movement up by joint.
%   This function will move the robot to the desired final position one
%   joint at a time, using an order that is specifically designed to avoid
%   collision. This version is for running a model simulation of the real
%   procedure.
%
%   The function will move the joints in the following order:
%   1. Joint 2
%   2. Joint 3
%   3. Joint 4
%   4. Joint 5
%   5. Joint 6
%   6. Joint 1

%   Generate a jSet which will move in the desired order, then pass it
%   along to moveProtected.
%currentJ = robot.whereJ();             % Full Mode
currentJ = realModel.J;                     % Model Only Model
index = 1;

if (currentJ(2) - actuationGoal(2)) ~= 0
    newSet(index,1:6) = currentJ;
    newSet(index,2) = actuationGoal(2);
    currentJ = newSet(index,1:6);
    index = index +1;
end

if (currentJ(3) - actuationGoal(3)) ~= 0
    newSet(index,1:6) = currentJ;
    newSet(index,3) = actuationGoal(3);
    currentJ = newSet(index,1:6);
    index = index +1;
end

if (currentJ(4) - actuationGoal(4)) ~= 0
    newSet(index,1:6) = currentJ;
    newSet(index,4) = actuationGoal(4);
    currentJ = newSet(index,1:6);
    index = index +1;
end

if (currentJ(5) - actuationGoal(5)) ~= 0
    newSet(index,1:6) = currentJ;
    newSet(index,5) = actuationGoal(5);
    currentJ = newSet(index,1:6);
    index = index +1;
end

if (currentJ(6) - actuationGoal(6)) ~= 0
    newSet(index,1:6) = currentJ;
    newSet(index,6) = actuationGoal(6);
    currentJ = newSet(index,1:6);
    index = index +1;
end

if (currentJ(1) - actuationGoal(1)) ~= 0
    newSet(index,1:6) = currentJ;
    newSet(index,1) = actuationGoal(1);
    currentJ = newSet(index,1:6);
    index = index +1;
end

% If currentJ = actuation
if index == 1
    newSet = currentJ;
end

robotCrashes = moveProtectedSim(realModel, model, newSet);    % Full Mode
%robotCrashes = simulateRun(model, newSet);              % Model Only Mode

end

