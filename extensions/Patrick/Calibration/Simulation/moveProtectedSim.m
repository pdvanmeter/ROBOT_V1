function [ results robotCrashes ] = moveProtectedSim( realModel, model, jSet, action )
%MOVEPROTECTEDSIM Performs a direct simulation of the RX130/geometricModel
%interaction by using a high resolution model.
%   This code should be kept nearly identical to moveProtected.

% The resolution of each joint, used to calculate keyframes
Jres = deg2rad([6.79493E-04 6.790161E-04 8.69751E-04 8.987652E-04 1.171112E-03 2.74582E-03]);

for n = 1:size(jSet,1)
    % Correct for any variance robot/model position
    currentJ = realModel.J;
    model.setJ(currentJ);
    % Calculate keyframes, adjusting for very small and large movements
    keyframes = round(abs(max((jSet(n,:) - currentJ)./Jres))/1000);         % Rounds to nearest integer
    if keyframes < 1        % Tiny movement, needs at least one frame
        keyframes = 1;                                                      % Ensure at least one frame
    elseif keyframes > 20   % Big movement, requires less precision
        keyframes = round(abs(max((jSet(n,:) - currentJ)./Jres))/3000);    % Reduce number of steps
    end
    diff = (jSet(n,:)-currentJ)/keyframes;
    
    % Split into keyframes and move incrementally. Partially stolen from
    % the geometricModel moveJ().
    for t = 1:keyframes
        currentJ = currentJ + diff;
        robotCrashes = moveModels(realModel, model, currentJ);
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
        results(n,:) = action(realModel);        % Unsupress to show results/progress
    else
        results = [0,0,0,0,0,0,0];
    end
end

end

