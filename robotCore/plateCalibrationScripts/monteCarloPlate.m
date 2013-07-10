mcresult=[];
for i=1:10
[dataSet pointsOutOfRange missSphere missActuation  missWhichSphere missWhichActuation errorVector ] = collectData(mover, result, fixedPars, plate,d_plate,actualParameterSet);
errorsInPositionTG=[];
errorsInOrientationTG=[];
errorsInPositionTG=[errorsInPositionTG meanOT stdvOT]
errorsInOrientationTG=[errorsInOrientationTG meanRT stdvRT];
parameterSolve=parameterSet;
% parameterSolve=actualParameterSet;
errorsInPositionT=[];
errorsInPositionG=[];
errorsInOrientationG=[];

mainResults=parameterSet;
observeConvergence=[];
observeDivergence=[];
diffConDiv=[];
sumConv=[];
sumDiv=[];
amountRandomChange=[];
times=1;
normalResidual=[];
% for times=1:100
%     iterate
% end
iterate
while resnorm>10
    iterate
end
mcresult=[mcresult; result];
end
