% hold on
% scatter(1:1901,realData(:,1),'r','.')
% scatter(1:1901,realData(:,2),'g','.')
% scatter(1:1901,realData(:,3),'b','.')
% 
% hold off
hold on
%realData_1=[4*realData(:,1)+8*realData(:,2),realData(:,3)];
% scatter(1:1901,realData_1(:,1),'r','.')
% scatter(1:1901,realData_1(:,2),'g','.')
scatter(1:1901,realData(:,3),'b','.')
hold off
realData_1(880:1050,:)=[];

diff=realData_1(:,1)-realData_1(:,2);
diff=abs(diff);
mean(diff)
std(diff)
%scatter(1:length(diff),diff);