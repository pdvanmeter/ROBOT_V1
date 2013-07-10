function [randomParameters parameterSet fixedPars]=generateParameters()
nma=0.001;
nml=0.9;
stdSnsScale=1e-5;
sensAngle=deg2rad(.1);
% radius=11.1125;
radius=4.7625;

bot=modelRobot();
theRobot = normrnd(bot,nml);
theRobot(:,1)=normrnd(bot(:,1),nma);
theRobot(:,3)=normrnd(bot(:,3),nma);
theRobot(3,4)=normrnd(bot(3,4),nma);
theRobot(1,:)=zeros(1,4);
theRobot(6,3)=0;
theRobot(6,4)=110;

sensor=modelSensor();
sensorScaleOffset=161;%lowest digital output or begin range DO
sensorScale=3.1160414e-3;%mm/count
theSensor=normrnd(sensor,nml);
theSensor(1:2)=normrnd(sensor(1:2),sensAngle);
d_sensorScale=normrnd(sensorScale,stdSnsScale);


actualRobotPars=theRobot;
actualRobotPars(1,:)=[];% not the 0th link, not calibrated, degenerate
actualRobotPars=reshape(actualRobotPars,1,20);
% with the plate orientation.
actualRobotPars(20)=[]; %J_6 d arbitrarily set to 110mm
actualRobotPars(15)=[]; %J_6 theta_0 arbitrarily set to 0
% Nor does it include the 6th joint parameters theta_0 and d
% since these paramters are arbitrary
randomParameters=reshape(actualRobotPars,1,18);
randomParameters=[randomParameters theSensor];
randomParameters=[randomParameters d_sensorScale];

calibRobotPars=modelRobot();
calibRobotPars(1,:)=[];% not the 0th link, not calibrated, degenerate
calibRobotPars=reshape(calibRobotPars,1,20);
% with the plate orientation.
calibRobotPars(20)=[]; %J_6 d arbitrarily set to 110mm
calibRobotPars(15)=[]; %J_6 theta_0 arbitrarily set to 0
% Nor does it include the 6th joint parameters theta_0 and d
% since these paramters are arbitrary
fixedPars=bot(1,1:4); %link 0 parameters are zero
fixedPars(5)=0; %the theta_6 is set to zero
fixedPars(6)=theRobot(6,4); 
fixedPars(7)=radius;
fixedPars(8)=sensorScaleOffset;
parameterSet=reshape(calibRobotPars,1,18);
parameterSet=[parameterSet modelSensor];
parameterSet=[parameterSet sensorScale];
end
