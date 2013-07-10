
do_fixed = 0;
if do_fixed,
    
    %First off, how consistent is the displacement reading for a fixed
    %robot/target position when the robot is kept still?
    reads0=[];
    for i=1:10,
        reads0(:,i)= readDisplacementSensor()
        pause(.4);
    end
    %This should be tiny:
    std(reads0)
    
    %How about when we wiggle the robot?
    
    %If the vibration theory is correct, then we ought to be able to bring the
    %standard deviation of the following measurement set down to the one computed
    %just above by inserting a long enough pause.
    
    %But if the cartesian bot just isn't that repeatable, then it won't help.
    %It could be that the spotSeeker is not receiving all of the pulses emitted by the control
    %program, so if the standard deviation of the following measurement set is much bigger than
    %the one computed above, straighten out the parallel cable and try again.
    reads0=[];
    for i=1:10,
        reads0(:,i)= readDisplacementSensor()
        theDistance=round((.5-rand)*300)
        moveSpotSeeker('y',theDistance);
        pause(.1);
        moveSpotSeeker('y',-theDistance);
        pause(3);
    end
    std(reads0)
end

%Now what about different positions?
reads1=[];
for i=1:10,
    reads1(:,i)= readDisplacementSensor()
    moveSpotSeeker('y',150);
    moveSpotSeeker('y',-120);
    pause(2);
end
moveSpotSeeker('y',-300);

reads2=[];
for i=1:10,
    reads2(:,i)= readDisplacementSensor()
    moveSpotSeeker('y',150);
    moveSpotSeeker('y',-120);
    pause(2);
end
moveSpotSeeker('y',-300);

plot(reads1-reads2);