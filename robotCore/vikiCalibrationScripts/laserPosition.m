%Finds the current position of the laser beam in the camera frame.
actuateLaser(0);
before=grabFrame();
actuateLaser(1);
after=grabFrame();
[xStart yStart]=findLaser(after,before);
