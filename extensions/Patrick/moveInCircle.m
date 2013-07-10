function moveInCircle( radius, height )
%Makes a geometric model and moves it in a circle
%   The origin of the circle is the base of the robot.
%   Note: It seems this will always act strangely due to joint limitations.

% Generate points, start model at "home" position
circlePoints = makeCircle(radius);
plot(circlePoints(1,:),circlePoints(2,:));
home = [0,-pi/2,pi/2,0,0,0];

% Make the model robot
theModel = geometricModel();
previousPoint = home;
theModel.setJ(home);

for n = 1:5000:length(circlePoints)
    theta = atan2(circlePoints(1,n),circlePoints(2,n));
    jSet = generateGoodSet(circlePoints(1,n),circlePoints(2,n),height,0,pi,theta,5);
    nextPoint = leastTurns(previousPoint,jSet);
    % Troubleshooting
%    if (nextPoint(2) ~= previousPoint(2)) && (n ~= 1)
%        disp('Error, bad actuation.')
%        jSet
%        nextPoint
%        previousPoint
%    end
    % Move to next point
    theModel.moveJ(previousPoint,nextPoint);
    previousPoint = nextPoint;
end

% End where it started
jSet = generateGoodSet(circlePoints(1,1),circlePoints(2,1),height,0,pi,0,5);
lastPoint = leastTurns(previousPoint,jSet);
theModel.moveJ(previousPoint,lastPoint);

end