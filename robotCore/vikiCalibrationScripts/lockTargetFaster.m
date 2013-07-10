function [ output_args ] = lockTargetFaster( theRobot,theRanger, targetX, targetY)
format('longG');
%Poses the robot so that the centroid of the laser dot is positioned at
%pixel (targetX, targetY)

%r: an instance of RX130
%targetX,targetY: Where we want to position the centroid of the laser.

%The joint resolution as given in the robot manual.
jointRes = .001*[0.68 0.68 0.87 1.00 1.17 2.75]*pi/180.0;
%The epsilon used in computing the jacobian.
inc = jointRes*10;
theRanger.laserOff();
before=grabFrame();
theRanger.laserOn();
after=grabFrame();
[xStart yStart]=findLaser(after,before);
startJ=theRobot.where();
[xPredicted yPredicted] = impactPoint(startJ)

pause;
while( (abs(xStart-targetX)>10 || abs(yStart-targetY)>10))
    startJ=theRobot.where()
    jBack=startJ;
    
    posMap=zeros(6,2);
    %Compute the jacobian
    for i=1:6,
        startJ(i)=startJ(i)+inc(i);
        startJ-jBack
        %%Do the forward kinematics to predict
        
        [xPredicted yPredicted] = impactPoint(startJ);
        %r.moveJ(startJ);
        %after=grabFrame();
        %[posMap(i,1) posMap(i,2)]=findLaser(after,before);
        posMap(i,1) = xPredicted;
        posMap(i,2) = yPredicted;
        startJ=jBack;
    end
    posMap(:,1) = (posMap(:,1)-xStart)./(inc');
    posMap(:,2) = (posMap(:,2)-yStart)./(inc');
    posMap = posMap'
    dJ= pinv(posMap)*[targetX-xStart; targetY-yStart]
    
    theRobot.moveJ(jBack+dJ');
    theRanger.laserOn();
    after=grabFrame();
    [xStart yStart]=findLaser(after,before)
    
end
while( (abs(xStart-targetX)>.5 || abs(yStart-targetY)>.5))
    lockTarget(theRobot,theRanger,targetX,targetY);
    theRanger.laserOn();
    after=grabFrame();
    [xStart yStart]=findLaser(after,before)
end
end

