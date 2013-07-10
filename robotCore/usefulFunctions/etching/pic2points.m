function [points]=pic2points(filename)
%PICS2POINTS Converts an image into a series of points that approximate it.
%   These points must be further ordered to etch efficiently.

% Read the file in and convert it to binary (black or white) points
pic = imread(filename);
pic = rgb2gray(pic);
pic = dither(pic);
pic =~ pic;
[r,c] = find(pic);
points = [r,c];
points = points';
points = [points;zeros(1,length(points));ones(1,length(points))];

% Use this command to plot the points in 3D
% scatter3(points(1,:),points(2,:),points(3,:),'.')
xlabel('X'),ylabel('Y'),zlabel('Z')                 % Why is this uncommented?

end