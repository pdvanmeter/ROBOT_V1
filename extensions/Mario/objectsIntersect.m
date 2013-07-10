function result=objectsIntersect(V1,V2)
V1 = single(reshape(V1',3,3,size(V1,1)/3));
V2 = single(reshape(V2',3,3,size(V2,1)/3));
result=0;
for i=1:size(V1,3),
    for j=1:size(V2,3),
        if(isect(V1(:,:,i), V2(:,:,j)))
            result=1;
            return;
        end
    end
end
end
