%This script calibrates the RX130 using the
% Virtual Closed Kinematic Chain method.
format ('longG');

%[Magic Numbers]

%Coordinates of the target point in the camera frame:
targetX = 960;
targetY = 540;
targetPoint=[500;-3000;600];
Pars=zeros(1,25);
bot=modelRobot();
robotPars=modelRobot();
robotPars(1,:)=[];% not the 0th link, not calibrated, arbitrary
robotPars=reshape(robotPars,1,20);
robotPars(20)=[]; %J_6 d arbitrarily set to 110mm
robotPars(15)=[]; %J_6 theta_0 arbitrarily set to 0
Pars(1:18)=robotPars;
Pars(19:22)=modelLaser();
Pars(23:25)=targetPoint;
Pars(26:27)=[0 0];%phi and theta to align the x axis along the translation direction %x axis
% Pars(26:27)=[0 pi/2];%y axis


dangle=0.01;
dlength=1;
dPars=normrnd(Pars,dlength);
dPars(1:5)=normrnd(Pars(1:5),dangle);
dPars(11:14)=normrnd(Pars(11:14),dangle);
dPars(16)=normrnd(Pars(16),dangle);
dPars(19:20)=normrnd(Pars(19:20),dangle);
dPars(26:27)=normrnd(Pars(26:27),dangle);

fixedRobotPars=modelRobot;
dRobot=[dPars(1:14) fixedRobotPars(6,3) dPars(15:18) fixedRobotPars(6,4)];
dRobot=reshape(dRobot,[5,4]);
dRobot=[fixedRobotPars(1,1:4); dRobot];
dLaser=dPars(19:22);

dataPars=normrnd(Pars,0); %If you vary the parms, then the robot won't hit the spot.

translationAngles = dataPars(26:27);
acts=540;
dataSet=zeros(acts,6);
d=1000.0; %TODO: Calibrate the spot seeker so we can hit this exactly. 39.370 steps/mm??
% d=850; %for moving y axis
stepsPerMM = 39.370; %x axis
% stepsPerMM = 78.740; %y axis

%[/Magic Numbers]

%Ballpark coordinates of the target point in the lab frame:
%The easiest way to acquire this is to aim the laser at target manually,
%then run measureWorldCoordinatesOfPixel
disp('Preparing to acquire the world coordinates of the target pixel.  Please position the laser within the field of view of the camera and then press any key.');
% pause;

% targetPoint = measureWorldCoordinatesOfCameraPixel(theRobot,theRanger,targetX,targetY);
% targetPoint =targetPoint(1:3)'
J=ikineToolPosition([dPars(23:25),1]', dRobot,dPars(19:22),[realDataSet(1,:),3000],[4,5]);

disp('Target pixel acquired.  Press any key to start collecting ballpark actuations.');
% pause;

%Generate the ballpark actuations using the factory model.
%540 actuations needed to replicate paper results.

%Foreach ballpark actuation, lock onto the target pixel and
%record the exact actuation.
%Todo: More precise laser dot location.

%Data crunching:
%Invariants:
% J (6)xN Actuation
% D distance between target points

%Model Parameters:
% Pars (18) Robot Model
% Laser (4) Laser Model
% P (3) lab coordinates of first target point.
% M (2) angles describing the vector pointing from target 1 to target 2.

% J=(theRobot.where());
theModel.setJ(J);


i=1;

%Build the set of ballpark actuations.
% Stage 1: Find acts # of good actuations.
oldJ=J(1:6);
while(i<=acts)
    dP=dPars(23:25)';
    if(i>acts/2)
%         P=P-d*[cos(translationAngles(1))*cos(translationAngles(2)) sin(translationAngles(1))*cos(translationAngles(2)) -sin(translationAngles(2))]';
        dP=dP-d*[cos(dPars(26))*cos(dPars(27)) sin(dPars(26))*cos(dPars(27)) -sin(dPars(27))]';
    end
    %     figure(modelView);
    %     hold
    %     scatter3(P(1),P(2),P(3),'g','*');
    %     hold off
    
    dP=[dP; 1];
    if(i==(acts/2+1))
        %Move the target a meter using the spot seeker.
%         moveSpotSeeker('x',d*stepsPerMM);
    end
%     Js = ikineToolPositionAna(P,bot,dataPars(19:22),0);
%     J=Js(1,:);
%     figure(modelView);
%     [robotCrashes laserObscured]=theModel.setJ(realDataSet(i,:));
%     if  ~(robotCrashes || laserObscured)
%        [robotCrashes laserObscured]=theModel.moveJ(theRobot.whereJ,J);
%     end
%     while (robotCrashes || laserObscured)
%         Js = ikineToolPositionAna(P,bot,dataPars(19:22),0);
%         J=Js(1,:);
%         [robotCrashes laserObscured]=theModel.setJ(J);
%         if  ~(robotCrashes || laserObscured)
%             [robotCrashes laserObscured]=theModel.moveJ(theRobot.where,J);
%         end
%     end
%     theRobot.moveJ(J);
%     statusOfLock=lockTarget(theRobot,theRanger, targetX, targetY);
%     if statusOfLock==0;
%         disp('Could not lock on. Data point not recorded');
%     else
% %         dataSet(i,:)=theRobot.whereJ();
%         
%         disp(horzcat('Refined actuation  ',num2str(i), ' recorded'));
%         i=i+1;
%         save C:\Users\wberry\Documents\MATLAB\currentWorkspace.mat;
%     end
    dataSet(i,:)=ikineToolPosition(dP, dRobot,dPars(19:22),[realDataSet(i,:),3000],[4,5]);
    i=i+1;

end
dataSet=dataSet(1:acts,:);
% save('refinedDataSet.mat','dataSet');
% moveSpotSeeker('x',-d*stepsPerMM);
%Crunch d and the actuations to a parameter set.
options=optimset('MaxFunEvals',1000,'MaxIter',1000,'Algorithm',{'levenberg-marquardt',1e-6},'Display','off');
% dotError=@(X)errorDot(X,dataSet,d);
% [solvedPars,resnorm,residual,exitflag,output,lambda,jacobian] =lsqnonlin(dotError,Pars);
dotError=@(X)errorDot(X,dataSet,d);
[solvedPars,resnorm,residual,exitflag,output,lambda,jacobian] =lsqnonlin(dotError,Pars);

sdRobot=[solvedPars(1:14) bot(6,3) solvedPars(15:18) bot(6,4)];
sdRobot=reshape(sdRobot,[5,4]);
sdRobot=[bot(1,:); sdRobot];
sdRobot
