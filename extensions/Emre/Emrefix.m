SphereGridPlaneFrame = [0 0 0 0 -6.5 -13 -13 -13 -13 -6.5;
                        0 10 20 30 30 30 20 10 0 0;
                        0.0 0.0  0.0 0.0 .005 .005 .005 .005 .005 .005
                        1   1    1    1    1   1    1    1    1    1];

                    
SphereGridPlaneFrame = [SphereGridPlaneFrame(1:3,:)*25.4;ones(1,10)];

%C=[1250.7466; -318.16; 122.03;1];
C=[920.54;-64.16;122.157;1];


TTable2Tlab=transXYZ(C(1),C(2),C(3));

   % for i=1:10;  %balls
               
               %Tball2table(:,:)=transXYZ(SphereGridPlaneFrame(1,1),SphereGridPlaneFrame(2,1),SphereGridPlaneFrame(3,1));
         
    
   
           
            phiE=0.12;
            thetaE=3.02;
            psiE=0;
            mesafe=79.05;
           
            
           % RotMatrix(:,:)=transXYZ(0,0,mesafe)*rotZ(phiE)*rotY(thetaE)*rotZ(psiE)
            
            RotMatrix= transXYZ(0,0,mesafe)*rotZ(phiE)*rotY(thetaE)*rotZ(psiE)
            
            RotationMatrix=TTable2Tlab*RotMatrix;
           
           Jse = ikineToolPoseAna(RotationMatrix,modelRobot(),[0,0,0,0,0],0);
           
           
      ImPtLsrCord=[0 0 72.68 1];
      L2T=transformTool(modelSensor());
      T2W=transformRobot(modelRobot(),Jse(6,:));
      PtWCor=T2W*(L2T*ImPtLsrCord')
      
     % T2Wexp=transformRobot(modelRobot(),theRobot.whereJ);
      %PtWCorexp=T2Wexp*(L2T*ImPtLsrCord')
      
      
           
      

