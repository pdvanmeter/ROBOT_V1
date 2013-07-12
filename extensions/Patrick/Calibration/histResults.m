% Creats an output array binArray
% Column 1 is the model pose.
% Column 2 is the number of poses which succeeded.
% Column 3 is the number of poses which failed.

% Empty bin array
binArray = zeros(8,2);
            
% Sort results into bins by pose
for n = 1:length(results)
    bin = results(n,8);
    if ~results(n,1)
        binArray(bin,1) = binArray(bin,1) + 1;   % Increment Sucess Count
    else
        binArray(bin,2) = binArray(bin,2) + 1;   % Increment Failure Count
    end
end

% Display info graphically
figure(2);
bar(binArray)
title('Comparison of Successes and Failures for Each Pose')
xlabel('Pose Number')
ylabel('Count')
colormap jet
grid on

% Create a matrix of only good actuations
i = 1;
goodJset = zeros(length(find(~failures)),9);
for n = 1:length(failures)
    if(~failures(n))
        goodJset(i,1:9) = testJset(n,1:9);
        i = i + 1;
    end
end