% function [ output_args ] = lockTarget( r,theRanger, targetX, targetY)
%Poses the robot so that the centroid of the laser dot is positioned at
%pixel (targetX, targetY)

%r: an instance of RX130
%targetX,targetY: Where we want to position the centroid of the laser.


%The joint resolution as given in the robot manual.
jointRes = .001*[0.68 0.68 0.87 1.00 1.17 2.75]*pi/180.0;
%The epsilon used in computing the jacobian.
inc = jointRes*1000;
theRanger.laserOff();
before=grabFrame();
theRanger.laserOn();
after=grabFrame();
[xStart yStart]=findLaser(after,before);

while( (abs(xStart-targetX)>.5 || abs(yStart-targetY)>.5))
    startJ=r.where();
    jBack=startJ;

    posMap=zeros(6,2);
    for i=1:6,
        startJ(i)=startJ(i)+inc(i);
        startJ-jBack
        r.moveJ(startJ);
        after=grabFrame();
        [posMap(i,1) posMap(i,2)]=findLaser(after,before);
        startJ=jBack;
    end
    posMap(:,1) = (posMap(:,1)-xStart)./(inc');
    posMap(:,2) = (posMap(:,2)-yStart)./(inc');
    posMap = posMap'
    dJ= pinv(posMap)*[targetX-xStart; targetY-yStart]
    theRobot.moveJ(jBack+dJ');
    theRanger.laserOn();
    after=grabFrame();
    [xStart yStart]=findLaser(after,before);
end
end




%planeToWorld = makeTransform(


theRanger.laserOn();
zAxis=theRanger.getDistance();
trans=theRobot.whereT();
PointsInLab(:,i)=trans*transformTool([0,0,10,5],0)*[0,0,zAxis+39.5,1]';



normalVector = cross(PointsInLab(1:3,2)-PointsInLab(1:3,1), PointsInLab(1:3,3)-PointsInLab(1:3,1));
normalVector = normalVector / norm(normalVector);

ry=atan2(normalVector(1),sqrt(1-normalVector(1)^2))
rx=atan2(normalVector(2)/(-cos(ry)),sqrt(1-normalVector(2)/(-cos(ry))))
rotationM=rotX(rx)*rotY(ry)*rotZ(0)
rad2deg(ry)
rad2deg(rx)

%CameraToWorld
