%Make sure c:\device\driver.exe is running before calling this function.

% driver.exe receives move commands through \\.\pipe\mynamedpipe

% move.exe sends a single move command as given on the command line into
% \\.\pipe\mynamedpipe.

%The new code is in C:\Users\wberry\Documents\MATLAB\helperPrograms\experiment2
for i=1:10,
     reads(i)=sens.getReading();
    moveSpotSeeker('x',-100);
        pause

   
%     pause(5)
end
i=i+1;
reads(i)=sens.getReading();
