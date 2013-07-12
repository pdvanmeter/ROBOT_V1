function [ failedActuations results ] = testJs( model, jSet )
%TESTJS Runs a simple crash protection simulation on a set of actuations.
%   Returns a vector with one entry per actuation. A 1 in that position
%   means that the actuation has failed, and a 0 means that it is
%   acceptable. Also returns a more comprehensive matrix with the following
%   info:
%   Column 1: 0 Success/1 Collision
%   Columns 2-7: Joint Angles
%   Column 8: Pose number (1-8)
%   Column 9: Sphere Number
%   Column 10: Colliding Part 1 (0 if no collision)
%   Column 11: Colliding Part 2 (0 if no collision)

% TODO: Modify to use moveJ once better bounding boxes are implemented.
failedActuations = zeros(1,length(jSet));
results = zeros(length(jSet),11);

for n = 1:length(jSet)
    fprintf('Now testing actuation %d on sphere %d \n', n, jSet(n,8));
    [crashes collisionMatrix] = model.setJ(jSet(n,1:6));
    failedActuations(n) = crashes;
    % Populate the results matrix
    results(n,1) = crashes;             % Successful actuation?
    results(n,2:7) = jSet(n,1:6);       % Joint actuations
    results(n,8) = jSet(n,7);           % Pose number
    results(n,9) = jSet(n,8);           % Sphere number
    if ~crashes
        results(n,10) = 0;
        results(n,11) = 0;
    else
        [x y] = find(collisionMatrix);
        results(n,10) = max(x);          % Due to use of max, there may be additional collisions
        results(n,11) = max(y);
    end
end

% Report results
if(~find(failedActuations))
    fprintf('All actuations tested were sucessful.\n');
else
    fprintf('The following actuations were unsuccessful: ');
    for n = 1:length(failedActuations)
        if failedActuations(n)
            fprintf('%d ',n);
        end
    end
    fprintf('\n');
end

end

