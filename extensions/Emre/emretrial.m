SphereGridRaw = [0 10 20 30 30 30 20 10 0 0;
              0 0 0 0 6.5 13 13 13 13 6.5;
             .99 .99  .99 .99 .995 .995 .995 .995 .995 .955
              1   1    1    1    1   1    1    1    1    1];




SphereGridPlaneFrame = [0 0 0 0 -6.5 -13 -13 -13 -13 -6.5;
                        0 10 20 30 30 30 20 10 0 0;
                        0.0 0.0  0.0 0.0 .005 .005 .005 .005 .005 .005
                        1   1    1    1    1   1    1    1    1    1];

                    
SphereGridPlaneFrame = [SphereGridPlaneFrame(1:3,:)*25.4;ones(1,10)];



C=[1250.7466; -318.16; 122.03;1];


TTable2Tlab=transformTable(modelTable)



%EulerSet = zeros(3,8);
%RotationMatrix = zeros(4,4,8,10);
%Jse = zeros(8,6,8,10);
%RotMatrix=zeros(4,4,8);

            
            
            
            
    %        C=[1250.7466; -318.16; 122.03;1];


     %       Tlab2Table=transXYZ(C(1),C(2),C(3))*rotZ(0)*rotY(0)*rotZ(0);

           for i=1:10;  %balls
               
               Tball2Ttable(:,:,i)=transXYZ(SphereGridPlaneFrame(1,i),SphereGridPlaneFrame(2,i),SphereGridPlaneFrame(3,i));
         
          
           end
           %for j=1:64;  %data points
           
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
                  
            
            
           RotationMatrix = zeros(4,4,10,64);
            Jse = zeros(8,6,10,64);
            for i=1:10;
              for j=1:64;
            
            RotationMatrix(:,:,i,j)=TTable2Tlab*Tball2Ttable(:,:,i)*RotMatrix(:,:,j);
            
            
            
           Jse(:,:,i,j) = ikineToolPoseAna(RotationMatrix(:,:,i,j),modelRobot(),modelSensor(),0);
              
              end
            end
            
            
 %Filtering out here Js for no solution ;
 %for N=1;
    % if Jse~=0;
     
% GoodJse(N,:,:,i,j)= Jse(:,:,i,j);
    % end
 
 
            
            
            
            
           
%Given a set of js and a distance ball frame coordinates of impact point

%first world coordinates:
T2W=zeros(4,4,8,10,64);
PtWCor=zeros(4,1,8,10,64);
       for fl=1:8;
           for i=1:10;
             for j=1:64;
                 %vp=j+64*(i-1)+640*(fl-1);
                 
                 
      ImPtLsrCord=[0 0 72.22 1];
      L2T=transformTool(modelSensor());
      T2W(:,:,fl,i,j)=transformRobot(modelRobot(),Jse(fl,:,i,j));
      
      PtWCor(:,:,fl,i,j)=T2W(:,:,fl,i,j)*(L2T*ImPtLsrCord');
             end
           end
       end
           
      
        
           % whoo hooo !!!
           
           %Next Fit and Error functions followed by numerical derivatives:
           
    
  FitFe=zeros(1,8,10,64);
  SphereGridWorldPlane=TTable2Tlab*SphereGridPlaneFrame;
  
     for fl=1:8;
           for i=1:10;
             for j=1:64; 
                 
                 FitFe(:,fl,i,j)=norm(PtWCor(1:3,1,fl,i,j)-SphereGridWorldPlane(1:3,i),2);
              
             end
          end
      end
           
     FitFeNod=zeros(5120,1);
      JseFset=zeros(5120,6);
     
    for fl=1:8;
           for i=1:10;
             for j=1:64; 
                 n=j+64*(i-1)+640*(fl-1);
                 
             JseFset(n,:)= Jse(fl,:,i,j);
                 
               FitFeNod(n,1)=FitFe(:,fl,i,j);           
                 
             end
           end
    end
    
 
   PartialperRbParameter=zeros(4,1,5120,23);
    FitFePart=zeros(5120,29);
    PartialperTbParameter=zeros(4,1,10,6);
    DesignMatrix=zeros(5120,29);
    
    for n=1:5120;
      
         for p=1:29;
                     %   for i=
                        
                        
                     
                 
PartialperRbParameter(:,:,n,p)=  transformRobot(modelRobotPartial(p+4),JseFset(n,:))*(transformTool(modelSensorPartial(p+6))*ImPtLsrCord');

PartialperTbParameter(:,:,:,p)=transformTable(modelTablePartial(p+6))*SphereGridPlaneFrame;

k=floor((n-1)/64)+1;
                 if k>10;
                    k=mod(k,10);
                 end
                     if k==0;
                       k=10;
                     end
                     
FitFePart(n,p)=norm(PartialperRbParameter(1:3,1,n,p)-PartialperTbParameter(1:3,1,k,p),2);

DesignMatrix(n,p)=FitFePart(n,p)-FitFeNod(n,1);
                     
                     
                     

             end
         end
  
           
        
   
          
                 
                 
                 
                 
                % DesigMatrixDataPoint(n,p)=                                FitFeNod(n,1)
           
     
         
     
     
     
     
     
     
