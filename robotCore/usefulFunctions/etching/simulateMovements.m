function simulateMovements(theBot,Js)

for i=1:length(Js)
    theBot.setJ(Js(i,:))
    i
    %     pause ()
end