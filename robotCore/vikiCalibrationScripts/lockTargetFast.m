function [ output_args ] = lockTarget( r, targetX, targetY)
%Poses the robot so that the centroid of the laser dot is positioned at
%pixel (targetX, targetY)

%r: an instance of RX130
%targetX,targetY: Where we want to position the centroid of the laser.

%Camera Pose
%Target Pose

% l= (x,y) as given to us by find laser.
% planeToWorld (x,y) -> (x,y,z)
 %planeToWorld = makeTransform(
% cameraToPlane -> (x,y) -> (x,y)

%T*l = (x,y,z) world

%The joint resolution as given in the robot manual.
jointRes = .001*[0.68 0.68 0.87 1.00 1.17 2.75]*pi/180.0;
%The epsilon used in computing the jacobian.
inc = jointRes*100;

actuateLaser(0);
before=grabFrame();
actuateLaser(1);
after=grabFrame();
[xStart yStart]=findLaser(after,before);
startJ=r.where();
top_right=[731.17+1380;-55.18;567.15-43;1];
bottom_left=[731.17+1380;60.08;478.33-43;1];

planePose=makeTransform(bottom_left(1),bottom_left(2),bottom_left(3),0,deg2rad(-90),deg2rad(90));
[thePoint] = predictLaserImpactPoint(r.whereT()*transformLaser(modelLaser()),planePose)

xPred= 640*abs((thePoint(2)-bottom_left(2))/(top_right(2)-bottom_left(2)))
yPred= 480*abs( (thePoint(3)-bottom_left(3))/(top_right(3)-bottom_left(3)))
xStart-xPred
yStart-yPred
pause 
while( (abs(xStart-targetX)>.5 || abs(yStart-targetY)>.5))
    startJ=r.where();
    jBack=startJ;
    
    posMap=zeros(6,2);
    for i=1:6,
        startJ(i)=startJ(i)+inc(i);
        startJ-jBack
        r.moveJ(startJ);
        %after=grabFrame();
        
        [thePoint] = predictLaserImpactPoint(r.whereT()*transformLaser(modelLaser()),planePose);
        
        posMap(i,1) = 640*abs((thePoint(2)-bottom_left(2))/(top_right(2)-bottom_left(2)))
        posMap(i,2)=480*abs( (thePoint(3)-bottom_left(3))/(top_right(3)-bottom_left(3)))
        startJ=jBack;
    end
    posMap(:,1) = (posMap(:,1)-xStart)./(inc');
    posMap(:,2) = -(posMap(:,2)-yStart)./(inc');
    posMap = posMap'
    dJ= pinv(posMap)*[targetX-xStart; targetY-yStart]
    r.moveJ(jBack+dJ');
    actuateLaser(1);
    after=grabFrame();
    [xStart yStart]=findLaser(after,before);
end
end

