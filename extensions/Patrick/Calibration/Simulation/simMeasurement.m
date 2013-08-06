function [ results ] = simMeasurement( realModel )
%SIMMEASUREMENT Summary of this function goes here
%   Detailed explanation goes here

results(1) = 72 + rand(1);
results(2:7) = realModel.J;

end

