dataGroup=[];
sols=[]
lines=4;
index=1;
while index*95 + lines<1901
    dataGroup(:,:,index)=realData(lines+index*95-94:index*95-lines,:);
    sols(:,:,index)=pinv([dataGroup(:,1:2,index),ones(length(dataGroup(:,:,index)),1)])*dataGroup(:,3,index);
    
    
%     scatter(1:87,dataGroup(:,1,index),'r','.')
%     hold on
%     scatter(1:87,dataGroup(:,2,index),'g','.')
%     scatter(1:87,dataGroup(:,3,index),'b','.')
%     hold off
%     pause
    index=index+1;
    
end
sols(:,:,11:12)=[];
res=[mean(sols(1,1,:)) std(sols(1,1,:));
    mean(sols(2,1,:)) std(sols(2,1,:));
    mean(sols(3,1,:)) std(sols(3,1,:));];
% scatter(1:length(sols(1,1,:)),sols(1,1,:))

edata=[];
for i=1:19
    if i==11||i==12
    else
    edata=[edata;dataGroup(:,:,i)];
    end
end
k=0;
while i<length(edata)
    if edata(i,3)>16207 || edata(i,3)<161
        edata(i,:)=[]
        k=k+1;
    else
        i=i+1;
    end
   
end
ledata=length(edata);
 scatter(1:ledata,edata(:,1),'r','.')
 hold on
 scatter(1:ledata,edata(:,2),'g','.')
 scatter(1:ledata,edata(:,3),'b','.')
 hold off
%  diff=[4.087*edata(:,1)+8*edata(:,2),edata(:,3)];
%  hold on
%  scatter(1:ledata,diff(:,1),'g','.')
%  scatter(1:ledata,diff(:,2),'b','.')
%  hold off
 parameterSet=[4,8,0];
 error=@(x)laserErrorFunction(x,edata(1:870,:));
options=optimset('MaxFunEvals',1000,'MaxIter',1000,'Algorithm',{'levenberg-marquardt',1e-12});
[result,resnorm,residual,exitflag,output,lambda,jacobian]= lsqnonlin(error,parameterSet,[ ],[ ],options);
cov=pinv(jacobian'*jacobian);
result
sols=pinv([edata(1:870,1:2) ones(870,1)])*edata(1:870,3);
y=result(1)*edata(1:870,1)+result(2)*edata(1:870,2)+result(3);
resi=edata(1:870,3)-y;

for i=0:9
scatter(1:87,y(i*87+1:(i+1)*87)+sols(3)*ones(87,1),'.','r')
hold on 
scatter(1:87,edata(i*87+1:(i+1)*87,3)+sols(3)*ones(87,1),'.','g')
scatter(1:87,sols(2)*edata(i*87+1:(i+1)*87,2),'.','b')
scatter(1:87,sols(1)*edata(i*87+1:(i+1)*87,1),'.','y')

(i+1)*87
% pause
end
hold off
for i=1:9
    scatter(1:87,resi(i*87+1:(i+1)*87,1),'.')
    hold on
end
% [p,S,mu]=polyfit(edata(:,1:2),edata(:,3),2);