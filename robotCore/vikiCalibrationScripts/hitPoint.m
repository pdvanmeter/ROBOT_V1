clear
targetPoint=[100,100,0,1]';
wrist=eye(4);
tool2wrist=transXYZ(100,50,10)*rotX(0);
rV=targetPoint(1:3);
r=norm(rV);
rVn=rV/r;
for n=1:2:1
ry=atan2(rVn(1),n*sqrt(1-rVn(1)^2));
rx=atan2(-rVn(2)/cos(ry),n*sqrt(1-(rVn(2)/cos(ry))^2));
rotWr=rotX(rx)*rotY(ry)
end
poseWr=rotWr;
poseWr(1:3,4)=rV;
rotT=poseWr*pinv(tool2wrist);


index=1;
hold on
for n=-1:2:1
    
    theta(index)=atan2(n*sqrt(1-rotT(3,3)^2),rotT(3,3));
%     phi(index)=atan2(n*sqrt(1-(rotT(1,3)/sin(theta(index)))^2),rotT(1,3)/sin(theta(index)));
    phi(index)=atan2(n*sqrt(1-(rotT(2,2))^2),rotT(2,2));
    rot(:,:,index)=rotZ(theta(index))*rotY(phi(index));
    [yaw pitch roll]=matrixToAngles(rot(:,:,index));
    i=1;
    for rr=0:r/10:r
        laserLine(:,i)=rot(:,:,index)*tool2wrist*[0,0,rr,1]';
        i=i+1;
    end
    toolOrigin=rot(:,:,index)*tool2wrist;
    scatter3(laserLine(1,:),laserLine(2,:),laserLine(3,:),'r','.');
    scatter3(targetPoint(1),targetPoint(2),targetPoint(3),'*','g');
    scatter3(toolOrigin(1,4),toolOrigin(2,4),toolOrigin(3,4),'*','r');
    scatter3(wrist(1,4),wrist(2,4),wrist(3,4),'*','b');
    
    
    index=index+1;
end
hold off
light                               % add a default light
daspect([1 1 1])                    % Setting the aspect ratio
view(3)                             % Isometric view
xlabel('X'),ylabel('Y'),zlabel('Z')
