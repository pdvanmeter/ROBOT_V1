function [ J ] = ikineToolPositionLsq(targetPosition, robotPars,toolPars,initialGuess,varargin)
options=optimset('MaxFunEvals',10000,'MaxIter',10000,'Algorithm',{'levenberg-marquardt',1e-6},'Display','off');
if nargin<5
    ikineError=@(x)errorToolPosition(x,targetPosition,robotPars,toolPars);
    exitflag=0;
    J=initialGuess;
    if(numel(initialGuess)==7)
        [J,resnorm,residual,exitflag] =lsqnonlin(ikineError,J,[],[],options);
    end
    if(exitflag<=0)
        do_while=1;
        J=randomActuation();
        while(~actuationGood(J) || do_while || exitflag<=0 || J(7)>100 || J(7)<40)
            J=randomActuation();
            T= transformRobot(robotPars,J);
            d=norm(T(1:4,4) - targetPosition);
            J=[J d];
            [J,resnorm,residual,exitflag] =lsqnonlin(ikineError,J,[],[],options);
            do_while=0;
        end
    end
else
    J=zeros(1,numel(varargin{1}));
    variableJoints=varargin{1};
    indexVar=1;
    for i=1:6
        if (indexVar<=numel(variableJoints))&&(variableJoints(indexVar)==i)
            J(indexVar)=initialGuess(i);
            indexVar=indexVar+1;
        end
    end
    J=[J,initialGuess(7)];
    
    ikineError=@(x)errorToolPosition(x,targetPosition,robotPars,toolPars, initialGuess,varargin);
%     exitflag=0;
    [result,resnorm,residual,exitflag,output,lambda,jacobian] =lsqnonlin(ikineError,J,[],[],options);
%     laser=result(end);
    result(end)=[];
%     index=1;
    varIndex=1;
    for i=1:6
        if (varIndex<=numel(variableJoints))&&(variableJoints(varIndex)==i)
            J(i)=result(varIndex);
            varIndex=varIndex+1;
        else
            J(i)=initialGuess(i);
        end
    end
%     point=transformRobot(modelRobot,J)*transformTool(modelLaser,0)*[0 0 laser 1]'
end
end

