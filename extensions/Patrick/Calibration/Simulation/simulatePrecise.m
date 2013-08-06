function [ robotCrashes preCrashJ ] = simulatePrecise( realModel, jSet )
%SIMIULATEPRECISE Function to simulate the full run as moveProtected would
%perform it. Uses a much larger number of keyframes than simulateRun.
%   Incrementally performs the entire run for each set of actuations
%   contained within jSet. This should be identical to how moveProtected
%   calculates the run.

% The resolution of each joint, used to calculate keyframes
Jres = deg2rad([6.79493E-04 6.790161E-04 8.69751E-04 8.987652E-04 1.171112E-03 2.74582E-03]);
preCrashJ = [-1, -1, -1, -1, -1, -1];
robotCrashes = 0;

for n = 1:size(jSet,1)
    % Get current position
    currentJ = realModel.J;
    % Calculate keyframes, adjusting for very small and large movements
    keyframes = round(abs(max((jSet(n,:) - currentJ)./Jres))/1000);         % Rounds to nearest integer
    if keyframes < 15   % Want small movements for accuracy
        keyframes = 15;    % Ensure at least 15
    end
    diff = (jSet(n,:)-currentJ)/keyframes;
    
    % Split into keyframes and move incrementally. Partially stolen from
    % the geometricModel moveJ().
    for t = 1:keyframes
        currentJ = currentJ + diff;
        robotCrashes = realModel.setJ(currentJ);
        if(robotCrashes)
            preCrashJ = currentJ - diff;
            break;
        end
    end
    % Check for failure
    if(robotCrashes)
        fprintf('Error! Simulation has crashed. The model has failed.\n');
        break;
    end
end

end

