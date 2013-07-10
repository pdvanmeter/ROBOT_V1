function [ theModelPartial ] = modelSensorPartial(Partno,dpar)
%thetaX thetaY pX pY pZ

%theModel= [0,0,-59.99,28.66,180];


%[model position orientation drillBit]=modelDrill_1();
%theModel=[0,0,drillBit];

 %theModelerror=[0.0005,0.0005,0.05,0.05,0.05];   

    theModel=[0,0,3.4,-96.5,69.5];
 
        theModelPartial=theModel;

for i=25:29;
    j=24;
    if i==Partno;

 %theModelPartial(i-j)=theModel(i-j)+theModelerror(i-j);
 theModelPartial(i-j)=theModel(i-j)+dpar;
       
     end
end

