function [sideMasks]=getSideMasks()
sideMasks=false(36,6);
for i=1:6
    sideMasks(i*6-5:i*6,i)=true;
end
end