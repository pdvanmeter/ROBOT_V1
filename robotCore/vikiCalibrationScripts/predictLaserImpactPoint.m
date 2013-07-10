function [ impactPoint ] = predictLaserImpactPoint(systemPose,targetPose)

%PREDICTLASERIMPACTPOINT Summary of this function goes here
%   Detailed explanation goes here
impactPoint=zeros(1,3);

p0=targetPose(1:3,4)
n=targetPose(1:3,3)

l0=systemPose(1:3,4)
%l=T(1:3,3)
l=-n
d=dot((p0-l0),n)/(dot(l,n))
impactPoint=l0+d*l
end

