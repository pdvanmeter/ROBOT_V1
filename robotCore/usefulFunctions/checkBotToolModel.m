function [meanOT stdvOT meanRT stdvRT]=checkBotToolModel(actualparameters,fitparameters,fixedPars)
bot=[actualparameters(1:14) fixedPars(5) actualparameters(15:18) fixedPars(6)];
bot=reshape(bot,[5,4]);
bot=[fixedPars(1:4); bot];

fitRobot=[fitparameters(1:14) fixedPars(5) fitparameters(15:18) fixedPars(6)];
fitRobot=reshape(fitRobot,[5,4]);
fitRobot=[fixedPars(1:4); fitRobot];


sensorScaleOffset=fixedPars(8);




sens=actualparameters(19:23);
sensScale=actualparameters(24);

fitSens=fitparameters(19:23);
fitSensorScale=fitparameters(24);


for i=1:10000
    J=randomActuation();
    d_J=deg2rad(round(rad2deg(J)*1e3)/1e3);

%     laserLine=normrnd((16207-161)/2+161,6000);
%     d_laserLine=round(laserLine);
% 
%     Zmagnitude=sensScale*(laserLine-sensorScaleOffset);
%     d_Zmagnitude=fitSensorScale*(d_laserLine-sensorScaleOffset);
    
    actualPose=transformRobot(bot,J)*transformTool(sens);
    
    fittedPose=transformRobot(fitRobot,d_J)*transformTool(fitSens);
    
    normalOT(i)=norm(fittedPose(1:3,4)-actualPose(1:3,4));
    normalRT(i)=norm(matrix2angles(actualPose)-matrix2angles(fittedPose));
end
meanOT=mean(normalOT);
stdvOT=std(normalOT);
meanRT=rad2deg((mean(normalRT)));
stdvRT=rad2deg((std(normalRT)));


end
