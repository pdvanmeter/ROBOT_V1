function [ TTable2TlabPartial] = modelTablePartial(Parno,dpar)

TableEmre=[0,-pi/6,0,1250.7466,-318.16,250.03];

%TTable2Tlaberror=[0.0005,0.0005,0.0005,0.5,0.5,0.5];

TTable2TlabPartial=TableEmre;

for i = 30:35;
    % j is an offset for the parameter numbers
    j = 29;
    
    if i == Parno;
        %TTable2TlabPartial(i-j)=TableEmre(i-j)+TTable2Tlaberror(i-j);
        TTable2TlabPartial(i-j) = TableEmre(i-j) + dpar;
    end
   

end
