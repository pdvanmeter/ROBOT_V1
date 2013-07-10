function worldPoint = measureWorldCoordinatesOfCameraPixel( theRobot,theRanger, targetX, targetY)
%Pretty self-explanatory.   Make targetX or targetY negative in order to use the current pixel.
if(targetX>0 && targetY>0)
    lockTarget(theRobot,theRanger, targetX, targetY);
end
theRanger.laserOn();
toolCoordinates = [0;0;0;1]
toolCoordinates(3,1)=39+theRanger.getDistance();
worldPoint = theRobot.whereT()*transformLaser(modelLaser())*toolCoordinates;
end

