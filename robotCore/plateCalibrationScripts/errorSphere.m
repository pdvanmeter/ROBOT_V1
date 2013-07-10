function [error]=errorSphere(sphereParameters, data)
x_0=sphereParameters(1);
y_0=sphereParameters(2);
z_0=sphereParameters(3);
radius=sphereParameters(4);
x=data(1,:);
y=data(2,:);
z=data(3,:);
error=(x-x_0).^2+(y-y_0).^2+(z-z_0).^2-radius^2;
norm(error)
end
