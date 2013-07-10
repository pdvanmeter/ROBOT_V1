function [ x y ] = impactPoint(J)
 planeNormal = [-0.989809626708325;-0.116997535070762;-0.0811694503054675;];
 planePoint = [5778.85675253783;664.783013322885;506.880747084921;];
     
    camera2world =[
        5.26804837255229,15.1297887577750;
        0.752345882704299,1.61571794065474;
        0.497565188850204,1.23716664247360;];
    
    laserPoint1 = transformRobot(modelRobot(),(J))*transformLaser(modelLaser())*[0;0;25;1];
    laserPoint2 = transformRobot(modelRobot(),(J))*transformLaser(modelLaser())*[0;0;100000;1];
    I = plane_line_intersect(planeNormal(1:3),planePoint(1:3),laserPoint1(1:3),laserPoint2(1:3))
    cam =   pinv(camera2world)*[I];
    x= cam(1);
    y=cam(2);
end

