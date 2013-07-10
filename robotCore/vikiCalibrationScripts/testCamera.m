%Given a point in world-space, and the pose of the camera in world-space,
%predict which pixel the point is mapped to in the image.
%{
cameraPose=rotZ(25*pi/180)*rotY(-5*pi/180)*rotZ(0);
%This is the camera position.
cameraPose(1,4)=-278;
cameraPose(2,4)=-3352.8;
cameraPose(3,4)=610;
%}
cameraPose=rotZ(90*pi/180)*rotY(0)*rotZ(0);
%This is the camera position.
cameraPose(1,4)=(-498-264)/2;
cameraPose(2,4)=-3352.8+152.4;
cameraPose(3,4)=550;

[x y]=world2Camera([(-498-264)/2; -3352.8; 714; 1], cameraPose, 2592, 1944)

%Camera orientation is 25 degrees about z, 0 about x, and 5 about y