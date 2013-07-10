bot=modelRobot;
tool=modelDisto;
transform=whereTool(mover,bot,tool,642.587+550);
transform(1:3,1:3)=eye(3,3);
theta=0;
num=4;
for i=1:num
    for m=0:1
        for n=0:1
            rotXYZ=rotX(m*pi()/(4))*rotY(n*pi/(4));
            targetRot=transform*rotY(pi)*rotZ(theta)*rotXYZ;
            target=transform;
            target(1:3,1:3)=targetRot(1:3,1:3)
            results = ikineToolPoseAna(target,bot,tool,d);
            for che=1:length(results(:,1))
                goodones(che)=actuationGood(results(che,:));
                realgood=find(goodones);
            end
            J=results(realgood(1),:);
            mover.moveJ(J);
            pause
%             theta=theta+2*pi/num;
        end
    end
end