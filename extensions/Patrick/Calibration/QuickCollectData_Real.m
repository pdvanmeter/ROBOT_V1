% Script to do a quick run-through of the test points

%load('C:\Users\wberry\Documents\MATLAB\ROBOT_V1\extensions\Patrick\Calibration\goodJset.mat')
robot.runCmd('do ready');
currentPosition = robot.whereJ();
model.setJ(currentPosition);
jSet = goodJset(:,1:6);
crashN = 0;
crashCount = 0;

for n = 1:size (jSet,1)
    % For big movements, return home first. Otherwise, try to go.
    if abs(currentPosition(1) - jSet(n,1)) > pi/2
        % Carefully adjust
        % Joint 2
        currentPosition = robot.whereJ();
        if currentPosition(2) < -pi/2
            backJ = robot.whereJ() + [0,0.6,0,0,0,0];
        else
            backJ = robot.whereJ() - [0,0.6,0,0,0,0];
        end
        % Joint 5
        backJ(5) = model.Home(5);
        moveCarefully(robot,model,backJ);
        model.moveJ(model.Home);
        nextPosition = [jSet(n,1), model.Home(2:6)];
        %moveCarefully(robot,model,nextPosition);
        robot.moveJ(nextPosition);
        [results(n,1:7) robotCrashed] = moveProtected(robot, model, jSet(n,:), @takeMeasurement);
        %[robotCrashed preCrashJ] = simulateRun(model, jSet(n,:));
    else
        [results(n,1:7) robotCrashed] = moveProtected(robot, model, jSet(n,:), @takeMeasurement);
        %[robotCrashed preCrashJ] = simulateRun(model, jSet(n,:));
    end
    
    % If we have finished a sphere cluster, back off a bit
    % Otherwise, just update the current position
    if ~robotCrashed && (goodJset(n,7) ~= goodJset(n+1,7) || goodJset(n,8) ~= goodJset(n+1,8))
       backJ = model.J + [0,0.05,0,0,0,0];
       %[robotCrashed preCrashJ] = simulateRun(model, backJ);
       moveProtected(robot,model,backJ);
       currentPosition = robot.whereJ();
    elseif ~robotCrashed
        currentPosition = model.J;
    else
        % A crash has occured! Back up and try again.
        fprintf('A model collision (%d) has ocurred. Returning to the previous position to try again\n',n);
        beep;
        % Move the second joint "up"
        currentPosition = robot.whereJ();
        if currentPosition(2) < -pi/2
            backJ = robot.whereJ() + [0,0.2,0,0,0,0];
        else
            backJ = robot.whereJ() - [0,0.2,0,0,0,0];
        end
        % Move the fifth joint "straight"
        if currentPosition(5) < 0
            backJ = backJ + [0,0,0,0,0.3,0];
        else
            backJ = backJ - [0,0,0,0,0.3,0];
        end
        model.setJ(robot.whereJ());
        %[robotCrashed preCrashJ] = simulateRun(model, backJ);
        moveProtected(robot,model,backJ);
        %currentPosition = model.J;
        model.setJ(robot.whereJ());
        if crashN == n && CrashCount > 2
            fprintf('Crashed again, skip the data point.');
            results(n,:) = zeros(size(results,2));
            crashCount = 0;
            n = n + 1;
        elseif crashN == n
            crashCount = crashCount + 1;
        else
            crashCount = 1;
        end
        crashN = n;
        n = n - 1;
    end
    % Add sphere number
    results(n,8) = goodJset(n,8);
end