function [ Parm ] = modelRobot()
%The DH and HR parameters that model our RX130.
%alpha a theta d/beta
Parm = [    0   0   0  550;
        -pi/2   0   0   0;
            0 625   0   0;
         pi/2   0   0 625;
         -pi/2  0   0   0;
         pi/2   0   0   110];
end
