r=6.35;
CenterPoint=[1250.1078, -323.103, 128.49];
  dirVector= rand(1,3);
dirVector= dirVector / norm(dirVector,2)
CenterPoint = CenterPoint + r*dirVector;
SurfacePoint=ones(10,3);

for i=1:9
  dirVector= rand(1,3);
dirVector= dirVector / norm(dirVector,2)
    SurfacePoint(i,:)=CenterPoint + r*dirVector;
end
%errorSphere(SurfacePoint(1,:),r,CenterPoint)
%Try to recover the CenterPoint from r and a collection of SurfacePoints.

%errorSphere(SurfacePoint,r,SurfacePoint(1,:));

sphereError=@(x)errorSphere(SurfacePoint,r,x);
dirVector = rand(1,3);
dirVector = 5* dirVector/norm(dirVector,2);
theFit= lsqnonlin(sphereError,CenterPoint+dirVector);
theFit
