
[result,resnorm,residual,exitflag,output,lambda,jacobian]=dataAnalyser(parameterSolve,fixedPars,dataSetMaster,actualParameterSet);
mainResults=[mainResults; result];
% if times>1
observeConvergence=[observeConvergence (abs(mainResults(end-1,:)'-actualParameterSet')>abs(result'-actualParameterSet'))];
observeDivergence=[observeDivergence (abs(mainResults(end-1,:)'-actualParameterSet')<abs(result'-actualParameterSet'))];
% else
%     observeConvergence=zeros(length(result),1);
% end
% names=parameterNames;
% 'ObservedConvergence'
% for num=1:30
%     outPut=fprintf('%s  %s \n',names(num,:), num2str(observeConvergence(num,:)));
%     
% end
% if ((length(parameterSolve)-24)/6)~=1
%     number=2;
%     whichname=25;
%     for plates=1:(length(parameterSolve)-30)
%         pos=30+plates;
%         outPut=fprintf('%s  %s \n',horzcat(names(whichname,:),num2str(number)),  num2str(observeConvergence(num,:)));
%         whichname=whichname+1;
%         if whichname>30
%             whichname=25;
%             number=number+1;
%             
%         end
%     end
% end
% sumConv=[sumConv length(find(observeConvergence(:,end)))]
% fprintf('\n \n \n')
% 
% 'ObservedDivergence'
% for num=1:30
%     outPut=fprintf('%s  %s \n',names(num,:), num2str(observeDivergence(num,:)));
%     
% end
% if ((length(parameterSolve)-24)/6)~=1
%     number=2;
%     whichname=25;
%     for plates=1:(length(parameterSolve)-30)
%         pos=30+plates;
%         outPut=fprintf('%s  %s \n',horzcat(names(whichname,:),num2str(number)),  num2str(observeDivergence(num,:)));
%         whichname=whichname+1;
%         if whichname>30
%             whichname=25;
%             number=number+1;
%             
%         end
%     end
% end
% sumDiv=[sumDiv length(find(observeDivergence(:,end)))]
% numConverge=length(find(observeConvergence))
% numDiverge=length(find(observeDivergence))
% diffConDiv=[diffConDiv (numConverge-numDiverge)]
% ratioConverge2Diverge=numConverge/numDiverge
% fprintf('\n \n \n')
if resnorm>0
    parameterSolve=randomChangeParms(result,times);
else
    parameterSolve=result;
end
format long
rndChng=result'-parameterSolve';
format short
amountRandomChange=[amountRandomChange norm(rndChng)]
times=times

cov=pinv(jacobian'*jacobian);
[meanOT stdvOT meanRT stdvRT]=checkBotToolModel(actualParameterSet,result,fixedPars);
errorsInPositionTG=[errorsInPositionTG meanOT stdvOT]
errorsInOrientationTG=[errorsInOrientationTG meanRT stdvRT];
normalResidual=[normalResidual resnorm]
times=times+1;
