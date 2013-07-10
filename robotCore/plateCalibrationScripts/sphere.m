clear
centerPoint=[700;0;550];
radius=200;
revolutions=1;
stepSize=0.1;
phi=0;
theta=0;
i=1;
theta=0;
while theta<pi
    xyz(:,i)=centerPoint+[radius*cos(phi)*sin(theta);radius*sin(phi)*sin(theta);radius*cos(theta)];
    theta=theta+revolutions*pi/500;
    phi=phi+revolutions*2*pi/100;
    
    i=i+1;
end

scatter3(xyz(1,:),xyz(2,:),xyz(3,:),'.')
daspect([1 1 1])                    % Setting the aspect ratio
xlabel('X'),ylabel('Y'),zlabel('Z')