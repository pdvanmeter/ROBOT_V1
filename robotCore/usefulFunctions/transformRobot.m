function [ T Geo] = transformRobot( Parm, J )
%Given a robot model and actuation, return the homogeneous transformation
%matrix relating coordinates in the last link frame to the lab frame.
T=[1  0  0  0;
    0  1  0  0;
    0  0  1  0;
    0  0  0  1];

for i=1:6
    theta=J(i)+Parm(i,3);
    if(i==3)
        alpha = Parm(i,1);
        a = Parm(i,2);
        beta = Parm(i,4);
        jointMatrix=rotX(alpha) * transXYZ(a,0,0) * rotY(beta) * rotZ(theta);
        
    else
        alpha = Parm(i,1);
        a = Parm(i,2);
        d = Parm(i,4);
        jointMatrix=rotX(alpha) * transXYZ(a,0,0) * rotZ(theta)* transXYZ(0,0,d);
        
    end
    T=T*jointMatrix;
    Geo(:,:,i)=(T);
end

end

