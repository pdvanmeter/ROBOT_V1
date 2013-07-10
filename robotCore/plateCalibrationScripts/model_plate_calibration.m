
clear
% mover = RX130('COM6');
mover='mover';
nmo=1;
nma=0.001;

[plate d_plate]=modelPlate();

[actualParameterSet parameterSet fixedPars]=generateParameters();
% [minErrorParameters meanParameters meanMeanA stdMeanA meanMeanL stdMeanL meanMinA stdMinA meanMinL stdMinL maxMeanA maxMeanL maxMinA maxMinL]=vikiParameters()
% actualParameterSet(1:18)=meanParameters(1:18);
dataSetMaster=[];
missActuationTotal=[];
missWhichSphereTotal=[];

for che=1:1:1
    switch che
        case 1
            %             origin=[461 -150.00 -450];
            %             origin=[740 -176.00 -481];
            [origin orientation]=modelPlatePose();
        case 2
            origin=[753 100.00 -250];
            orientation=[deg2rad(0) deg2rad(-90) deg2rad(0)];
        case 3
            origin=[595 322 -481];
            orientation=[deg2rad(0) deg2rad(0) deg2rad(-90)];
        case 4
            origin=[470 300.00 -450];
            orientation=[deg2rad(0) deg2rad(-45) deg2rad(-45)];
            
    end
    
    d_origin=normrnd(origin,nmo);
    d_orientation=normrnd(orientation, nma);
    
    parameterSet=[parameterSet origin(1:3) ];
    parameterSet=[parameterSet orientation];
    
    actualParameterSet=[actualParameterSet d_origin(1:3) ];
    actualParameterSet=[actualParameterSet d_orientation(1:3)];
    
    [dataSet pointsOutOfRange missSphere missActuation  missWhichSphere missWhichActuation errorVector ]  = collectData(mover,parameterSet, fixedPars, plate,d_plate,actualParameterSet);
    
    dataSetMaster=[dataSetMaster dataSet];
    missSphere=missSphere
    missWhichSphere=missWhichSphere;
    missWhichSphereTotal=[missWhichSphereTotal missWhichSphere];
    missActuation=missActuation
    missActuationTotal=[missActuationTotal missActuation];
    pointsOutOfRange=pointsOutOfRange
end
actualParameterSet'-parameterSet'
[meanOT stdvOT meanRT stdvRT]=checkBotToolModel(actualParameterSet,parameterSet,fixedPars);
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
