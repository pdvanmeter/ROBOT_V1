function [ J ] = ikineToolPoseLsq(targetPose, robotPars, toolPars, initialGuess)
ikineError=@(x)errorToolPose(x,targetPose,robotPars, toolPars);
exitflag=0;
J=initialGuess;
if(numel(initialGuess)==6)
    [J,resnorm,residual,exitflag] =lsqnonlin(ikineError,J);
end
while(~actuationGood(J) || exitflag<=0)
    J=randomActuation();
    [J,resnorm,residual,exitflag] =lsqnonlin(ikineError,J);
end

end

