function [ robotCrashes ] = moveRobot( robot, model, actuation )
%MOVEROBOT Function to unify the movement of the model and the robot.
%   Returns a 1 (true) if the robot has crashed.

[robotCrashes] = model.setJ(actuation);
if(~robotCrashes)
    robot.moveJ(actuation);
end

end

