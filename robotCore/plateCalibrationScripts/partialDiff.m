function diff=partialDiff(j)
delta=1e-9;
[randomParameters parameterSet fixedPars]=generateParameters();
robot=[parameterSet(1:14) fixedPars(5) parameterSet(15:18) fixedPars(6)];
robot=reshape(robot,[5,4]);
robot=[fixedPars(1:4); robot];
sensor=parameterSet(19:23);



diff=zeros(23,6);
for var=1:23
    d_parameterSet=parameterSet;
    d_parameterSet(var)=parameterSet(var)-delta;
    d_robot=[d_parameterSet(1:14) fixedPars(5) d_parameterSet(15:18) fixedPars(6)];
    d_robot=reshape(d_robot,[5,4]);
    d_robot=[fixedPars(1:4); d_robot];
    d_sensor=d_parameterSet(19:23);
    
    
    target=transformRobot(robot,j)*transformTool(sensor);
    d_target=transformRobot(d_robot,j)*transformTool(d_sensor);
    
    rotations=matrix2angles(target);
    d_rotations=matrix2angles(d_target);
    
    diff_r=rotations-d_rotations;
    diff_p=target(1:3,4)-d_target(1:3,4);
    diff(var,:)=[diff_p' diff_r]/delta;
end
end