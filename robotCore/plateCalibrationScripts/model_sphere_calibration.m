clear
pos=[100;200;300];
radius=4;
parameters=[pos; radius];


d_pos=normrnd(pos,1);
d_radius=normrnd(radius,0.001);
d_parameters=[d_pos; d_radius];
% collect data

phi=0;
numMeas=15;
theta=pi/2;

point(:,1)=d_pos + d_radius*[cos(0)*sin(0);sin(0)*sin(0);cos(0)];
k=2;
for i=1:numMeas
    theta=normrnd(pi/4, 0.2);
    point(:,k)=d_pos + d_radius*[cos(phi)*sin(theta);sin(phi)*sin(theta);cos(theta)];
    phi=normrnd(phi+2*pi/numMeas,0.2);
    k=k+1;
    theta=normrnd(pi/6,0.1);
    point(:,k)=d_pos + d_radius*[cos(phi)*sin(theta);sin(phi)*sin(theta);cos(theta)];
    k=k+1;
    phi=normrnd(phi+2*pi/numMeas,0.2);
end
% add noise
d_point=normrnd(point,0.008);
scatter3(d_point(1,:),d_point(2,:),d_point(3,:),'.');
hold on
scatter3(point(1,:),point(2,:),point(3,:),'.','r');
hold off
diff_point=point-d_point
daspect([1 1 1])  
x_0=d_parameters(1);
y_0=d_parameters(2);
z_0=d_parameters(3);
radius=d_parameters(4);
x=d_point(1,:);
y=d_point(2,:);
z=d_point(3,:);
error=(x-x_0).^2+(y-y_0).^2+(z-z_0).^2-radius^2;
error=sqrt(abs(error));


errorFunction=@(x)errorSphere(x,d_point);
options=optimset('MaxFunEvals',1000,'MaxIter',1e6,'TolFun',1e-12,'TolX',1e-300);
mini=[(pos -10); (radius -.001)];
maxi=[(pos +10); (radius +.001)];
[result,resnorm,residual,exitflag,output,lambda,jacobian]= lsqnonlin(errorFunction,parameters,mini,maxi,options);
jacobian=full(jacobian);
cov=pinv(jacobian'*jacobian)
diff=result-d_parameters
errorPose=norm(diff(1:3))