% Loop to record LDS readings

topSpot = [0   -0.2334    2.4224         0    0.8734   -0.0046];
bottomSpot = [0   -0.2334    2.4224         0    1.5070   -0.0045];
diff = abs(topSpot(5) - bottomSpot(5))/50;
robot.moveJ(topSpot);

for n = 1:50
    % Take reading
    LDSreadings(n) = readDisplacementSensor();
    
    % Move to next spot
    nextSpot = robot.whereJ() + [0,0,0,0,diff,0];
    robot.moveJ(nextSpot);
    fprintf('Finished reading %d\n',n);
end