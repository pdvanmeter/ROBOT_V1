% mex 'C:\Users\wberry\Documents\MATLAB\collisionDetector\isect.c';
mex 'E:\MATLAB\plate Calibration\computerModel\isect.c'
N=5;
set1= single(2*(.5*ones(3,3,N)-rand(3,3,N)));
set2= single(2*(.5*ones(3,3,N)-rand(3,3,N)));

for i=1:N,
    for j=1:N,
        if(isect(set1(:,:,i),set2(:,:,j)))
            a=patch(set1(1,:,i), set1(2,:,i), set1(3,:,i),0);
            set(a,'FaceAlpha',.1);
            b=patch(set2(1,:,j), set2(2,:,j), set2(3,:,j),0);
            set(b,'FaceAlpha',.1);
        end
    end
end