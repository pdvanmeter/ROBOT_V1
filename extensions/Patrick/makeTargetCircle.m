function [ circle ] = makeTargetCircle( center,radius,steps )
%Makes the circular path at center of given radius and # of steps. 
%   center is a vector of [x,y,z].

% Use makeCircle to generate a circle, then translate it by center vector.
circlePoints = makeCircle(radius);
for n = 1:length(circlePoints)
    for i = 1:3
            circlePoints(i,n) = circlePoints(i,n) + center(i);
    end
end

% Return a cirlce of "steps" number of entries if it is not 0.
% If it is 0 then return the full circle set.
if steps ~= 0
    jump = idivide(length(circlePoints),int16(steps));
    for n = 0:steps-1
        for i = 1:4
            circle(i,n+1) = circlePoints(i,1 + n*jump);
        end
    end
end

end