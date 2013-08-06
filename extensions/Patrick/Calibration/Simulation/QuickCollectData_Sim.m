% Script to do a quick run-through of the test points. This performs a
% simulated version only.

% Required objects in memory:
% 1. model = geometricModel();
% 2. realModel = geometricModel();
% 3. load('C:\Users\wberry\Documents\MATLAB\ROBOT_V1\extensions\Patrick\Calibration\goodJset.mat');
%   or similar set of the same name.

realModel.setJ(realModel.Home);
currentPosition = realModel.J;
model.setJ(currentPosition);
jSet = goodJset(:,1:6);

for n = 1:size(jSet,1)
    % For big movements, return home first. Otherwise, try to go.
    currentPosition = realModel.J;
    if abs(currentPosition(1,1) - jSet(n,1)) > pi/2
        % Carefully adjust: Joint 2
        if currentPosition(2) < -pi/2 && n ~= 1
            backJ = realModel.J + [0,0.6,0,0,0,0];
        elseif n ~= 1
            backJ = realModel.J - [0,0.6,0,0,0,0];
        else
            backJ = realModel.J;
        end
        % Joint 5
        backJ(5) = model.Home(5);
        moveCarefullySim(realModel,model,backJ);
        %realModel.moveJ(model.Home);
        simulatePrecise(realModel,model.Home);
        nextPosition = [jSet(n,1), model.Home(2:6)];
        %realModel.moveJ(nextPosition);
        simulateRun(realModel,nextPosition);
        [results(n,1:7) robotCrashed] = moveProtectedSim(realModel, model, jSet(n,:), @simMeasurement);
        %[robotCrashed preCrashJ] = simulateRun(model, jSet(n,:));
    else
        [results(n,1:7) robotCrashed] = moveProtectedSim(realModel, model, jSet(n,:), @simMeasurement);
        %[robotCrashed preCrashJ] = simulateRun(model, jSet(n,:));
    end
    
    % If we have finished a sphere cluster, back off a bit
    % Otherwise, just update the current position
    if ~robotCrashed && (goodJset(n,7) ~= goodJset(n+1,7) || goodJset(n,8) ~= goodJset(n+1,8))
       backJ = model.J + [0,0.05,0,0,0,0];
       %[robotCrashed preCrashJ] = simulateRun(model, backJ);
       moveProtectedSim(realModel,model,backJ);
       currentPosition = realModel.J;
    elseif ~robotCrashed
        currentPosition = realModel.J;
    else
        crashCount = 1;
        while robotCrashed && crashCount < 3
            % A crash has occured! Back up and try again.
            fprintf('A model collision (%d) has ocurred. Returning to the previous position to try again\n',n);
            beep;
            
            % Move the second joint "up"
            currentPosition = realModel.J;
            if currentPosition(2) < -pi/2
                backJ = realModel.J + [0,0.2,0,0,0,0];
            else
                backJ = realModel.J - [0,0.2,0,0,0,0];
            end
%             % Move the fifth joint "straight"
%             if currentPosition(5) < 0
%                 backJ = backJ + [0,0,0,0,0.3,0];
%             else
%                 backJ = backJ - [0,0,0,0,0.3,0];
%             end
            model.setJ(realModel.J);
            %[robotCrashed preCrashJ] = simulateRun(model, backJ);
            [trash robotCrashed] = moveProtectedSim(realModel,model,backJ);
            currentPosition = realModel.J;
            simulatePrecise(realModel,[currentPosition(1:4), model.Home(5), currentPosition(6)]);
            simulatePrecise(realModel,[currentPosition(1:4),model.Home(5),jSet(n,6)]);
            currentPosition = realModel.J;
            model.setJ(realModel.J);
            
            if robotCrashed
                fprintf('Crashed again, this is a problem. Try to skip it\n');
                results(n,:) = zeros(size(results,2));
                break;
            end
            
            % Try to make the correct movement again
            [results(n,1:7) robotCrashed] = moveProtectedSim(realModel, model, jSet(n,:), @simMeasurement);
            if robotCrashed
                crashCount = crashCount + 1;
            else
                crashCount = 0;
            end
        end
    end
    
    % Add sphere number
    results(n,8) = goodJset(n,8);
    % Save every 5 data points - Not necessary for this simulation.
    %if mod(n,5) == 0
    %    save('results.mat');
    %end
    
    fprintf('Now finished data point %d\n',n);
end