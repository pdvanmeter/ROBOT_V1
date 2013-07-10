function [ placedPoints ] = placePoints( points )
%placePoints Translate and transform points from an original location
%   Location is currently hardcoded. May want to extend this later.
placedPoints = makeTransform(1000,0,170,0,0,pi)*points;

end

