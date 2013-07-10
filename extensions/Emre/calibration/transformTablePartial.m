function [ TTable2TlabPartial] = transformTablePartial(Parno)

TableEmre=[0,0,0,1250.7466,-318.16,122.03];


TTable2Tlaberror=[0.5,0.5,0.5,0.5,0.5,0.5];

TTable2TlabPartial=TableEmre;

for i=30:35;
    j=29;
    if i==Parno;
    

TTable2TlabPartial=TableEmre(i-j)+TTable2Tlaberror(i-j);
    end
   

end
