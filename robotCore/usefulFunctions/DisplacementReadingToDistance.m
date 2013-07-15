function [ distance ] = DisplacementReadingToDistance( reading )
a=3.1/1000.0;
b=45.055;
distance =  a*reading + b;
end

%y=0.00031*x+0.0055+4.5 (cm)