targetX = 960;
targetY = 540;

clear;
format long;
theRanger.laserOn();
lit = grabFrame();

theRanger.laserOff();
dark = grabFrame();

findLaser(lit,dark);

