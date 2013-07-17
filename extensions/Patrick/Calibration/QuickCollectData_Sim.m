% Script to do a quick run-through of the test points

%load('C:\Users\wberry\Documents\MATLAB\ROBOT_V1\extensions\Patrick\Calibration\goodJset.mat')
currentPosition = model.Home;
model.setJ(model.Home);
jSet = goodJset(:,1:6);
crashN = 0;

for n = 1:size (jSet,1)
    %model.moveJ(currentPosition,jSet(n,:));
    %simulateRun(model, jSet(n,:));
    if abs(currentPosition(1) - jSet(n,1)) > pi/2
        moveCarefully(n,model,model.Home);
        nextPosition = [jSet(n,1), model.Home(2:6)];
        moveCarefully(n,model,nextPosition);
        %[results(n,:) robotCrashed] = moveProtected(robot, model, jset(n,:), @takeMeasurement);
        [robotCrashed preCrashJ] = simulateRun(model, jSet(n,:));
    else
        %[results(n,:) robotCrashed] = moveProtected(robot, model, jset(n,:), @takeMeasurement);
        [robotCrashed preCrashJ] = simulateRun(model, jSet(n,:));
    end
    
    % If we have finished a sphere cluster, back off a bit
    % Otherwise, just update the current position
    if ~robotCrashed && (goodJset(n,7) ~= goodJset(n+1,7) || goodJset(n,8) ~= goodJset(n+1,8))
       backJ = model.J + [0,0.05,0,0,0,0];
       [robotCrashed preCrashJ] = simulateRun(model, backJ);
       %moveProtected(robot,model,backJ);
       currentPosition = model.J;
    elseif ~robotCrashed
        currentPosition = model.J;
    else
        % A crash has occured! Back up and try again.
        fprintf('A major collision has ocurred. Returning to the previous position to try again\n');
        model.setJ(preCrashJ);
        %model.setJ(robot.wehreJ());
        backJ = model.J + [0,0.05,0,0,0,0];
        [robotCrashed preCrashJ] = simulateRun(model, backJ);
        %moveProtected(robot,model,backJ);
        currentPosition = model.J;
        if crashN == n
            fprintf('Crashed again, skip the data point.');
            % results(n,:) = zeros(size(results,2));
            n = n + 1;
        end
        crashN = n;
        n = n - 1;
    end
end