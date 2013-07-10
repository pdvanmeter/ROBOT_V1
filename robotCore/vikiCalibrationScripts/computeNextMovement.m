function [Js ] = computeNextMovement(theModel,robotParameters,laserModel,targetPoint,oldJ)
%COMPUTENEXMOVEMENT Summary of this function goes here
%   Detailed explanation goes here
Js=100*ones(2,6);
degenerate=1;
i=1;
robotCrashes=1;
laserObscured=1;
while ~actuationGood(Js(degenerate,:))&&(robotCrashes || laserObscured)
 Js = ikineToolPositionAna(targetPoint,robotParameters,laserModel,0);
    for degenerate=1:2
        
        J=Js(degenerate,:);
        [robotCrashes laserObscured]=theModel.setJ(J);
        if (robotCrashes || laserObscured)
            break
        else
%             [robotCrashes laserObscured] = theModel.moveJ(oldJ, J(1:6));
%             if(robotCrashes || laserObscured)
%                 theModel.setJ(oldJ);
%             else
        Js=Js;
                i=i+1;
%             end
        end
    end


end

