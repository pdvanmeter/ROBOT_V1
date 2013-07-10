function [x y ] = findLaser( lit,dark )
global currentImage;
global laserView;
%FINDLASER
%Computes the centroid of the laser dot within lit.
%dark is the background.
diff=imsubtract(lit,dark);
% level=graythresh(diff);
level=0.4;
BW = im2bw(diff,level);
figure(laserView);
image(lit);
image(dark);
image(diff);
BW = imfill(BW,'holes');
theProps = regionprops(BW,'all');

%Pick the region with the biggest area and spit out its centroid.
theMax = 1;
for i=1:size(theProps,1),
    if(theProps(i).Area >  theProps(theMax).Area)
        theMax =i;
    end
end

x=theProps(theMax).Centroid(1);
y=theProps(theMax).Centroid(2);
boundaries = bwboundaries(BW);
thisBoundary = boundaries{theMax};

%OLD WAY:
%[I J] = find(BW);
%y=median(I)
%x=median(J)

figure(laserView);
hold
plot (x,y,'+',thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
hold off
end

