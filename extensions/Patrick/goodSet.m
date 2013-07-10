function [ good_set ] = goodSet( Jset )
%Creates a matrix of only the "good" joint actuations
%   Jset should be the output of ikineToolPoseAna().

% Create a matrix of values to check is a set is good
checkMatrix = checkActuationSet(Jset);
% Good set index
i = 1;

% Create a new matrix of only good sets
for n = 1:8
    if checkMatrix(n) == 1
        good_set(i,1:6) = Jset(n,1:6);
        i = i + 1;
    end
end

end

