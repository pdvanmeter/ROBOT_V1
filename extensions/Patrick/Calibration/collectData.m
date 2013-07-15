% Script to automate the data collection process. It will take a set of
% actuations (that ideally have already passed the testJs function or some
% similar test) and use the protected movement function to transition from
% point-to-point while taking data. Since we do not currently have a
% completed trajectory planning algorithm, we used a series of
% careful instructions in order to deal with potential crashes. The entire process
% is split up into "clusters", sorted by spheres and pose number. Each pose is given
% a "default" position of the correct orientation (and somewhat raised
% above the table), and upon simulated collision the protected movement
% function will move to this position then attempt to salvage the point. If
% it cannot be done, the point will be recorded as all 0's. Furthermore,
% the arm will always move to a default position before beginning a new cluster.

