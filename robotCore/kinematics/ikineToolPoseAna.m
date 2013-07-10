function Js=ikineToolPoseAna(targetPose, robotPars, toolPars)
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
toolPars(5)=toolPars(5);
toolTransform=transXYZ(0,0,robotPars(6,4))*transformTool(toolPars);
zerothTrans=transXYZ(0,0,robotPars(1,4));
tp=targetPose/(toolTransform);
tp=zerothTrans\tp;
x=tp(1,4);
y=tp(2,4);
z=tp(3,4);
r=sqrt(x^2+y^2+z^2);
a=robotPars(3,2);
d=robotPars(4,4);
D=(+a^2+d^2-r^2)/(2*a*d);
if abs(D)>1
    Js='Point not in range'
    Js=0;
    return 
end
beta=atan2(sqrt(1-D^2),D);
alpha=atan2(d/r*sin(beta),sqrt(1-(d/r*sin(beta))^2));
theta=atan2(sqrt(x^2+y^2),z);
% there are 8 possible configurations where the robot is dextrous. This function
% will find them all but only return the real ones.
k=1;
Js=zeros(8,6);
for n1=-1:2:1;
    for n2=-1:2:1;
        for n3=-1:2:1;
            J(1)=atan2(n1*tp(2,4),n1*tp(1,4));
            J(2)=-pi/2+n1*theta+n2*alpha;
            if n2==-1
                J(3)=3*pi/2-beta;
            end
            if n2==1
                J(3)=-pi/2+beta;
            end
            tp0=(transformRobot(robotPars,J(1:3)))\tp;
            J(5)=atan2(n3*sqrt(1-tp0(2,3)^2),-tp0(2,3));
            J(4)=atan2(n3*tp0(3,3),n3*tp0(1,3));
            J(6)=-atan2(n3*tp0(2,2),n3*tp0(2,1));
            Js(k,:)=J;
            k=k+1;
        end
    end
end
end


