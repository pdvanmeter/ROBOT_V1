function etchPicture(picture)
%ETCHPICTURE Function to model the etching of a given picture.
%   Combines the necessary functions to generate points and actuations.
%   This is a prototype and simulation for etching with the real robot.

% Generate, order, scale, and locate points for the ectching path
points = pic2points(picture);
orderedPoints = orderPoints(points);
scaledPoints = scalePoints(orderedPoints,2,2);
placedPoints = placePoints(scaledPoints);

% Find the set and lift points
[setMask liftMask] = findSetLiftPoints(orderedPoints, 7);
[actuations etchingMask] = getSetOfActuations(modelRobot,modelDrill,placedPoints, [0,pi,0], setMask, liftMask);

% Create a model and visualize the path
theBot= geometricModel();
hold on
scatter3(placedPoints(1,:),placedPoints(2,:),placedPoints(3,:),'.','black');
hold off

display('Press key to start simulation')
pause;

% Basic demonstration
for i=1:length(actuations)    
    %theBot.moveJ(theBot.J,actuations(i,:));            % Too slow
    theBot.setJ(actuations(i,:));
end

% Switch the following block with the above loop to make a movie. Windows only.

%writerObj = VideoWriter('cutMicky.avi');
%open(writerObj);
%for i=1:length(actuations)
%    if ~etchingMask(i)
%        %         display('Press key to contiue simulation')
%        %         pause
%        theBot.setJ(actuations(i,:))
%
%        i
%        frame = getframe;
%    else
%        theBot.setJ(actuations(i,:))
%        F=getframe
%        i
%        frame = getframe;
%    end
%    writeVideo(writerObj,frame);
%    %     pause ()
%end

end

