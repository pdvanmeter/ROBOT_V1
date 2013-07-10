function [ good JhighEnough JlowEnough] = actuationGood(J)
% Checks if a given actuation is within the range of each joint supplied by
% Staubli. Returns a 1 for good, 0 for out of range. JhighEnough JlowEnough
% are two vectors that show which joint values are above the lower limit
% and below the higher limit respectivley.
minJ = [-160 (-137.5-90) (-142.5+90) -270 -105 -270]*pi/180;
% minJ(2)=-200*pi/180;
% maxJ(2)=30*pi/180;
maxJ = [ 160  (137.5-90)  (142.5+90)  270  120  270]*pi/180;
if(numel(J)<6)
    good=0;
else
    good= (sum(J(1:6)>=minJ)== 6) && (sum(J(1:6)<=maxJ)==6);
end
JhighEnough=(J(1:6)>minJ);
JlowEnough=(J(1:6)<maxJ);
end

