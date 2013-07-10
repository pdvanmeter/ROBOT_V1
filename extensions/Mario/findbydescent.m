number=14;
lower=0;
upper=15;
movement=2;
while movement>.01
    if ((upper+lower)/2)>number
        movement=abs((upper-lower)/2);
        upper=(upper+lower)/2;
    else
        movement=abs((upper-lower)/2);
        lower=(upper+lower)/2;
    end
        
end