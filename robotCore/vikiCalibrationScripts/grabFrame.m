function [ frame] = grabFrame()
%Take a snapshot using the webcam.

impath = horzcat('C:\Device\camframe_', num2str(round(rand(1)*1000)), '.bmp')
system(horzcat('del ', impath));
system('del C:\Device\frame.bmp');
system('taskkill /IM RobotEyez.exe')
system('C:\Device\RobotEyez.exe /width 1920 /height 1080 /bmp');
system(horzcat('copy frame.bmp ', impath));
frame=imread(impath);
system(horzcat('del ', impath));
end

