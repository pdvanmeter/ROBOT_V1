function [ output_args ] = lockTargetSpotSeeker(targetX, targetY)
%Poses the spotSeeker so that the centroid of the laser dot is positioned at
%pixel (targetX, targetY)

%targetX,targetY: Where we want to position the centroid of the laser.

actuateLaser(0);
before=grabFrame();
actuateLaser(1);
after=grabFrame();
[xStart yStart]=findLaser(after,before);
eps=250;
while( (abs(xStart-targetX)>.5 || abs(yStart-targetY)>.5))
    Jacob=zeros(2);
    moveSpotSeeker('x',eps)
    after=grabFrame();
    moveSpotSeeker('x',-eps)
    [Jacobian(1,1) Jacobian(2,1)]= findLaser(after,before);
    Jacobian(1,1) = Jacobian(1,1) - xStart;
    Jacobian(2,1) = Jacobian(2,1) - yStart;
    
    moveSpotSeeker('y',eps)
    after=grabFrame();
    moveSpotSeeker('y',-eps)
    [Jacobian(1,2) Jacobian(2,2)]= findLaser(after,before);
    Jacobian(1,2) = Jacobian(1,2) - xStart;
    Jacobian(2,2) = Jacobian(2,2) - yStart;
    
    Jacobian=Jacobian/eps;
    dJ= pinv(Jacobian)*[targetX-xStart; targetY-yStart]
    moveSpotSeeker('x',round(dJ(1)));
    moveSpotSeeker('y',round(dJ(2)));
    
    actuateLaser(1);
    after=grabFrame();
    [xStart yStart]=findLaser(after,before);
end
end

