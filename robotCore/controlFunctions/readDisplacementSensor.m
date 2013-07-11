function [ theReading ] = readDisplacementSensor()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [garbage theReading] =system('c:\device\readfast.exe');
    theReading= str2num(theReading);
end

