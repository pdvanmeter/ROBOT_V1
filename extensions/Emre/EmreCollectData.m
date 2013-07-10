keepGoing=1
i=1;
J=theRobot.where();
RawReading=readDisplacementSensor();
DistanceReading=DisplacementReadingToDistance(RawReading);
Measurements=[J,DistanceReading];

keepGoing = input('Colllect Another Data Point(0=No, 1=Yes)? ');

while(keepGoing)
    J= [J;theRobot.where()]
    RawReading=[RawReading;readDisplacementSensor()];
    DistanceReading=DisplacementReadingToDistance(RawReading);
    Measurements=[J,DistanceReading];
    i=i+1;
    keepGoing = input('Colllect Another Data Point(0=No, 1=Yes)? ');
end
save('EmreData.mat','J','RawReading','DistanceReading','Measurements');