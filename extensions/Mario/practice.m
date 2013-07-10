clear;clf;
drill=meshModel('modelDrill.stl');
light                               % add a default light
daspect([1 1 1])                    % Setting the aspect ratio
view([90 30])                             % rotation around z from -y axis, rotation above xy plane
xlabel('X'),ylabel('Y'),zlabel('Z');
set(drill.P,'facec',[.6,.6,.6]);
