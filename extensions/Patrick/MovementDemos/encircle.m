function encircle( center,radius,steps,angle)
%Causes the robot to "orbit" around a point at a given angle.
%   Uses makeTargetCircle function to generate the path.

% Generate the circular path, and start the model at "home"
circlePoints = makeTargetCircle(center,radius,steps);
plot(circlePoints(1,:),circlePoints(2,:));
home = [0,-pi/2,pi/2,0,0,0];

% Make the model robot
theModel = geometricModel();
previousPoint = home;
theModel.setJ(home);

% Move the robot
for n = 1:length(circlePoints)
    theta = atan2(circlePoints(2,n)-center(2),circlePoints(1,n)-center(1));
    jSet = generateGoodSet(circlePoints(1,n),circlePoints(2,n),circlePoints(3,n)+radius*cot(angle),theta,3*pi/2-angle,0,10);
    nextPoint = leastTurns(previousPoint,jSet);
    theModel.moveJ(previousPoint,nextPoint);
    previousPoint = nextPoint;
end

% End where it started
jSet = generateGoodSet(circlePoints(1,1),circlePoints(2,1),circlePoints(3,n),0,3*pi/2-angle,0,0);
lastPoint = leastTurns(previousPoint,jSet);
theModel.moveJ(previousPoint,lastPoint);

end
