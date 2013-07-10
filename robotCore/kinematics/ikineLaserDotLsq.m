function [ J ] = ikineLaserDotLsq(targetPose, robotPars,toolPars,initialGuess)
ikineError=@(x)errorToolPose(x,targetPose,robotPars,toolPars);
exitflag=0;
J=initialGuess;
options=optimset;
options=optimset(options,'TolFun',1e-8);
options=optimset(options,'MaxFunEvals',7000);
options=optimset(options,'MaxIter',1000);
options=optimset(options,'Display','off');
if(numel(initialGuess)==7)
    [J,resnorm,residual,exitflag] =lsqnonlin(ikineError,J,[],[],options);
end
if(exitflag<=0 || ~actuationGood(J))
    do_while=1;
    J=randomActuation();
    while(~actuationGood(J) || do_while || exitflag<=0)
        J=randomActuation();
        T= transformRobot(robotPars,J)*transformTool(toolPars);
        d=norm(T(1:4,4) - targetPose(1:4,4));
        J=[J d];
        [J,resnorm,residual,exitflag] =lsqnonlin(ikineError,J,[],[],options);
        do_while=0;
    end
end
end

