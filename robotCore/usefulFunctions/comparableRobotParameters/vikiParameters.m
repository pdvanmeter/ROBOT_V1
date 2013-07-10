function [minErrorParameters meanParameters meanMeanA stdMeanA meanMeanL stdMeanL meanMinA stdMinA meanMinL stdMinL maxMeanA maxMeanL maxMinA maxMinL]=vikiParameters()
minErrorParameters=[
    -89.98056
    0.0069
-89.9890+180
90.0089-180
-90.0251+180

    0.0691
    625.5086
-0.0002
-0.5263
0.5308

-0.0021
-179.9982+180
0.0369
-0.0971

0.6889
-0.0430
626.2451
0.5468];

meanParameters=[
    -89.9812
    0.0072
-89.9876+180
90.0096-180
-90.0234+180

    0.0702
    625.5063
-0.0029
-0.5243
0.5342

-0.0033
-180.0025+180
0.0376
-0.0996

0.6831
-0.0455
626.2431
0.5451];
minErrorParameters(1:5)=deg2rad(minErrorParameters(1:5));
minErrorParameters(11:14)=deg2rad(minErrorParameters(11:14));
minErrorParameters(16)=deg2rad(minErrorParameters(16));

meanParameters(1:5)=deg2rad(meanParameters(1:5));
meanParameters(11:14)=deg2rad(meanParameters(11:14));
meanParameters(16)=deg2rad(meanParameters(16));
[randomParamters parameterSet fixedPars]=generateParameters();

diffMean=parameterSet(1:18)'-meanParameters;
diffMeanA=[diffMean(1:5);diffMean(11:14);diffMean(16)];
diffMeanL=[diffMean(6:10);diffMean(15);diffMean(17:18)];
meanMeanA=mean(diffMeanA);
stdMeanA=std(diffMeanA);
meanMeanL=mean(diffMeanL);
stdMeanL=std(diffMeanL);
maxMeanA=max(diffMeanA);
maxMeanL=max(diffMeanL);

diffMin=parameterSet(1:18)'-minErrorParameters;
diffMinA=[diffMin(1:5);diffMin(11:14);diffMin(16)];
diffMinL=[diffMin(6:10);diffMin(15);diffMin(17:18)];
meanMinA=mean(diffMinA);
stdMinA=std(diffMinA);
meanMinL=mean(diffMinL);
stdMinL=std(diffMinL);
maxMinA=max(diffMinA);
maxMinL=max(diffMinL);

