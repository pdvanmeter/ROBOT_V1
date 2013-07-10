function [ scaledPoints ] = scalePoints(points,stretchX,stretchY)
%SCALEANDMOVEPOINTS Scales image points by the given dimensions
%   If scaling in X and Y are not equal, distortion will occur.

stretch = eye(4,4);
stretch(1,1) = stretchX;
stretch(2,2) = stretchY;
scaledPoints = stretch*points;

end

