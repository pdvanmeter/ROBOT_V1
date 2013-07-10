function [ adjacencyMatrix ] = getAdjacencyMatrix( arg )
%GETADJACENCYMATRIX Used to fetch the large adjacency matrix here
%   Returns the matrix for parts not to test against each other for a given
%   case. A '1' means that the parts are adjacent or uncollidable, and
%   therefore unecessary to check against each other. Note that this matrix
%   is an upper triangular matrix, since the other half would simply be
%   redundant information.

adjacencyMatrix = zeros(21,21);

% Case 1 - Plate Calibration Configuration
% The laser (10) has been left for legacy reasons, but is not checked.
if arg == 1
    % Matrix Index key:
    % partN maps to N (1 - 7)
    % environment = 8
    % tool = 9
    % laser = 10
    % table = 11
    % spheres(N) = N + 11 (12 - 21)
    
    %                   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21
    adjacencyMatrix = [ 1   1   1   0   0   0   0   1   0   1   1   1   1   1   1   1   1   1   1   1   1; %1
                        0   1   1   1   0   0   0   1   0   1   1   1   1   1   1   1   1   1   1   1   1; %2
                        0   0   1   1   1   0   0   0   0   1   0   0   0   0   0   0   0   0   0   0   0; %3
                        0   0   0   1   1   1   1   0   1   1   0   0   0   0   0   0   0   0   0   0   0; %4
                        0   0   0   0   1   1   1   0   0   1   0   0   0   0   0   0   0   0   0   0   0; %5
                        0   0   0   0   0   1   1   0   1   1   0   0   0   0   0   0   0   0   0   0   0; %6
                        0   0   0   0   0   0   1   0   1   1   0   0   0   0   0   0   0   0   0   0   0; %7
                        0   0   0   0   0   0   0   1   0   1   1   1   1   1   1   1   1   1   1   1   1; %8
                        0   0   0   0   0   0   0   0   1   1   0   0   0   0   0   0   0   0   0   0   0; %9
                        0   0   0   0   0   0   0   0   0   1   1   1   1   1   1   1   1   1   1   1   1; %10
                        0   0   0   0   0   0   0   0   0   0   1   1   1   1   1   1   1   1   1   1   1; %11
                        0   0   0   0   0   0   0   0   0   0   0   1   1   1   1   1   1   1   1   1   1; %12
                        0   0   0   0   0   0   0   0   0   0   0   0   1   1   1   1   1   1   1   1   1; %13
                        0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   1   1   1   1   1   1; %14
                        0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   1   1   1   1   1; %15
                        0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   1   1   1   1; %16
                        0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   1   1   1; %17
                        0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   1   1; %18
                        0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   1; %19
                        0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1   1; %20
                        0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   1];%21
end

end

