function  statusOfLock=lockTarget( theRobot,theRanger, targetX, targetY)
%Description:
% Poses the robot so that the centroid of the laser dot is positioned at
%  (targetX, targetY) in camera space.
%  Camera Space:
%  (0,0,0) is the top-left of the frame.
%  (Image Width [pixels], Image Height [pixels],0) is the bottom-right of the frame.
%  The z-axis is the lens normal.

%Parameters:
% theRobot: An instance of RX130
% theRanger: An instance of Disto
% targetX,targetY: Where we want to position the centroid of the laser in
% camera space.

%The joint resolution as given in the robot manual.
jointRes = .001*[0.68 0.68 0.87 1.00 1.17 2.75]*pi/180.0;

%The epsilon used in computing the jacobian.
inc = jointRes*50;

%How close do we have to get to the target point?
tolerance = 3;

%Where is the laser now?
theRanger.laserOff();
before=grabFrame();
theRanger.laserOn();
after=grabFrame();
theRanger.laserOff();
statusOfLock=0;
[xStart yStart]=findLaser(after,before);
startJ=theRobot.whereJ();
hitPoints=fopen('hitPoints.txt','a');
hitjPoints=fopen('hitjPoints.txt','a');
fprintf(hitPoints,'%u \t %u \n',[xStart yStart]);
fprintf(hitjPoints,'%20.10G \t %20.10G \t %20.10G \t %20.10G \t %20.10G \t %20.10G \t \n',startJ);

if (isnan(xStart)||isnan(yStart))
    display('Could not detect laser. Trying a new pose');
    statusOfLock=0;
    return
end
if (abs(xStart-targetX)<=tolerance && abs(yStart-targetY)<=tolerance)
    statusOfLock=1;
    return
end
iterations=0;
while( (abs(xStart-targetX)>tolerance || abs(yStart-targetY)>tolerance))
    jBack=startJ;
    posMap=zeros(6,2);
    jacobian=zeros(6,2);
    for i=4:5,
        startJ(i)=startJ(i)+inc(i);
        %         startJ-jBack
        theRobot.moveJ(startJ);
        theRanger.laserOn;
        after=grabFrame();
        theRanger.laserOff;
        [posMap(i,1) posMap(i,2)]=findLaser(after,before);
        tries=1;
        if (isnan(posMap(i,1))||isnan(posMap(i,2)))
            strResponse = input('Could not detect laser. Would you like to try again? (y for yes, n for no) If yes, robot will increment in the opposite direction.', 's');
            if strResponse~='n'
                while ((isnan(posMap(i,1))||isnan(posMap(i,2)))&& tries<=2)
                    startJ=jBack;
                    inc(i)=-inc(i);
                    startJ(i)=startJ(i)+inc(i);
                    %             startJ-jBack
                    theRobot.moveJ(startJ);
                    theRanger.laserOn;
                    after=grabFrame();
                    theRanger.laserOff;
                    [posMap(i,1) posMap(i,2)]=findLaser(after,before);
                    tries=tries+1;
                end
            end
        end
        startJ=jBack;
    end
    if sum(find(isnan(posMap)))
        display('Laser not detected, target not locked. Returning to calling function');
        statusOfLock=0;
        return
    else
        
        jacobian(4:5,1) = (posMap(4:5,1)-xStart)./(inc(4:5)');
        jacobian(4:5,2) = (posMap(4:5,2)-yStart)./(inc(4:5)');
        jacobian = jacobian';
        dJ= pinv(jacobian)*[targetX-xStart; targetY-yStart];
        startJ=theRobot.moveJ(jBack+dJ');
        fprintf(hitjPoints,'%20.10G \t %20.10G \t %20.10G \t %20.10G \t %20.10G \t %20.10G \t \n',startJ);
        theRanger.laserOn;
        after=grabFrame();
        theRanger.laserOff;
        [xStart yStart]=findLaser(after,before);
        fprintf(hitPoints,'%u \t %u \n',[xStart yStart]);
        iterations=iterations+1;
        statusOfLock=1;
    end
end
iterations
fprintf(hitPoints,'\n');
fclose(hitPoints);
fprintf(hitjPoints,'\n');
fclose(hitjPoints);
% hitPoints=fopen('hitPoints','
end

