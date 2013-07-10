format ('longG');
theRobot=RX130('COM6');
J = theRobot.where();
delete(theRobot);

%J=[0 -90 90 0 0 0 ]
J=deg2rad(J);
rotZ(pi/2);
rotY(deg2rad(96));
laser2tool=transXYZ(0,-30,37)*rotZ(-pi/2)*rotY(deg2rad(90));
transformRobot(modelRobot(),J);
%theRanger = Disto('COM12');
%a=theRanger.getDistance()
%delete(theRanger);
tool2World = transformRobot(modelRobot(),J);
pt=[0 0 1870 1];
pt=pt';
targetPoint = tool2World*laser2tool*pt
laser2tool*[0;0;1;0];

