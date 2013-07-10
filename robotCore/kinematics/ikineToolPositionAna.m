function [JsRefined r]=ikineToolPositionAna(targetPoint, robotPars, toolPars)
% This function returns a vector of all the possible orientations of the
% tool for the targetPose. The possibilites are
% % 'l'   arm to the left
% % 'r'   arm to the right
% % 'u'   elbow up
% % 'd'   elbow down
% % 'n'   wrist not flipped
% % 'f'   wrist flipped (rotated by 180 deg)
% left right orientation means, if you are standing on the first joint facing
% the tool, the second link will be on your left or right respectivily.
%
% The order of them is;
% 1 'r' 'd' 'f'
% 2 'r' 'd' 'n'
% 3 'r' 'u' 'f'
% 4 'r' 'u' 'n'
% 5 'l' 'u' 'f'
% 6 'l' 'u' 'n'
% 7 'l' 'd' 'f'
% 8 'l' 'd' 'n'
JsRefined=100*ones(2,6);
while ~actuationGood(JsRefined(1,:))&&~actuationGood(JsRefined(2,:))
    actuation=randomActuation();
    actuation(1)=0;
    actuation(4:6)=0;
    % actuation=[0,-pi/2,pi/2,0,0,0];
    [robPose4]=transformRobot(robotPars,actuation(1:4));
    
    
%     toolTrans=transformTool(modelLaser,toolLength);
%     flange=makeTransform(0,0,110,0,0,0);
%     disp=flange*toolTrans;
    targetPointW=pinv(robPose4)*targetPoint;
    rV=targetPointW(1:3);
    r=norm(rV);
    index=1;
    Js=[actuation;actuation];
    JsRefined=[actuation;actuation];
    theta=zeros(1,2);
    phi=zeros(1,2);
    for n=-1:2:1
        theta(index)=atan2(n*sqrt(1-(rV(3)/r)^2),rV(3)/r);
        phi(index)=atan2(-n*sqrt(1-(rV(1)/(r*sin(theta(index))))^2),rV(1)/(r*sin(theta(index))));
        Js(index,4:5)=[phi(index) theta(index)];
%         transformRobot(robotPars,Js(index,:))*transformTool(toolPars,0)*transXYZ(0,0,r)
        JsRefined(index,1:6)=ikineToolPositionLsq(targetPoint, robotPars,toolPars,[Js(index,:),r],[4,5]);
%         transformRobot(robotPars,JsRefined(index,:))*transformTool(toolPars,0)*transXYZ(0,0,r)
        index=index+1;
    end
    
end

% for index=1:2
% transformRobot(robotPars,Js(index,:))*transformTool(toolPars,0)*transXYZ(0,0,r)
% end
% for index=1:2
% transformRobot(robotPars,JsRefined(index,:))*transformTool(toolPars,0)*transXYZ(0,0,r)
% end
% JsRefined-Js
end
