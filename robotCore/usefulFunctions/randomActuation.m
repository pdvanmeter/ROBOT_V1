function [ J ] = randomActuation()
%Returns a random actuation of the robot.
%Todo: Crash prevention.

minJ = [-160 (-137.5-90) (-142.5+90) -270 -105 -270]*pi/180;
maxJ = [ 160  (137.5-90)  (142.5+90)  270  120  270]*pi/180;
J=minJ + rand(1,6).* (maxJ-minJ);
end

