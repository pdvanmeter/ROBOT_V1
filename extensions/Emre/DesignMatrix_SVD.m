SphereGridRaw = [0 10 20 30 30 30 20 10 0 0;
              0 0 0 0 6.5 13 13 13 13 6.5;
             .99 .99  .99 .99 .995 .995 .995 .995 .995 .955
              1   1    1    1    1   1    1    1    1    1];


%Given the origin at sphere center,choosing xyz axis of table frame aligned
%with lab frame,

SphereGridPlaneFrame = [0 0 0 0 -6.5 -13 -13 -13 -13 -6.5;
                        0 10 20 30 30 30 20 10 0 0;
                        0.0 0.0  0.0 0.0 .005 .005 .005 .005 .005 .005
                        1   1    1    1    1   1    1    1    1    1];

 %inches to mm,                   
SphereGridPlaneFrame = [SphereGridPlaneFrame(1:3,:)*25.4;ones(1,10)];

%Center coordinates of origin sphere in 
%Lab frame(origin of first sphere frame and origin of table frame chosen to be same)

C=[1250.7466; -318.16; 122.03;1];


%Given the XYZ of table origin in lab frame and the orientation of table frame with
%respect to lab frame (specified in modelTable) one can calculate Transformation matrix from table 2
%lab using following function:  

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
           %Y (thetaE)) 100-180    phi: 0-360    psi:+- 0-100
           
           mesafe=-78.57; %distance from laser to sphere center
           
           EulerSet = zeros(3,64);   %this matrix stores the arbitrary euler angles
           RotMatrix=zeros(4,4,64); %more properly transformation matrix from laser to ball frame
           for l=1:4;
              for  k=1:4;
                  for   m=1:4;
                     j=m+4*(k-1)+16*(l-1);             
                     phiE=l*pi/10;
                     thetaE=(k-1)*2*pi/9+2*pi/3;
                     psiE=m*-pi/20;
              
                     EulerSet(1:3,j)=[phiE;thetaE;psiE];
         
                     RotMatrix(:,:,j)=rotZ(EulerSet(1,j))*rotY(EulerSet(2,j))*rotZ(EulerSet(3,j))*transXYZ(0,0,mesafe);
                  end
              end
           end
                  
            %RotMatrix is the coordinates and orientation of laser in ball
            %frame, in order to use inverse kinematics (ikineToolposeAna) function , one needs to specify
            %laser(or tool) coordinates and orientation in lab frame,which
            %is defined as 'target pose' in ikine function, here it is 
            %Rotation Matrix, again more proper to name transformation
            %matrix or target pose
            
RotationMatrix = zeros(4,4,10,64); %target pose
Jse = zeros(8,6,10,64); %solutions given target pose
GoodJse=zeros(5120,9); %only posiible solutions
GoodJseInfoTrack=zeros(5120,3); %just in case doesnt hurt (no more than few seconds) to keep backup track
  
T2W=zeros(4,4,1);   %?? see below
PtWCor=zeros(4,1,1);   %?? see below    
          
          
            for Nem=0;
                for fl=1:8;   %split up to 8 loops
                     for i=1:10;
                         for j=1:64;
            
                      
            RotationMatrix(:,:,i,j)=TTable2Tlab*Tball2Ttable(:,:,i)*RotMatrix(:,:,j);
            
            %Now we can use above matrix as target pose: 
            
            Jse(:,:,i,j) = ikineToolPoseAna(RotationMatrix(:,:,i,j),modelRobot(),modelSensor());
            
           %Since depending to Euler angles and sphere center position we may not
           %have a solution, It would be a good idea to eliminate non
           %solution points here by only keeping non zero Js while still storing 
           %to which flip,ball,and euler angles they do belong;
        
          if Jse(1:8,1:6,i,j)~=0;  %1:8  -> fl
            
              Nem=Nem+1;
             
              GoodJse(Nem,1:6)=Jse(fl,:,i,j)+0.001;
              GoodJse(Nem,7)=fl;
              GoodJse(Nem,8)=i;
              GoodJse(Nem,9)=j;
              
              GoodJseInfoTrack(Nem,1)=fl;
              GoodJseInfoTrack(Nem,2)=i;
              GoodJseInfoTrack(Nem,3)=j;
              
          end
          
      %Now that we do have desired set of J's let's build our error function.
      %First, given these set of J, and distance reading of laser, what
      %point in lab coordinates we hit :
      
      ImPtLsrCord=[0 0 72.22 1];  %hit point in laser frame
      L2T=transformTool(modelSensor());  %transformation matrix from laser (or tool ) to flinge frame
      T2W(:,:,Nem)=transformRobot(modelRobot(),GoodJse(Nem,1:6)); %transformation matrix from flinge to lab frame
      
      PtWCor(:,:,Nem)=T2W(:,:,Nem)*(L2T*ImPtLsrCord');  %hit point coordinates in lab frame
          
                         end
                    end
                end
            end
            
  FitFe=zeros(Nem,1);       % distance from  center of sphere to hit pt
  SphereGridWorldPlane=TTable2Tlab*SphereGridPlaneFrame;  %coordinates of each sphere in Lab frame      
            
  for Nam=1:Nem;          
            
 
                 FitFe(Nam,1)=norm(PtWCor(1:3,Nam)-SphereGridWorldPlane(1:3,GoodJseInfoTrack(Nam,2)),2);
              
  end
      
            
   PartialperRbParameter=zeros(4,1,Nem,29);  %new pt we hit by changing one robot parameter by infinitesimal amount
   FitFePart=zeros(Nem,29);  %distance between hit point and corresponding sphere center           
   PartialperTbParameter=zeros(4,1,10,29); %new pt we hit by changing one table parameter by infinitesimal amount
   DesignMatrix=zeros(Nem,29);
   ErPerP=0.00001*[0.05,5,0.05,5,0.05,5,0.05,5,...
                      0.05,0.05,0.05,5,0.05,5,0.05,5,...
                      0.05,5,0.05,0.05,5,5,5,0.05,0.05,0.05,5,5,5] ; %errors assoiciated with each parameter
                      
    
     for n=1:Nem;
         for p=1:29;
                 
            PartialperRbParameter(:,:,n,p)=  transformRobot(modelRobotPartial(p+4,ErPerP(p)),GoodJse(n,1:6))*(transformTool(modelSensorPartial(p+6,ErPerP(p)))*ImPtLsrCord');
             
            PartialperTbParameter(:,:,:,p)=transformTable(modelTablePartial(p+6,ErPerP(p)))*SphereGridPlaneFrame;
          
            FitFePart(n,p)=norm(PartialperRbParameter(1:3,1,n,p)-PartialperTbParameter(1:3,1,GoodJseInfoTrack(n,2),p),2);

            DesignMatrix(n,p)=(FitFePart(n,p)-FitFe(n,1))/ErPerP(p);

         end
     end
     
   %   PartialperRbParameterA=zeros(4,1,100000);  %new pt where hits by changing one par
  % FitFePartA=zeros(1000,1);                 
  % PartialperTbParameterA=zeros(4,1,10,100000);
  % PartFe=zeros(100000,1);
  % ErPerPA=zeros(100000,1);  
   %  for ind=1:100000;
    %     npar=100;
      %   ppar=28;
     %    ErPerPA(ind)=ErPerP(ppar)/ind;
         
       %  PartialperRbParameterA(:,:,ind)=  transformRobot(modelRobotPartial(ppar+4,ErPerPA(ind)),GoodJse(npar,1:6))*(transformTool(modelSensorPartial(ppar+6,ErPerPA(ind)))*ImPtLsrCord');
             
        %    PartialperTbParameterA(:,:,:,ind)=transformTable(modelTablePartial(ppar+6,ErPerPA(ind)))*SphereGridPlaneFrame;
         
         %   FitFePartA(ind,1)=norm(PartialperRbParameterA(1:3,1,ind)-PartialperTbParameterA(1:3,1,GoodJseInfoTrack(npar,2),ind),2);

          %PartFe(ind,1)=(FitFePartA(ind,1)-FitFe(npar,1))/ErPerPA(ind);

    % end
     
            
            
 
