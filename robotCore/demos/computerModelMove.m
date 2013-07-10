% this initializes a computer model of the robot (mod) and moves it in a sequence
% of random motions
clear;clf;
mod=geometricModel();
for i=1:4
    mod.moveJ(mod.J,randomActuation);
    'press any key to continue'
    pause
    
end
mod.moveJ(mod.J,mod.Home);
mod.setJ(mod.Home);