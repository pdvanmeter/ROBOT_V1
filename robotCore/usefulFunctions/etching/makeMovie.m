function [ output_args ] = makeMovie( obj, passedModel )
%make a movie of the robot simulation
if(nargin<2)
    model = geometricModel();
end
if(nargin>1)
    model = passedModel;
end
model.setJ([-3.14/2,3.14/2,-3.14/2,0,0,0]);
J = model.J;
for i=1:10
   F(1,i) = getframe;
   newJ = [J(1),J(2)+i*3.14/200,J(3),J(4),J(5),J(6)];
   model.moveJ(J,newJ);
   J = newJ;
end

movie(gcf,F,3,1)

end

