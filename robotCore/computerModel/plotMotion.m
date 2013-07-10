r=RX130('COM6')
r.moveJAsync(rad2deg(actuationRandom()));
go=1;
i=1;
J=r.where();
while(go)
    i=i+1
    J=[J;r.where()]
    go=  (sum(J(i,:)==J(i-1,:)))~=6
end
delete(r);