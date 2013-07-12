function [ good_actuations ] = checkActuationSet( Jset )
% Checks if any actuations in a set are good using actuationGood() function.
% Sepecifically for the output of the ikineToolPoseAna() function (8 elements).
%   Returns a matrix: 1 is true, 0 is false

good_actuations = [0,0,0,0,0,0,0,0];
for n = 1:8
    if actuationGood(Jset(n,:)) == 1
        good_actuations(n) = 1;
    end
end

end

