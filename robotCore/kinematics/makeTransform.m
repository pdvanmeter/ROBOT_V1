function [ theTransform ] = makeTransform( x,y,z,yaw,pitch,roll )
 theTransform= rotZ(yaw)*rotY(pitch)*rotZ(roll);
 theTransform(1,4)=x;
 theTransform(2,4)=y;
 theTransform(3,4)=z;
end

