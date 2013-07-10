function [ distance ] = DisplacementReadingToDistance( reading )
a=3.11/1000.0;
b=42.56;
distance =  a*reading + b;
end

