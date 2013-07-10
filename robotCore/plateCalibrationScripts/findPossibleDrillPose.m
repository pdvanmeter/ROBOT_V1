function pose=findPossibleDrillPose(bot,tool,toolLength,targetPose)
% trans=transformRobot(bot,randomActuation());
zHat=targetPose(:,3);
pitch1=atan2(sqrt(1-zHat(3)^2),zHat(3));
pitch2=atan2(-sqrt(1-zHat(3)^2),zHat(3));
yaw1=atan2(zHat(2),zHat(1));
yaw2=atan2(-zHat(2),-zHat(1));

results = ikineToolPoseAna(targetPose,bot,tool,toolLength);
if results==0
    pose=zeros(4,4);
    
    error('Point out of range');
end

for che=1:length(results(:,1))
    goodones(che)=actuationGood(results(che,:));
    realgood=find(goodones);
end
if isempty(realgood)
    tries=0;
    roll=-pi;
    while isempty(realgood) && (tries<100)
        newTargetPose=makeTransform(targetPose(1,4),targetPose(2,4),targetPose(3,4),pitch1,yaw1,roll)
        results = ikineToolPoseAna(targetPose,bot,tool,toolLength);
        for che=1:length(results(:,1))
            goodones(che)=actuationGood(results(che,:));
            realgood=find(goodones);
        end
        roll=tries*2*pi/100;
        tries=tries+1;
    end
    tries=0;
    roll=-pi;
    if isempty(realgood)
        while isempty(realgood) && (tries<100)
            
            newTargetPose=makeTransform(targetPose(1,4),targetPose(2,4),targetPose(3,4),pitch2,yaw2,roll)
            results = ikineToolPoseAna(targetPose,bot,tool,toolLength);
            for che=1:length(results(:,1))
                goodones(che)=actuationGood(results(che,:));
                realgood=find(goodones);
            end
            roll=tries*2*pi/100;
            tries=tries+1;
        end
    end
    if isempty(realgood)
        pose=eye(4,4);
        error('No possible Orientation')
    else
         pose=results(realgood(end),:);
    end
    pose=newTargetPose;
else
   pose=targetPose;

end
end