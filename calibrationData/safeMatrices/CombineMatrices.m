% Script to quickly combine the different safeMatrix components.
% Syntax: safeMatrix(i,j,k)
% i = pose number
% j = sphere number
% k = joint number

% Start with the first one
load('C:\Users\wberry\Documents\MATLAB\ROBOT_V1\calibrationData\safeMatrices\safeMatrix.mat')
s = safeMatrix;

% Add in the nonzero elements for 2
load('C:\Users\wberry\Documents\MATLAB\ROBOT_V1\calibrationData\safeMatrices\safeMatrix2.mat')
for i = 1:size(safeMatrix,1)
    for j = 1:size(safeMatrix,2)
        for k = 1:size(safeMatrix,3)
            if safeMatrix(i,j,k) ~= 0
                s(i,j,k) = safeMatrix(i,j,k);
            end
        end
    end
end

% Add in the nonzero elements for 3
load('C:\Users\wberry\Documents\MATLAB\ROBOT_V1\calibrationData\safeMatrices\safeMatrix3.mat')
for i = 1:size(safeMatrix,1)
    for j = 1:size(safeMatrix,2)
        for k = 1:size(safeMatrix,3)
            if safeMatrix(i,j,k) ~= 0
                s(i,j,k) = safeMatrix(i,j,k);
            end
        end
    end
end

% Add in the nonzero elements for 4
load('C:\Users\wberry\Documents\MATLAB\ROBOT_V1\calibrationData\safeMatrices\safeMatrix4.mat')
for i = 1:size(safeMatrix,1)
    for j = 1:size(safeMatrix,2)
        for k = 1:size(safeMatrix,3)
            if safeMatrix(i,j,k) ~= 0
                s(i,j,k) = safeMatrix(i,j,k);
            end
        end
    end
end

% Poses for 6 are the same as for 5
s(6,1:10,1:6) = s(5,1:10,1:6);

safeMatrix = s;