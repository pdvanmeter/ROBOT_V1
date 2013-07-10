%Find all the sphere centers in space.
SphereGridRaw = [0 10 20 30 30 30 20 10 0 0;
              0 0 0 0 6.5 13 13 13 13 6.5;
             .99 .99  .99 .99 .995 .995 .995 .995 .995 .955
              1   1    1    1    1   1    1    1    1    1];

SphereGridPlaneFrame = [0 10 20 30 30 30 20 10 0 0;
                        0 0 0 0 6.5 13 13 13 13 6.5;
                        0.0 0.0  0.0 0.0 .005 .005 .005 .005 .005 .005
                        1   1    1    1    1   1    1    1    1    1];
SphereGridPlaneFrame = [SphereGridPlaneFrame(1:3,:)*25.4;ones(1,10)];
          %x-axis connects spheres 1 and 2.
%y-axis connects spheres 1 and 9.
%z axis is x cross y

for i=1:10;
Tball2table=transXYZ(SphereGridPlaneFrame(1,i),SphereGridPlaneFrame(2,i),SphereGridPlaneFrame(3,i))

end
%Plane Parameters
%First sphere coordinates in world frame.
C=[1250.7466; -318.16; 122.03;1];
y=0;
p=0;
r=0;

Tlab2Table=transXYZ(C(1),C(2),C(3))*rotZ(y)*rotY(p)*rotZ(r);

%Tlaser2Fl=transformTool(modelSensor);
%syms J1 J2 J3 J4 J5 J6;


%J=[J1, J2,J3, J4, J5, J6];
%Tflange2Lab=transformRobot(modelRobot(),J);



i=1;
%EulerSet = zeros(3,8);
%RotationMatrix = zeros(4,4,8);
%Jse = zeros(8,6,8);
for l=1:2
    for k=1:2
        for m=1:2
            phiE=l*0/4;
            thetaE=k*3*pi/5;
            psiE=m*-pi/4;
            EulerSet(:,i)=[phiE;thetaE;psiE];
            mesafe=80;
            RotMatrix(:,:,i)=transXYZ(0,0,mesafe)*rotZ(phiE)*rotY(thetaE)*rotZ(psiE);
            RotationMatrix(:,:,i)=Tlab2Table*RotMatrix(:,:,i);        
            
            Jse(:,:,i) = ikineToolPoseAna(RotationMatrix(:,:,i),modelRobot(),modelSensor(),0);
            i=i+1
            
%y=sym('phiE');
%p=sym('thetaE');

%r=sym('psiE');


        end
    end
end

            









