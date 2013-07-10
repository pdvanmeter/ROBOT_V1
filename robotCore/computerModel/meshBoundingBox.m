classdef meshBoundingBox < meshModel
    %This will create a rectangular prism that will be used for the crude
    %collision detection
    
    properties
        isBoundingBox = true;
    end
    
    methods
        function [drawnPatch]=meshBoundingBox(verts)
           drawnPatch@meshModel(verts);
        end
        
        function result=objectsIntersect(obj,V1,V2)
%              V1 = obj.findRectVerts(V1);
%              V2 = obj.findRectVerts(V2);
%              result = obj.rectInRect(V1,V2);
            
             %Replaced due to failure of paralelepipid method
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
        
        function result=findRectVerts(obj,verts)
            K=sort(verts);
            %Min
            low=K(1,:);
            high=K(size(K,1),:);
            
            X=[low(1) high(1)];
            Y=[low(2) high(2)];
            Z=[low(3) high(3)];
            result = [X(1) Y(1) Z(1);X(2) Y(1) Z(1);X(1) Y(1) Z(2);X(1) Y(2) Z(1)];
        end
        function [ out ] = pointInRect( obj,verts,point )
        %Tests if a point is in a parallelepipet
        %   Preconditions: verts is a 4x3 matrix consisting of 4 points in a counterclockwise order that make
        %   up a parallelepipet. 
        %   Point is a 3-dimensional coordinate
        %   Postconditions: will return true if the point is contained by the
        %   parallelepipet, false if the point isn't.
            out=true;
            norm1 = cross((verts(2,:) - verts(1,:)),(verts(3,:) - verts(1,:)));
            if(dot(norm1,verts(1,:))>dot(norm1,point))
                out = false;
            end
            if(out==true)
                if(dot(norm1,verts(4,:))<dot(norm1,point))
                  out = false;
                end
            end
            if(out==true)
                norm2 = cross((verts(2,:) - verts(1,:)),(verts(4,:) - verts(1,:)));
                if(dot(norm2,verts(1,:))<dot(norm2,point))
                 out = false;
                end
            end
            if(out==true)
                if(dot(norm2,verts(3,:))>dot(norm2,point))
                 out = false;
                end
            end
            if(out==true)
                norm3 = cross((verts(3,:) - verts(1,:)),(verts(4,:) - verts(1,:)));
                if(dot(norm3,verts(1,:))>dot(norm3,point))
                  out = false;
                end
            end
            if(out==true)
                if(dot(norm3,verts(2,:))<dot(norm3,point))
                  out = false;
                end
            end
        end
        function [ out ] = rectInRect( obj,verts1,verts2)
        %Checks for a collision between two parallelepipets
        %   Preconditions: verts1 and verts2 are 4x3 matrices consisting of 4 points in a counterclockwise order that make
        %   up a parallelepipet.
        %   Postconditions: Will return true if rectangles collide; false if not.
        out = false;
        if(obj.pointInRect(verts1,verts2(1,:)))
            out = true;
        end
        if(out==false&&obj.pointInRect(verts1,verts2(2,:)))
            out = true;
        end
        if(out==false&&obj.pointInRect(verts1,verts2(3,:)))
            out = true;
        end
        if(out==false&&obj.pointInRect(verts1,verts2(4,:)))
            out = true;
        end
        if(out==false&&obj.pointInRect(verts1,verts2(4,:)-verts2(1,:)+verts2(2,:)))
            out = true;
        end
        if(out==false&&obj.pointInRect(verts1,verts2(4,:)-verts2(1,:)+verts2(3,:)))
            out = true;
        end
        if(out==false&&obj.pointInRect(verts1,verts2(3,:)+verts2(4,:)-2*verts2(1,:)+verts2(2,:)))
            out = true;
        end
        if(out==false&&obj.pointInRect(verts1,verts2(3,:)-verts2(1,:)+verts2(2,:)))
            out = true;
        end

        end        
    end
    
end

