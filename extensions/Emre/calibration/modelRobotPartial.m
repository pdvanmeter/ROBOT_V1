function [Parmpartial ] = modelRobotPartial(Parno,dpar)
%The DH and HR parameters that model our RX130.
%alpha a theta d/beta

Parm = [    0   0   0  550;
        -pi/2   0   0   0;
            0 625   0   0;
         pi/2   0   0 625;
         -pi/2  0   0   0;
         pi/2   0   0   110];
     
     
   % RobParmerror = [    0   0   0  0;
    %    0.0005   0.0005   0.0005   0.0005;
     %       0.0005 0.0005   0.0005  0.0005;
      %   0.0005   0.0005   0.0005 0.0005;
       %  0.0005  0.0005   0.0005   0.0005;
        % 0.0005   0.0005   0   0];
     
     

     
         Parmpartial=Parm;  
for j=1:6;
       for k=1:4;
         i=k+4*(j-1);      
    
   
    
       if Parno==i;     

        % Parmpartial(j,k)= Parm(j,k)+RobParmerror(j,k);
         Parmpartial(j,k)= Parm(j,k)+dpar;
         
       end
       end
           
end
       

     
     
     
     
     
     
     
