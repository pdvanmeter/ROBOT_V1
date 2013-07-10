function [drillModel transBit_Flng transTool2Flng transBit2tool]=modelDrill()
% A good way to build and understand these files is to display the .stl
% file using meshmodel and find the coordinate transforms FROM the points
% of intrest TO the .slt file frame.

position_flange_origin_raw=[159.98; 69.45; 22.185; 1]; % position of the flange origin in the tool frame
flange2toolRot=[pi/2,0, pi/2]; % rotations from the flange frame to the tool frame (XYZ)

position_bit_raw=[21.61; -56.64; 22.21; 1]; % position of the origin of the bit in the tool frame
bit2toolRot=[pi/2,0, pi/2]; % rotations from the bit to the tool frame (XYZ)

% This builds the transformation from the flange frame to the .stl file
% coordinate frame of the tool

transFlng2tool=rotX(flange2toolRot(1))*rotY(flange2toolRot(2))*rotZ(flange2toolRot(3));
transFlng2tool(:,4)=position_flange_origin_raw;
transTool2Flng=pinv(transFlng2tool);

% This builds the transformation from the drill bit frame to the .stl file
% coordinate frame of the tool

transBit2tool=rotX(bit2toolRot(1))*rotY(bit2toolRot(2))*rotZ(bit2toolRot(3));
transBit2tool(:,4)=position_bit_raw;

transBit_Flng=transTool2Flng*transBit2tool;

drillModel=[0 0 transBit_Flng(1:3,4)'];
end