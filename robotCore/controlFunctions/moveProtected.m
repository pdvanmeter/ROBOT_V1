function [results robotCrashes] = moveProtected( robot, model, jSet, action )
%MOVEPROTECTED Function to integrate crash protection and movement.
%   This function will take a set of actuations (jSet) and move the robot
%   to these points in a protected fashion. The crash protection will be
%   achieved by alternating movements of the model with movements of the
%   actual RX130 robot over small increments until each target within jSet
%   is met. Then, if supplied, the robot will perform the requested action
%   (passed as a function handle with the robot as an argument and which returns an
%   arbitrary results array). This function returns all of
%   those results as a 2-D matrix, with the first index specifying the
%   action number.

% The resolution of each joint, used to calculate keyframes
Jres = deg2rad([6.79493E-04 6.790161E-04 8.69751E-04 8.987652E-04 1.171112E-03 2.74582E-03]);

for n = 1:size(jSet,1)
    % Correct for any variance robot/model position
    currentJ = robot.whereJ();
    model.setJ(currentJ);
    % Calculate keyframes, adjusting for very small and large movements
    keyframes = round(max(abs((jSet(n,:) - currentJ)./Jres))/1000);         % Rounds to nearest integer
    if keyframes < 1        % Tiny movement, needs at least one frame
        keyframes = 1;                                                      % Ensure at least one frame
    elseif keyframes > 20   % Big movement, requires less precision
        keyframes = round(max(abs((jSet(n,:) - currentJ)./Jres))/4000);    % Reduce number of steps
    end
    diff = (jSet(n,:)-currentJ)/keyframes;
    
    % Split into keyframes and move incrementally. Partially stolen from
    % the geometricModel moveJ().
    for t = 1:keyframes
        currentJ = currentJ + diff;
        robotCrashes = moveRobot(robot, model, currentJ);
        if(robotCrashes)
            break;
        end
    end
    % Check for failure
    if(robotCrashes)
        fprintf('Error! Simulation has crashed. Robot movement has been halted for safety.\n');
        results = [-1,-1,-1,-1,-1,-1,-1];
        break;
    end
    % If we have reached a target, perform the action (if there is one)
    if exist('action','var')
        results(n,:) = action(robot);        % Unsupress to show results/progress
    else
        results = [0,0,0,0,0,0,0];
    end
end

end

