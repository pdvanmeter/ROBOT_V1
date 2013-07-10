J=theRobot.where;
dist=theRanger.getDistance;
targetPoint=transformRobot(modelRobot,J)*transformTool(modelLaser,0)*[0;0;39.5+dist;1]
