function [result,resnorm,residual,exitflag,output,lambda,jacobian]=dataAnalyser(parameterSet,fixedPars,dataSetMaster,actualParameterSet )
errorFunction=@(x)errorPlate(x,fixedPars,dataSetMaster);
options=optimset('MaxFunEvals',1000,'MaxIter',0,'Algorithm',{'levenberg-marquardt',1e-3},'Display','off');
[result,resnorm,residual,exitflag,output,lambda,jacobian]= lsqnonlin(errorFunction,parameterSet,[ ],[ ],options);



names=parameterNames;
for num=1:30
    outPut=fprintf('%s  %0+3.4f   %0+3.4f   %0+3.4f \n',names(num,:), actualParameterSet(num), parameterSet(num), result(num));
    
end
if ((length(parameterSet)-24)/6)~=1
    number=2;
    whichname=25;
    for plates=1:(length(parameterSet)-30)
        pos=30+plates;
        outPut=fprintf('%s  %0+3.4f   %0+3.4f   %0+3.4f \n',horzcat(names(whichname,:),num2str(number)), actualParameterSet(pos), parameterSet(pos), result(pos));
        whichname=whichname+1;
        if whichname>30
            whichname=25;
            number=number+1;
            
        end
    end
end
fprintf('\n \n \n')
formatSpec='%s   %+2.6f \n ';
for num=1:30
    
    diff=fprintf(formatSpec,names(num,:), (actualParameterSet(num)-result(num)));
end
formatSpec='%s  %+2.6f \n ';
if ((length(parameterSet)-24)/6)~=1
    number=2;
    whichname=25;
    
    for plates=1:(length(parameterSet)-30)
        pos=30+plates;
        diff=fprintf(formatSpec,horzcat(names(whichname,:),num2str(number)), (actualParameterSet(pos)-result(pos)));
        whichname=whichname+1;
        if whichname>30
            whichname=25;
            number=number+1;
            
        end
    end
    
end




end