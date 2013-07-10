function [tri vertices faces ]=twoPoints2box(pointA, pointB)
vertices=...
    [pointA(1) pointA(2) pointA(3)
    pointB(1) pointA(2) pointA(3)
    pointA(1) pointB(2) pointA(3)
    pointB(1) pointB(2) pointA(3)
    pointA(1) pointA(2) pointB(3)
    pointB(1) pointA(2) pointB(3)
    pointA(1) pointB(2) pointB(3)
    pointB(1) pointB(2) pointB(3)];
% faces=...
%     [1 2 3; %bottom
%     2 3 4;
%     5 6 7; %top
%     6 7 8;
%     1 2 5; %front
%     2 5 6;
%     3 4 7; %back
%     4 7 8;
%     1 3 5; %left
%     3 5 7;
%     2 4 6; %right
%     4 6 8];
faces=...
   [1 3 5; %left x low
    3 5 7;
    2 4 6; %right x high
    4 6 8;
    1 2 5; %front y low
    2 5 6;
    3 4 7; %back y high
    4 7 8;
    1 2 3; %bottom z low
    2 3 4;
    5 6 7; %top z high
    6 7 8];
tri=zeros(36,3);
k=1;
for i=1:size(faces,1)
    for j=1:3
        tri(k,:)=vertices(faces(i,j),:);
        k=k+1;
    end
end
    
end