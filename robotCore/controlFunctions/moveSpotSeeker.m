function moveSpotSeeker(axis, Count )
%before calling move.exe, make sure that driver.exe is running.
mvcmd=horzcat('m',axis);    
    mvcmd=horzcat(mvcmd, num2str(Count));  
    system(horzcat('C:\Device\move.exe ', mvcmd)); 
    %system(horzcat('C:\Users\wberry\Documents\MATLAB\helperPrograms\SpotSeeker\WIN7_DEBUG\driver.exe '));
end

 function posSpotSeeker(axis)
    
    poss = holder('L',axis);
    poss = holder(poss);
    system(holder('C:\Device\move.exe',poss));
 end 