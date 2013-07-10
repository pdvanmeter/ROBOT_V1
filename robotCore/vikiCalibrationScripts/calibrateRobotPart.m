options=optimset('MaxFunEvals',1000,'MaxIter',1000,'Algorithm',{'levenberg-marquardt',1e-6},'Display','off');
% dotError=@(X)errorDot(X,dataSet,d);
% [solvedPars,resnorm,residual,exitflag,output,lambda,jacobian] =lsqnonlin(dotError,Pars);
dotError=@(X)errorDot(X,dataSet,d);
[solvedPars,resnorm,residual,exitflag,output,lambda,jacobian] =lsqnonlin(dotError,Pars);

robot=[solvedPars(1:14) bot(6,3) solvedPars(15:18) bot(6,4)];
robot=reshape(robot,[5,4]);
robot=[bot(1,:); robot];
robot
