function setTheTable( )
%SETTHETABLE Basic function to set up the table and spheres
%   This will be incorperated into geometricModel once it works

% Make the model
model = geometricModel();

% Add and adjust the table
table = meshModel('table.stl',makeTransform(533,-711,51,0,-pi/2,pi/2));
table_crude = table.getBoundingBox();
set(table.P,'facec',[.4,.4,.4]);

% Add and adjust the array of spheres
sO = [1092,-317.5,127,0,-pi/2,-pi/2];    % Sphere Origin
sphereGrid = [0     0   0   0   -6.5    -13     -13     -13     -13     -6.5;
              0     10  20  30  30      30      20      10      0       0;
              0.0   0.0 0.0 0.0 .005    .005    .005    .005    .005    .005
              1     1   1   1   1       1       1       1       1       1]*25.4;

for n = 1:10
    pnt = [sO(1) + sphereGrid(1,n),sO(2) + sphereGrid(2,n),sO(3) + sphereGrid(3,n),sO(4),sO(5),sO(6)];  % New Point (x,y,z,y,p,r)
    spheres(n) = meshModel('ball_with_base.stl',makeTransform(pnt(1),pnt(2),pnt(3),pnt(4),pnt(5),pnt(6)));
    spheres_crude(n) = spheres(n).getBoundingBox();
    set(spheres(n).P,'facec',[.8,.8,.8]);
end

end

