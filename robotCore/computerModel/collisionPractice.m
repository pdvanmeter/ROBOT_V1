if(~exist('theModel', 'var'))
    theModel = geometricModel();
end
display('Robot is in ready position.  Press key to start simulation')

robotCrashes=1;
while(robotCrashes)
    a=randomActuation;
    [robotCrashes laserObscured]= theModel.setJ(a);
end

robotCrashes=1;
while(robotCrashes)
    b=randomActuation;
    [robotCrashes laserObscured]= theModel.setJ(b);
end
theModel.setJ(theModel.Home);
theJ = theModel.moveJ(a,b)