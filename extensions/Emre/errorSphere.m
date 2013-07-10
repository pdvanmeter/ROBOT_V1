function [ errVector ] = errorSphere( SurfacePoint, r, CenterPoint)
errVector=zeros(1,10);
for i=1:9,   
residue = (CenterPoint - SurfacePoint(i,:))
   residue.*residue
   
errVector =[errVector (r - norm(CenterPoint - SurfacePoint(i,:),2))];
end
errVector
end

