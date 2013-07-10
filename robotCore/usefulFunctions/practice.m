% clear
radius=100;
pathLength=2*pi*radius;
stepsize=.1;
steps=round(pathLength/stepsize);

angleSize=deg2rad(0.1);

theta=0;
phi=0;
total=zeros(6,1);
path=zeros(6,1);
R=zeros(3,1);
A=zeros(3,1);
J=deg2rad([   0.001   -34.822   196.123     0.000    18.698     0.003]);
bot=modelRobot();
sens=modelSensor();
toolLength=180;
centerPose=transformRobot(bot,J)*transformTool(sens,toolLength);
botPose=zeros(4,4,steps);
missActuation=0;
targetPoints=centerPose*makeCircle(radius);

for i=1:steps
    rHat=(targetPoints(:,i)-centerPose(:,4))/norm(targetPoints(:,i)-centerPose(:,4));
    pitch1=atan2(sqrt(1-rHat(3)^2),rHat(3));
    yaw1=atan2(rHat(2),rHat(1));
    roll=rand;
%     targetPose(:,:,i)=rotZ(yaw1)*rotY(pitch1)*rotZ(roll);
    targetPose(:,:,i)=centerPose;
    targetPose(1:3,4,i)=targetPoints(1:3,i);
    results = ikineToolPoseAna(targetPose(:,:,i),bot,sens,toolLength);
    if results==0
        results=zeros(8,6);
        missActuation=missActuation+1;
    end
    for che=1:length(results(:,1))
        goodones(che)=actuationGood(results(che,:));
        realgood=find(goodones);
    end
%     if isempty(realgood)
%         targetPose(:,:,i)=findPossibleDrillPose(bot,sens,toolLength,targetPose);
%         results = ikineToolPoseAna(targetPose(:,:,i),bot,sens,toolLength);
%         if results==0
%             results=zeros(8,6);
%             missActuation=missActuation+1;
%         end
%         for che=1:length(results(:,1))
%             goodones(che)=actuationGood(results(che,:));
%             realgood=find(goodones);
%         end
%     else
        J(i,:)=results(6,:);
%     end
end
hold on
scatter3(targetPoints(1,:),targetPoints(2,:),targetPoints(3,:))
% scatter3(toolPose(1,4),toolPose(2,4),toolPose(3,4))
hold off
diffX=max(targetPoints(1,:))-min(targetPoints(1,:))
diffY=max(targetPoints(2,:))-min(targetPoints(2,:))
diffZ=max(targetPoints(3,:))-min(targetPoints(3,:))

