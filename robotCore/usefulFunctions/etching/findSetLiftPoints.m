function [setMask liftMask]=findSetLiftPoints(points, cutoff)
%findSetLiftPoints Locates the appropriate lifts in a set of points.
%   Points are determined by the given cutoff distance.

% Find the displacement vector matrix and normalize it
dispVects = [zeros(4,1), points]-[points, zeros(4,1)];
norms = sqrt(diag(dispVects'*dispVects))';
norms(end) = [];

% Generate a matrix of 'true' or 'false' values
% 1 is a lift/set point, 0 is a continuation
setMask = (norms>cutoff);
setMask(end) = false;
liftMask = [setMask(2:length(setMask)) true];

end