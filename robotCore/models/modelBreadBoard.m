function [ transBboard_room ] = modelBreadBoard(  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
position_board=[500; -750; 30; 1]; % position of the board origin in the room frame
boardRotation=[0,0,0]; % rotations from the room frame to the board frame (ZYZ)

transBboard_room=rotZ(boardRotation(1))*rotY(boardRotation(2))*rotZ(boardRotation(3));
transBboard_room(:,4)=position_board;


end

