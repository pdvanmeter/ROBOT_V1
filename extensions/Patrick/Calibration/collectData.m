% Script to automate the data collection process. It will take a set of
% actuations (that ideally have already passed the testJs function or some
% similar test) and use the protected movement function to transition from
% point-to-point while taking data. Since we do not currently have a
% completed trajectory planning algorithm, we used a series of
% careful instructions in order to deal with potential crashes. The entire process
% is split up into "clusters", sorted by spheres and pose number. Each pose is given
% a "default" position of the correct orientation (and somewhat raised
% above the table), and upon simulated collision the protected movement
% function will move to this position then attempt to salvage the point. If
% it cannot be done, the point will be recorded as all 0's. Furthermore,
% the arm will always move to a default position before beginning a new cluster.

% Prerequisites: Items in Memory
% 1. robot = RX130('COM6');
% 2. model = geometricModel();

load('C:\Users\wberry\Documents\MATLAB\ROBOT_V1\extensions\Patrick\Calibration\safeSpots.mat')
load('C:\Users\wberry\Documents\MATLAB\ROBOT_V1\calibrationData\PJs.mat')

badPoses = [1,2,7,8];       % Bad poses which should be filtered out
jSet = PJs;                 % Change the name here for a different set

% Create the test point matrix, organized by pose and sphere. Clusters are
% defined as the collection of all points with the same pose and sphere
% number.
% testPointMatrix(i,j,k) will take on the following form:
% i = cluster number (variable size)
% j = point number within cluster (variable size)
% k = individual data (size = 8)
%   - 1-6 is actuation of each joint
%   - 7 is pose #
%   - 8 is sphere #
previousCluster = [1,1];
i = 1;                      % Indices for arranging clusters. Bad style, but easiest
j = 1;                      % way to permit unprescribed, uneven cluster sizes.

for n = 1:size(jSet,1)
    % Filter out bad poses by comparison
    if ~isempty(find(badPoses == jSet(n,7)))
        % If the pose or sphere number changes, begin a new set
        thisCluster = [jSet(n,7), jSet(n,8)];
        if thisCluster(1) ~= previousCluster(1) || thisCluster(2) ~= previousCluster(2)
            i = i + 1;
            previousCluster = thisCluster;
            j = 1;
        end
        
        % Add the current element to its proper spot in the matrix
        testPointMatrix(i,j,1:6) = jSet(n,1:6);
        testPointMatrix(i,j,7) = thisCluster(1);
        testPointMatrix(i,j,8) = thisCluster(2);
        j = j + 1;
    end
end


% Begin the main data collection procedure. This will carefully approach
% each data point in a systematic way, and take a measurement once each
% point is reached. Careful movement will be used to transition between
% spheres and poses.
% results(i,j) will take on the following form:
n = 1;                  % Index to sort results
point = 1;              % Index for points in a cluster

for cluster = 1:i
    % Move to the upcoming safe position without collision
    pose = testPointMatrix(cluster,1,7);
    sphere = testPointMatrix(cluster,1,8);
    % Case 1: Next cluster is nearby, and the safeMatrix is not missing the
    % safe position.
    if abs(testPointMatrix(cluster,1,1) - safeMatrix(pose,sphere,1)) < pi/2 && ~isempty(find(safeMatrix(pose,sphere,1:6)))
        % Go to the next safe position
        robotCrashes = moveCarefully(robot, model, safeMatrix(pose,sphere,1:6));
        % Try to salvage the cluster by returning to ready position.
        if robotCrashes
            robotCrashes = moveCarefully(robot, model, model.Home);
            robotCrashes = moveCarefully(robot, model, safeMatrix(pose,sphere,1:6));
        end
    % Case 2: Cluster is not nearby. Return to Home first    
    else
        robotCrashes = moveCarefully(robot, model, model.Home);
        robotCrashes = moveCarefully(robot, model, safeMatrix(pose,sphere,1:6));
    end
    
    point = 1;
    % Begin examining the sphere
    while testPointMatrix(cluster,point,7) ~= 0 && ~robotCrashes
        results(n,:) = moveProtected(robot, model, testPointMatrix(cluster,:,:), @takeMeasurement);
        
        % Move to the next point
        point = point +1;
        n = n + 1;
    end
end
