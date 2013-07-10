function errorVector=errorFunction(parameter,data)
    scaleZ=parameter(1);
    scaleY=parameter(2);
    constant=parameter(3);
%     scaleSens=parameter(4);
    for i=1:length(data)
        errorVector(i)=(scaleZ*data(i,1)+scaleY*data(i,2)+constant)-data(i,3);
    end
    
end