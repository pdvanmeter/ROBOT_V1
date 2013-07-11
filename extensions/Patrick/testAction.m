function [ results ] = testAction( robot )
%TESTACTION A function to test the 'action' feature of moveProtected.
%   Returns a known resutls matrix to verify functionality. Returns the
%   robot joint configuration.

jList = robot.whereJ();
results = [ jList(1) jList(2) jList(3) jList(4) jList(5) jList(6)];

end

