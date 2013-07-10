




index=1;
posz=0;
posy=0;
%reading=theLDS.getReading;


for i=1:1
    
    for n = 1:20
        %theLDS.flushBuffer();
        theLDS.getReading();
    end
    theLDS.getReading();
    
    while (theLDS.getReading()>16370)
        
        moveSpotSeeker ('y', -50);
        posy = posy-50;
        pause(.1);
        
        for n = 1:20
            %theLDS.flushBuffer();
            theLDS.getReading();
        end
        theLDS.getReading();
        
    
    end
    pause(1);
    while(theLDS.getReading()<16370)
        pause(0.4);
        for n = 1:20
            %theLDS.flushBuffer();
            theLDS.getReading();
        end
        theLDS.getReading();
        laserReadings(index)=theLDS.getReading();
        data(index,:)= laserReadings(index);
        data(index,2)= posy;
        data(index,3)= posz;
        %pause(0.4);
        
        moveSpotSeeker('y',-50);
        posy=posy-50;
        index=index+1;
        
        for n = 1:20
            %theLDS.flushBuffer();
            theLDS.getReading();
        end
        theLDS.getReading();
        
       
    end
    if (theLDS.getReading()>16370)
        moveSpotSeeker('y',(-posy));
        pause(3);
        moveSpotSeeker('z',100);
        posz=posz+100;
        pause(1)
        posy=0;
 
    end
end

moveSpotSeeker('z',(-posz));
posz=0;
for i=1:1
    
    for n = 1:20
       %theLDS.flushBuffer();
       theLDS.getReading();
    end
    theLDS.getReading();
    
    while theLDS.getReading()>16370
        
        
        moveSpotSeeker ('y', -50);
        posy = posy-50;
        pause(.1);        
        for n = 1:20
            %theLDS.flushBuffer();
            theLDS.getReading();
        end
        theLDS.getReading();
    
    end
    pause(1);
    while(theLDS.getReading()<16370)
        pause(0.4);  
        for n = 1:20
            %theLDS.flushBuffer();
            theLDS.getReading();
        end
        theLDS.getReading();
        laserReadings(index)=theLDS.getReading();
        data(index,:)= laserReadings(index);
        data(index,2)= posy;
        data(index,3)= posz;
        
        moveSpotSeeker('y',-50);
        posy=posy-50;
        index=index+1;
        
        for n = 1:20
            %theLDS.flushBuffer();
            theLDS.getReading();
        end
        theLDS.getReading();
        %pause(0.4);
       
    end
    if (theLDS.getReading()>16370)
        moveSpotSeeker('y',(-posy));
        pause(3);
        moveSpotSeeker('z',100);
        posz=posz+100;
        pause(1)
        posy=0;
    end
end

    
    


