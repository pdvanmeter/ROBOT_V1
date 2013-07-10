
dotError=@(X)errorDot(X,dataSet,d);
options=optimset('MaxFunEvals',1000,'MaxIter',0,'Algorithm',{'levenberg-marquardt',1e-3},'Display','off');
[result,resnorm,residual,exitflag,output,lambda,jacobian] =lsqnonlin(dotError,Pars,[ ],[ ],options);

% if resnorm>0
%     Pars=randomChangeParms(result,times);
% else
    Pars=result;
% end
format long
rndChng=result'-Pars';
[result' Pars']
format short
amountRandomChange=[amountRandomChange norm(rndChng)]
times=times

cov=pinv(jacobian'*jacobian);
times=times+1;
pause;