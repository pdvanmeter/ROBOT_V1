function dParameters=randomChangeParms(parameters,iteration)
iteration=(5*(iteration));
d_l=0.05/iteration;%lengths of robot 0.5mm
d_a=0.0002/iteration;%angles of robot ~0.1 deg
d_o=.02/iteration;%origin of the plate


numplatePoses=(length(parameters)-24)/6;
for pos=1:numplatePoses
    dParameters(25+6*pos-6:25+6*pos-4)=normrnd(parameters(25+6*pos-6:25+6*pos-4),d_o);
    dParameters(28+6*pos-6:28+6*pos-4)=normrnd(parameters(28+6*pos-6:28+6*pos-4),d_a);
end
dParameters(1:5)=normrnd(parameters(1:5),d_a);
dParameters(6:10)=normrnd(parameters(6:10),d_l);
dParameters(11:14)=normrnd(parameters(11:14),d_a);
dParameters(15)=normrnd(parameters(15),d_l);
dParameters(16)=normrnd(parameters(16),d_a);
dParameters(17:18)=normrnd(parameters(17:18),d_l);

dParameters(19:20)=normrnd(parameters(19:20),d_l);
dParameters(21:22)=normrnd(parameters(21:22),d_a);
dParameters(23:25)=normrnd(parameters(23:25),d_o);
dParameters(26:27)=normrnd(parameters(26:27),d_a);


end