while(i<=acts)
    P=dataPars(23:25)';
    if(i>acts/2)
        P=P-d*[cos(translationAngles(1))*cos(translationAngles(2)) sin(translationAngles(1))*cos(translationAngles(2)) -sin(translationAngles(2))]';
    end
    %     figure(modelView);
    %     hold
    %     scatter3(P(1),P(2),P(3),'g','*');
    %     hold off
    
    P=[P; 1];
%     if(i==(acts/2+1))
%         %Move the target a meter using the spot seeker.
%         moveSpotSeeker('x',d*stepsPerMM);
%     end
    Js = ikineToolPositionAna(P,bot,dataPars(19:22),0);
    J=Js(1,:);
    [robotCrashes laserObscured]=theModel.setJ(J);
    while (robotCrashes || laserObscured)
        Js = ikineToolPositionAna(P,bot,dataPars(19:22),0);
        J=Js(1,:);
        [robotCrashes laserObscured]=theModel.setJ(J);
    end
    theRobot.moveJ(J);
    statusOfLock=lockTarget(theRobot,theRanger, targetX, targetY);
    if statusOfLock==0;
        disp('Could not lock on. Data point not recorded');
    else
        dataSet(i,:)=theRobot.whereJ();
        disp(horzcat('Refined actuation  ',num2str(i), ' recorded'));
        i=i+1;
    end
end
dataSet=dataSet(1:acts,:);
save('refinedDataSet.mat','dataSet');
moveSpotSeeker('x',-d*stepsPerMM);
%Crunch d and the actuations to a parameter set.
options=optimset('MaxFunEvals',1000,'MaxIter',1000,'Algorithm',{'levenberg-marquardt',1e-6},'Display','off');
% dotError=@(X)errorDot(X,dataSet,d);
% [solvedPars,resnorm,residual,exitflag,output,lambda,jacobian] =lsqnonlin(dotError,Pars);
dotError=@(X)errorDot(X,dataSet,d,Pars);
[solvedPars,resnorm,residual,exitflag,output,lambda,jacobian] =lsqnonlin(dotError,Pars(19:22));

robot=[solvedPars(1:14) bot(6,3) solvedPars(15:18) bot(6,4)];
robot=reshape(robot,[5,4]);
robot=[bot(1,:); robot];
robot
