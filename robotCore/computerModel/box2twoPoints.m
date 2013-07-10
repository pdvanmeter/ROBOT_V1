function [ pointA pointB ] = box2twoPoints( vertices )
%BOX2TWOPOINTS Summary of this function goes here
%   Detailed explanation goes here
k=sort(vertices);
minXYZ=k(1,:);
maxXYZ=k(end,:);
pointA=minXYZ;
pointB=maxXYZ;
end

