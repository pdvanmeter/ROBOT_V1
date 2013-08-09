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

% Vertical table
%sphereOrigin = [1050.7466; -318.16; 1244];
%tableOrigin = [1069.80,-708.16,688.4];
%tableYPR = [0,-pi/2,0];

% Horizontal table
%sphereOrigin = [1089.8; -317.5; 128.3] % Most recent measurement
sphereOrigin = [1088.4; -317.5; 130.6];
tableOrigin = [533.4,-711.2,117.475];
tableYPR = [0,0,0];             % YPR relative flat position


end

