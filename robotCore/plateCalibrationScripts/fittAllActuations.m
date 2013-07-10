calibRobotPars=modelRobot();
    calibRobotPars(1,:)=[];% not the 0th link, not calibrated, degenerate
    calibRobotPars=reshape(calibRobotPars,1,20);
    % with the plate orientation.
    calibRobotPars(20)=[]; %J_6 d arbitrarily set to 110mm
    calibRobotPars(15)=[]; %J_6 theta_0 arbitrarily set to 0
    % Nor does it include the 6th joint parameters theta_0 and d
    % since these paramters are arbitrary
    fixedPars=zeros(1,4); %link 0 parameters are zero
    fixedPars(5)=0; %the theta_0 is set to zero
    fixedPars(6)=0; %putting the tool on the end of the robot creates the end
    fixedPars(7)=radius;
    parameterSet=reshape(calibRobotPars,1,18);
    parameterSet=[parameterSet modelSensor];
    parameterSet=[parameterSet d];
    parameterSet=[parameterSet origin(1:3)' ];
    parameterSet=[parameterSet orientation];
    parameterSetMaster=[parameterSetMaster parameterSet];
    
    actualRobotPars=theRobot();
    actualRobotPars(1,:)=[];% not the 0th link, not calibrated, degenerate
    actualRobotPars=reshape(actualRobotPars,1,20);
    % with the plate orientation.
    actualRobotPars(20)=[]; %J_6 d arbitrarily set to 110mm
    actualRobotPars(15)=[]; %J_6 theta_0 arbitrarily set to 0
    % Nor does it include the 6th joint parameters theta_0 and d
    % since these paramters are arbitrary
    fixedPars=zeros(1,4); %link 0 parameters are zero
    fixedPars(5)=0; %the theta_0 is set to zero
    fixedPars(6)=0; %putting the tool on the end of the robot creates the end
    fixedPars(7)=radius;
    actualParameterSet=reshape(actualRobotPars,1,18);
    actualParameterSet=[actualParameterSet theSensor];
    actualParameterSet=[actualParameterSet d];
    actualParameterSet=[actualParameterSet d_origin(1:3)' ];
    actualParameterSet=[actualParameterSet d_orientation(1:3)];
    actualParameterSetMaster=[actualParameterSetMaster actualParameterSet];
    
    dataSetMaster=[dataSetMaster dataSet];
    
     errorFunction=@(x)errorPlate(x,fixedPars,dataSetMaster,planePoint);
        options=optimset('MaxFunEvals',10e3,'Algorithm',{'levenberg-marquardt',.001});
        [result,resnorm,residual,exitflag,output,lambda,jacobian]= lsqnonlin(errorFunction,parameterSetMaster,[ ],[ ],options);
    fittedRobot=[result(1:14) fixedPars(5) result(15:18) fixedPars(6)];
    fittedRobot=reshape(fittedRobot, [5,4]);
    fittedRobot=[fixedPars(1:4);fittedRobot];