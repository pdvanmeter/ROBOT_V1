function [ targetBox coordinateSet ] = MakeTargetBox( pointNumber, origin )
%MAKETARGETBOX Summary of this function goes here
%   Detailed explanation goes here

% Figure out the number of "slices" needed
n = pointNumber;

% Find x-y-z distibution, 2:3:1 ratio
baseSLice = n/6;
maxX = round(2*baseSLice) + 2;
maxY = round(3*baseSLice) + 2;
maxZ = round(baseSLice) + 2;

% Make point grid
index = 1;
for x = 0:maxX
    for y = 0:maxY
        for z = 0:maxZ
            coordinateSet(index,:) = origin + [x*(400/maxX),y*(600/maxY),z*(200/maxZ)];
            targetBox(:,:,index) = makeTransform(coordinateSet(index,1),coordinateSet(index,2),coordinateSet(index,3),0,pi,0);
            index = index + 1;
        end
    end
end

end

