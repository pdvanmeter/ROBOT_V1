% This is a script to manually set the "safe positions" for the calibration
% procedure, organized by pose and sphere number. Start the script, then
% position the robot into the correct spot and enter the coordinates in the
% form of (pose,sphere). Enter (0,0) to stop.
% When you are done, save the safeMatrix in ~/calibrationData

% Rquired objects in memory:
% robot = RX130('COM6');
% model = geometricModel();
% load('C:\Users\wberry\Documents\MATLAB\ROBOT_V1\calibrationData\PJs.mat')

userInput = [1,1];
index = 1;
safeMatrix = zeros(8,10,6);
fprintf('Enter the pose and sphere number. Enter [0,0] to stop.\n');

while userInput(1) ~= 0 && userInput(2) ~= 0
    % Check anything in the model?
    in = input('Check anything in the model? Enter index or 0 for no: ');
    if in ~= 0
        model.setJ(PJs(in,1:6));
    end
    
    % Set the coordinates
    fprintf('Please move robot and enter safe position number %d\n', index);
    fprintf('MAKE SURE YOU ARE NOT ON MANUAL CONTROL MODE!\n');
    in = input('Pose number: ');
    userInput(1) = in;
    in = input('Sphere number: ');
    userInput(2) = in;
    
    % Record the position
    safeMatrix(userInput(1),userInput(2),1:6) = robot.whereJ();
    
    % Increment the index
    index = index + 1;
end