function [ results ] = takeMeasurement( robot )
%TAKEMEASUREMENT Summary of this function goes here
%   Detailed explanation goes here

reading = DisplacementReadingToDistance(readDisplacementSensor());
results(1) = reading;
results(2:7) = robot.whereJ();

end

