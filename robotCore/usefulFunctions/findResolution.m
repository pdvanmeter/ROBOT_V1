jointRes = .001*[0.68 0.68 0.87 1.00 1.17 2.75]*pi/180.0;
inc=jointRes*10;
before=grabFrame();
theRanger.laserOn();
after=grabFrame();
theRanger.laserOff();
[xStart yStart]=findLaser(after,before);
k=1;
jpoint=[];
camPoint=[];
jpoint(k,:)=theRobot.whereJ();
camPoint(k,:)=[xStart yStart];
k=k+1;
jback=theRobot.whereJ();
for i=1:10
    for j=1:6
        newJ=jback;
        newJ(j)=jback(j)+inc(j);
        jpoint(k,:)=theRobot.moveJ(newJ);
        theRanger.laserOn();
        after=grabFrame();
        theRanger.laserOff();
        [xStart yStart]=findLaser(after,before);
        camPoint(k,:)=[xStart yStart];
        theRobot.moveJ(jback);
        k=k+1;
    end
    jback=jback+inc;
    jback=theRobot.moveJ(jback);
end