J= (theRobot.where());
i=1;
oldJ=J(1:6);
while(i<=acts)
    P=dataPars(23:25)';
    if(i>acts/2)
        P=P-d*[cos(translationAngles(1))*cos(translationAngles(2)) sin(translationAngles(1))*cos(translationAngles(2)) -sin(translationAngles(2))]';
    end
    P=[P; 1];
    %     J = ikineToolPosition(P,reshape(dataPars(1:18),6,3),dataPars(19:22),0)
    
    Js = ikineToolPositionAna(P,reshape(dataPars(1:18),6,3),dataPars(19:22),0);
    for degenerate=1:2
        J=Js(degenerate,:);
        [robotCrashes laserObscured]=theModel.setJ(J);
        if (robotCrashes || laserObscured)
            break
        else
            [robotCrashes laserObscured] = theModel.moveJ(oldJ, J(1:6));
            if(robotCrashes || laserObscured)
                theModel.setJ(oldJ);
            else
                dataSet(i,:)=J(1:6);
                oldJ=J(1:6);
                disp(horzcat('Actuation ',i,' recorded'));
                i=i+1;
            end
        end
    end
end