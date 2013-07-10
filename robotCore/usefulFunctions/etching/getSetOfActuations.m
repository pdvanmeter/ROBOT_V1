function [Js etchingMask]=getSetOfActuations(robot, tool, points, orientation, setMask, liftMask)
% getSetofActuations  produces actuations for a given set of points.
%   Follow this path to etch the image.

% Set constants and indicies
pointsOutOfRange = 0;
missActuation = 0;
liftDistance = 10; %10mm
targetPose = eye(4,4);
dots = length(points(1,:));
indexToolPts = 1;
etchingMask = [];

% Output number of points
sum(setMask) + sum(liftMask) + length(points)

% Main path loop
for indexDots = 1:dots
    targetPose(1:3,4) = points(1:3,indexDots);
    targetRot = makeTransform(0,0,0,orientation(1),orientation(2),orientation(3));
    targetPose(1:3,1:3) = targetRot(1:3,1:3);
    justFoundSetPoint = false;
    
    if setMask(indexDots)
        tool_away = tool;
        tool_away(5) = tool(5)+liftDistance;
        results = ikineToolPoseAna(targetPose,robot,tool_away);
        
        if results == 0
            results = zeros(8,6);
            pointsOutOfRange = pointsOutOfRange+1;
        end
        
        for che = 1:length(results(:,1))
            goodones(che) = actuationGood(results(che,:));
            realgood = find(goodones);
        end
        
        if isempty(realgood)
            Js(indexToolPts,:) = zeros(1,6);
            missActuation = missActuation+1;
            indexToolPts = indexToolPts+1;
            etchingMask = [etchingMask false];
        else
            Js(indexToolPts,:) = results(6,:);
            indexToolPts = indexToolPts + 1;
            etchingMask = [etchingMask false];
        end
        
        justFoundSetPoint = true;
    end
    
    results = ikineToolPoseAna(targetPose,robot,tool);
    
    if results == 0
        results = zeros(8,6);
        pointsOutOfRange = pointsOutOfRange + 1;
    end
    
    for che = 1:length(results(:,1))
        goodones(che) = actuationGood(results(che,:));
        realgood = find(goodones);
    end
    
    if isempty(realgood)
        Js(indexToolPts,:) = zeros(1,6);
        indexToolPts = indexToolPts + 1;
        missActuation = missActuation + 1;
        
        if justFoundSetPoint
            etchingMask = [etchingMask false];
        else
            etchingMask = [etchingMask true];
        end
    else
        Js(indexToolPts,:) = results(6,:);
        indexToolPts = indexToolPts + 1;
        
        if justFoundSetPoint
            etchingMask = [etchingMask false];
        else
            etchingMask = [etchingMask true];
        end
    end
    
    justFoundSetPoint = false;
    
    if liftMask(indexDots)
        tool_away = tool;
        tool_away(5) = tool(5) + liftDistance;
        results = ikineToolPoseAna(targetPose,robot,tool_away);
        
        if results == 0
            results = zeros(8,6);
            pointsOutOfRange = pointsOutOfRange+1;
        end
        
        for che = 1:length(results(:,1))
            goodones(che) = actuationGood(results(che,:));
            realgood = find(goodones);
        end
        
        if isempty(realgood)
            Js(indexToolPts,:) = zeros(1,6);
            missActuation = missActuation + 1;
            indexToolPts = indexToolPts + 1;
            etchingMask = [etchingMask false];
        else
            Js(indexToolPts,:) = results(6,:);
            indexToolPts = indexToolPts + 1;
            etchingMask = [etchingMask false];
        end
    end
    
end