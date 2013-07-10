function [ tableYPR tableOrigin sphereGrid sphereOrigin ] = modelTableAndSpheres( )
%GETTABLECONFIGURATION Single location to modify the table
%position/orientation
%   The intent of this file is to act as a single repository for
%   information related to the current table and sphere configuration for
%   the plate calibration procedure. Instead of hardcoding this information
%   into various scripts, the information will be fetched from here, and
%   therefore only minor changes to this function are required to change
%   the table's position in all related applications.

% Note: the measurements in English units (in), as they were originally
% taken.
%
%    sphereGrid = [  0     0     0       0       -6.5    -13     -13     -13     -13     -6.5 ;
%                    0     10    20      30      30      30      20      10      0       0    ;
%                    0.0   0.0   0.0     0.0     .005    .005    .005    .005    .005    .005 ;
%                    1     1     1       1       1       1       1       1       1       1   ];

% Measurements in mm
sphereGrid = [  0     0     0       0       -165.1 -330.2   -330.2  -330.2  -330.2  -165.1;
                0     254   508     762     762    762      508     254     0       0.00  ;
                0.0   0.0   0.0     0.0     .127   .127     .127    .127    .127    .127  ;
                1     1     1       1       1      1        1       1       1       1    ];
sphereOrigin = [1000.7466; -318.16; 900];
tableOrigin = [1019.80,-708.16,344.4];
tableYPR = [0,-pi/2,0];             % YPR relative flat position
    
%sphereOrigin = [1005,-318.5,900];
%tableOrigin = [1024.05,-712.3,341.2];


end

