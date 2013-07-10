SphereGridRaw = [0 10 20 30 30 30 20 10 0 0;
              0 0 0 0 6.5 13 13 13 13 6.5;
             .99 .99  .99 .99 .995 .995 .995 .995 .995 .955
              1   1    1    1    1   1    1    1    1    1];


%Given the origin sphere center,choosing xyz axis of table frame aligned
%with lab frame,

SphereGridPlaneFrame = [0 0 0 0 -6.5 -13 -13 -13 -13 -6.5;
                        0 10 20 30 30 30 20 10 0 0;
                        0.0 0.0  0.0 0.0 .005 .005 .005 .005 .005 .005
                        1   1    1    1    1   1    1    1    1    1];

 %inches to mm,                   
SphereGridPlaneFrame = [SphereGridPlaneFrame(1:3,:)*25.4;ones(1,10)];

%Center coordinates of origin sphere in 
%Lab frame(origin sphere center and origin of table chosen to be same)

C=[1250.7466; -318.16; 122.03;1];


%Given the XYZ of table origin in lab frame and the orientation of table frame with
%respect to lab frame (specified in modelTable) one can calculate Transformation matrix from table 2
%lab usin following function:  

TTable2Tlab=transformTable(modelTable);

     Tball2Ttable=zeros(4,4,10);
           for i=1:10;  %balls
               
               Tball2Ttable(:,:,i)=transXYZ(SphereGridPlaneFrame(1,i),SphereGridPlaneFrame(2,i),SphereGridPlaneFrame(3,i));
         
          
           end
          
           %Next in order to create fake set of Js, one can create the
           %transformation matrix for laser to ball frame from a fixed
           %distance and arbitrary set of Euler angles (although said
           %arbitrary , it would be good idea to make sure here, to orient
           %laser downwards by giving proper angle interval for rotation about
           %Y (thetaE))
           
           EulerSet = zeros(3,64);
           RotMatrix=zeros(4,4,64);
           for l=1:4;
              for  k=1:4;
                  for   m=1:4;
                     j=m+4*(k-1)+16*(l-1);             
                     phiE=l*pi/40;
                     thetaE=(k-1)*2*pi/9+2*pi/3;
            psiE=m*-pi/120;
              
            EulerSet(1:3,j)=[phiE;thetaE;psiE];
                           
         
            mesafe=-78.57;
           
            
            RotMatrix(:,:,j)=rotZ(EulerSet(1,j))*rotY(EulerSet(2,j))*rotZ(EulerSet(3,j))*transXYZ(0,0,mesafe);
         
                  end
              end
           end
                  
            %RotMatrix is the coordinates and orientation of laser in ball
            %frame, in order to use inverse kinematics (ikineToolposeAna) function , one needs to specify
            %laser(or tool) coordinates and orientation in lab frame,which
            %is defined as 'target pose' in ikine function, here it is 
            %Rotation Matrix.
            
RotationMatrix = zeros(4,4,10,64); %target pose
Jse = zeros(8,6,10,64); %solutions given target pose
GoodJse=zeros(5120,9); %only posiible solutions
GoodJseInfoTrack=zeros(5120,3); %just in case doesnt hurt (no more than few seconds) to keep backup track
          
T2W=zeros(4,4,1);
PtWCor=zeros(4,1,1);        
          
          
            for Nem=0;
                for fl=1:8;
                     for i=1:10;
                         for j=1:64;
            
                      
            RotationMatrix(:,:,i,j)=TTable2Tlab*Tball2Ttable(:,:,i)*RotMatrix(:,:,j);
            
            %Now we can use above matrix as target pose: 
            
            Jse(:,:,i,j) = ikineToolPoseAna(RotationMatrix(:,:,i,j),modelRobot(),modelSensor(),0);
            
           %Since depending to Euler angles and sphere center position we may not
           %have a solution, It would be a good idea to eliminate non
           %solution points here by only keeping non zero Js while still storing 
           %to which flip,ball,and euler angles they do belong;
        
          if Jse(1:8,1:6,i,j)~=0;
            
              Nem=Nem+1;
             
              GoodJse(Nem,1:6)=Jse(fl,:,i,j);
              GoodJse(Nem,7)=fl;
              GoodJse(Nem,8)=i;
              GoodJse(Nem,9)=j;
              
              GoodJseInfoTrack(Nem,1)=fl;
              GoodJseInfoTrack(Nem,2)=i;
              GoodJseInfoTrack(Nem,3)=j;
              
          end
          
                     
      ImPtLsrCord=[0 0 72.22 1];
      L2T=transformTool(modelSensor());
      T2W(:,:,Nem)=transformRobot(modelRobot(),GoodJse(Nem,1:6)); 
      
      PtWCor(:,:,Nem)=T2W(:,:,Nem)*(L2T*ImPtLsrCord');   
          
                         end
                    end
                end
            end
            
  FitFe=zeros(Nem,1);
  SphereGridWorldPlane=TTable2Tlab*SphereGridPlaneFrame;        
            
  for Nam=1:Nem;          
            
 
                 FitFe(Nam,1)=norm(PtWCor(1:3,Nam)-SphereGridWorldPlane(1:3,GoodJseInfoTrack(Nam,2)),2);
              
  end
      
            
   PartialperRbParameter=zeros(4,1,Nem,23);
   FitFePart=zeros(Nem,29);
   PartialperTbParameter=zeros(4,1,10,6);
   DesignMatrix=zeros(Nem,29);
   ErrorPerParameter=[0.0005,0.0005,0.0005,0.0005,0.0005,0.0005,0.0005,0.0005,...
                      0.0005,0.0005,0.0005,0.0005,0.0005,0.0005,0.0005,0.0005,...
                      0.0005,0.0005,0.0005,0.0005,0.0005,0.05,0.05,0.0005,0.0005,0.0005,0.5,0.5,0.5] 
                      
    
     for n=1:Nem;
         for p=1:29;
                    
                     
                 
PartialperRbParameter(:,:,n,p)=  transformRobot(modelRobotPartial(p+4),GoodJse(n,:))*(transformTool(modelSensorPartial(p+6))*ImPtLsrCord');

PartialperTbParameter(:,:,:,p)=transformTable(modelTablePartial(p+6))*SphereGridPlaneFrame;

FitFePart(n,p)=norm(PartialperRbParameter(1:3,1,n,p)-PartialperTbParameter(1:3,1,GoodJseInfoTrack(n,2),p),2);

DesignMatrix(n,p)=(FitFePart(n,p)-FitFe(n,1))/ErrorPerParameter(p);

         end
     end
     
            
            
            
            
            
            
            
%T2W=zeros(4,4,1);
%PtWCor=zeros(4,1,1);      
%T2W=zeros(4,4,8,10,64);
%PtWCor=zeros(4,1,8,10,64);
%for No=1:Nem;


        %for fl=1:8;
        %   for i=1:10;
          %   for j=1:64;
                 %vp=j+64*(i-1)+640*(fl-1);
                 
                 
   %   ImPtLsrCord=[0 0 72.22 1];
    %  L2T=transformTool(modelSensor());
    %  T2W(:,:,No)=transformRobot(modelRobot(),GoodJse(No,1:6));
      
%      
     % PtWCor(:,:,fl,i,j)=T2W(:,:,fl,i,j)*(L2T*ImPtLsrCord');
            
             
                            
        
