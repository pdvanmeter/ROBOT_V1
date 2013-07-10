position_board=[500; -750; 30; 1]; % position of the board origin in the room frame
boardRotation=[0,0,0]; % rotations from the room frame to the board frame (XYZ)

transBboard_room=rotX(boardRotation(1))*rotY(boardRotation(2))*rotZ(boardRotation(3));
transBboard_room(:,4)=position_board;

clf
drill=meshModel('breadBoardSimple.stl');
set(drill.P,'facec', [.3,.3,.3]);
set(drill.P,'FaceAlpha', .4);
light                               % add a default light
daspect([1 1 1])                    % Setting the aspect ratio
view([90 0])                             % rotation around z from -y axis, rotation above xy plane
% xlim([-100,6000])                  % set viewing window
% ylim([-3500,3500])
% zlim([-100,4900])                        % Isometric view
xlabel('X'),ylabel('Y'),zlabel('Z')
hold on
x=0;
y=0;
z=0;
scatter3(x,y,z,'.');
% scatter3(x+10,y,z,'x');
% scatter3(x,y+10,z,'o');
% scatter3(x,y,z+10,'+');
% scatter3(22,-55,23,'.');

hold off
pause
clf
 
drill=meshModel('breadBoardSimple.stl',(transBboard_room));
set(drill.P,'facec', [.3,.3,.3]);
set(drill.P,'FaceAlpha', .1);
light                               % add a default light
daspect([1 1 1])                    % Setting the aspect ratio
view([90 20 ])                             % rotation around z from -y axis, rotation above xy plane
% xlim([-100,6000])                  % set viewing window
% ylim([-3500,3500])
% zlim([-100,4900])                        % Isometric view
xlabel('X'),ylabel('Y'),zlabel('Z')
hold on
x=0;
y=0;
z=0;
scatter3(x,y,z,'.');
scatter3(x+10,y,z,'x');
scatter3(x,y+10,z,'o');
scatter3(x,y,z+10,'+');
hold off