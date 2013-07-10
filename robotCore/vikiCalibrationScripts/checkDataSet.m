i=1;
laserPoints2=[];
while(i<=8)
    if(i==(acts/2+1))
        %Move the target a meter using the spot seeker.
        moveSpotSeeker('x',d*stepsPerMM);
    end
    theRobot.moveJ(dataSet(i,:));
    theRanger.laserOff();
    before=grabFrame();
    theRanger.laserOn();
    after=grabFrame();
    allPics2(:,:,i*3-2:i*3)=after;
    theRanger.laserOff();
    statusOfLock=1;
    [xStart yStart]=findLaser(after,before);
    laserPoints2(i,:)=[xStart yStart];
    %     statusOfLock=lockTarget(theRobot,theRanger, targetX, targetY);
    i=i+1
end
scatter(targetX,targetY,'*','g')
hold on
scatter(laserPoints2(:,1),laserPoints2(:,2))
hold off
maximum=max(laserPoints2)
minimum=min(laserPoints2)
moveSpotSeeker('x',-d*stepsPerMM);