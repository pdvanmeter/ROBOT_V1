% Script to do a quick run-through of the test points

%load('C:\Users\wberry\Documents\MATLAB\ROBOT_V1\extensions\Patrick\Calibration\goodJset.mat')
currentPosition = model.Home;
model.setJ(model.Home);
jSet = goodJset(:,1:6);
counter = 0;

for n = 1:size (jSet,1)
    %model.moveJ(currentPosition,jSet(n,:));
    %simulateRun(model, jSet(n,:));
    if abs(currentPosition(1) - jSet(n,1)) > pi/2
        moveCarefully(counter,model,model.Home);
        nextPosition = [jSet(n,1), model.Home(2:6)];
        moveCarefully(counter,model,nextPosition);
        %[results(n,:) robotCrashed] = moveProtected(robot, model, jset(n,:), @takeMeasurement);
        robotCrashed = simulateRun(model, jSet(n,:));
    else
        %[results(n,:) robotCrashed] = moveProtected(robot, model, jset(n,:), @takeMeasurement);
        robotCrashed = simulateRun(model, jSet(n,:));
    end
    
    % If we have finished a sphere cluster, back off a bit
    if goodJset(n,7) ~= goodJset(n+1,7) || goodJset(n,8) ~= goodJset(n+1,8)
        %
    else
        currentPosition = jSet(n,:);
    end
    
    counter = n;
end