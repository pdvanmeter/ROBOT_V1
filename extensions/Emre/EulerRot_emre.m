%create euler rotation zyz and xyz conventions

mesafe=60;
y=sym('phiE');
p=sym('thetaE');
r=sym('psiE');
RotMatrix= transXYZ(0,0,mesafe)*rotZ(y)*rotY(p)*rotZ(r);
%for xyz convention(later)

SphereGridPlaneFrame = [0 10 20 30 30 30 20 10 0 0;
                        0 0 0 0 6.5 13 13 13 13 6.5;
                        0.0 0.0  0.0 0.0 .005 .005 .005 .005 .005 .005
                        1   1    1    1    1   1    1    1    1    1];
SphereGridPlaneFrame = [SphereGridPlaneFrame(1:3,:)*25.4;ones(1,10)]
          %x-axis connects spheres 1 and 2.
%y-axis connects spheres 1 and 9.
%z axis is x cross y

%Plane Parameters
%First sphere coordinates in world frame.
C=[1252.82; -315.0603; 121.7427;1];
y=pi/2;
p=0;
r=0;


%Transform from table to lab frame
Ttable2lab=transXYZ(C(1),C(2),C(3))*rotZ(y)*rotY(p)*rotZ(r);

%
Tlaser2Fl=transformTool(modelSensor);

%
syms J1 J2 J3 J4 J5 J6;

J=[J1, J2,J3, J4, J5, J6];

Tflange2Lab=transformRobot(modelRobot(),J);

%
for i=1:10
Tball2table=transXYZ(SphereGridPlaneFrame(1,i),SphereGridPlaneFrame(2,i),SphereGridPlaneFrame(3,i))

end