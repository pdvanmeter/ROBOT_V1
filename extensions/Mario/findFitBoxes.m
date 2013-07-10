% function that takes the 3d object and the number of boxes desired and
% returns the boxes that closest fit to the object.
% function [verts]=findBestFit(obj,numberOfBoxes)
clear;clf;
obj=meshModel('modelDrill.stl');
verts=obj.V;
%     initial guess. divide a full box into the number of boxes desired
%     Start by deviding along the longest dimention of the object. Perhaps
%     in the future alow the boxes to be ordered in all dimentions.
k=sort(verts);
minXYZ=k(1,:);
maxXYZ=k(end,:);
extent=maxXYZ-minXYZ;
longDimMask=max(extent)==extent;
variableDimMask=(~longDimMask);
segmentLength=extent(longDimMask);
numBoxes=9;
pointA=minXYZ;
pointB=maxXYZ;
%     There are 8 unique verticies per box. Starting from the lowest XYZ.
Vertices=zeros(8,3,numBoxes);
for i=1:1
    pointA(longDimMask)=minXYZ(longDimMask)+(i-1)*segmentLength/numBoxes;
    pointB(longDimMask)=minXYZ(longDimMask)+i*segmentLength/numBoxes;
    [tri(:,:,i) Vertices(:,:,i) Faces ]=twoPoints2box(pointA, pointB);
    patch('Faces',Faces,'Vertices', Vertices(:,:,i) ,'faceAlpha', .1)
end
light                               % add a default light
daspect([1 1 1])                    % Setting the aspect ratio
view([90 30])                             % rotation around z from -y axis, rotation above xy plane
%             xlim([00,1000])                  % set viewing window
%             ylim([-400,400])
%             zlim([100,500])                        % Isometric view

xlabel('X'),ylabel('Y'),zlabel('Z')

[pointA pointB]=box2twoPoints(Vertices(:,:,1));
movement=2;
iter=1;
movingMask=[true false false];
minPoint=pointA;
maxPoint=pointB;
test=pointB;
test(movingMask)=(pointB(movingMask)-pointA(movingMask))/2;
% while movement>1
%     if isect(
% end


% end
%     A fit function that finds a minimum summed volume of the boxes that
%     still enclose the 3d object.
%     Use isect to make sure that the box is not too small.