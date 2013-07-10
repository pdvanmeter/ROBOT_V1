classdef meshModel
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fileName
        F
        V
        C
        P
    end
    
    methods
        function obj=meshModel(fileNameORverts,tform)
            if(ischar(fileNameORverts))
                [obj.F obj.V obj.C]= rndread(fileNameORverts);
            else
                obj.V = fileNameORverts;
                obj.F = 1:length(fileNameORverts);
                obj.F = reshape(obj.F,3,[])';
            end
            
            if nargin >=2
                obj.V=obj.transform(tform);
            end
            obj.P = patch('faces', obj.F, 'vertices' ,obj.V);
            set(obj.P, 'facec', 'y');              % Set the face color (force it)
            %set(obj.P, 'facec', 'flat');            % Set the face color flat
            %set(obj.P, 'FaceVertexCData', obj.C);       % Set the color (from file)
            set(obj.P, 'facealpha',1)             % Use for transparency
            set(obj.P, 'EdgeColor','none');         % Set the edge color
        end
        
        function [NV]=transform(obj,trans)
            V2 = obj.V';
            V2 = [V2(1,:); V2(2,:); V2(3,:); ones(1,length(V2))];
            NV = trans*V2;
            set(obj.P,'Vertices',NV(1:3,:)');
            NV=NV(1:3,:)';
        end
        
        %Given 4 points (packed into the 4x3 pts matrix) representing the
        %corners of a quad, produce the 6 vertex points of its triangle
        %mesh.
        function [verts nml] = quad2Triangles(obj, pts)
            nml=zeros(1,3);
            nml = cross(pts(1,:)-pts(3,:), pts(2,:)-pts(3,:));
            verts=zeros(6,3);
            verts(1:3,:) = pts(1:3,:);
            %The fourth point from the quad:
            pts(4,3);
            biggest=0;
            biggest_ind=1;
            for i=1:3,
                current=norm(pts(i,:)-pts(4,:));
                if current>biggest
                    biggest=current;
                    biggest_ind=i;
                end
            end
            %Exclude the point at biggest_ind.
            verts(4,:)=pts(4,:);
            %Of 1,2,3, which is not biggest_ind?
            pts(biggest_ind,:)=[];
            verts(5,:)=pts(1, :);
            verts(6,:)=pts(2, :);
        end
        
        function result=objectsIntersect(obj,V1,V2)
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
        
        function result = intersects(obj, obj2)
            result = obj.objectsIntersect(get(obj.P,'Vertices'), get(obj2.P,'Vertices'));
        end
        
        function verts = getBoundingBoxVertices(obj)
            %All of the vertices are in V.
            %Return the bounding box which encloses them.
            K=sort(obj.V);
            %Min
            low=K(1,:);
            high=K(size(K,1),:);
            
            X=[low(1) high(1)];
            Y=[low(2) high(2)];
            Z=[low(3) high(3)];
            
            %From the extents along each axis, determine the vertices of
            %the face triangles.
            %We have the 8 corner points of the box.
            %From this set of 8 points, choose a group of 4 such that each
            %member of the group has the same X- Y- or Z- coordinate.
            
            %Top and the bottom:
            bot=zeros(4,3);
            bot(1,:) = [X(1) Y(1) Z(1)];
            bot(2,:) = [X(1) Y(2) Z(1)];
            bot(3,:) = [X(2) Y(1) Z(1)];
            bot(4,:) = [X(2) Y(2) Z(1)];
            
            [v_bot n_bot] = obj.quad2Triangles(bot)
            
            top=zeros(4,3);
            top(1,:) = [X(1) Y(1) Z(2)];
            top(2,:) = [X(1) Y(2) Z(2)];
            top(3,:) = [X(2) Y(1) Z(2)];
            top(4,:) = [X(2) Y(2) Z(2)];
            
            [v_top n_top] = obj.quad2Triangles(top)
            
            right=zeros(4,3);
            right(1,:) = [X(1) Y(1) Z(1)];
            right(2,:) = [X(1) Y(1) Z(2)];
            right(3,:) = [X(2) Y(1) Z(1)];
            right(4,:) = [X(2) Y(1) Z(2)];
            
            [v_right n_right] = obj.quad2Triangles(right)
            
            left=zeros(4,3);
            left(1,:) = [X(1) Y(2) Z(1)];
            left(2,:) = [X(1) Y(2) Z(2)];
            left(3,:) = [X(2) Y(2) Z(1)];
            left(4,:) = [X(2) Y(2) Z(2)];
            
            [v_left n_left] = obj.quad2Triangles(left)
            
            front=zeros(4,3);
            front(1,:) = [X(2) Y(1) Z(1)];
            front(2,:) = [X(2) Y(1) Z(2)];
            front(3,:) = [X(2) Y(2) Z(1)];
            front(4,:) = [X(2) Y(2) Z(2)];
            
            [v_front n_front] = obj.quad2Triangles(front)
            
            back=zeros(4,3);
            back(1,:) = [X(1) Y(1) Z(1)];
            back(2,:) = [X(1) Y(1) Z(2)];
            back(3,:) = [X(1) Y(2) Z(1)];
            back(4,:) = [X(1) Y(2) Z(2)];
            
            [v_back n_back] = obj.quad2Triangles(back)
            
            verts = [v_top; v_bot; v_right; v_left; v_back; v_front];
        end
        
        %Return the vertices of the triangles that make up a bounding box
        %for this part.
        function crudeModel =getBoundingBox(obj)
            %norms = [n_top; n_top; n_bot; n_bot; n_right; n_right; n_left; n_left; n_back; n_back; n_front; n_front];
            %verts = obj.getBoundingBoxVertices();
            verts = obj.getBoundingBoxVertices();
            crudeModel = meshBoundingBox(verts);
            %             set(crudeModel.P,'facec','b');
            %             set(crudeModel.P, 'facealpha',.4);
            %             set(crudeModel.P, 'EdgeColor','black');         % Set the edge color
            set(crudeModel.P, 'facealpha',.0);
            set(crudeModel.P, 'EdgeColor','none');         % Set the edge color
        end
        function [fitPointA, fitPointB]=findIntersection(obj,segPointA,segPointB,dimentionMask)
            %             Accepts a box defined by two points, an object and a dimention to move the
            %             two sides of the box to find a point of intersection.
            %             Returns the box that intersects.
            [sideMasks]=getSideMasks();
            stepSize=0.5;
            triOfInterest=sideMasks(:,2*find(dimentionMask)-1);
            while segPointA(dimentionMask)<segPointB(dimentionMask)
                tri=twoPoints2box(segPointA, segPointB);
                if obj.objectsIntersect(tri(triOfInterest,:),obj.V)
                    segPointA(dimentionMask)=segPointA(dimentionMask)-stepSize;
                    fitPointA=segPointA;
                    break
                else
                    segPointA(dimentionMask)=segPointA(dimentionMask)+stepSize;
                    fitPointA=segPointA;
                end
            end
            triOfInterest=sideMasks(:,2*find(dimentionMask));
            while segPointA(dimentionMask)<segPointB(dimentionMask)
                tri=twoPoints2box(segPointA, segPointB);
                if obj.objectsIntersect(tri(triOfInterest,:),obj.V)
                    segPointB(dimentionMask)=segPointB(dimentionMask)+stepSize;
                    fitPointB=segPointB;
                    return
                else
                    segPointB(dimentionMask)=segPointB(dimentionMask)-stepSize;
                    fitPointB=segPointB;
                end
            end
        end
        
         
        function crudeModel=getConformalBoundingBoxes(obj,numBoxes)
            k=sort(obj.V);
            minXYZ=k(1,:);
            maxXYZ=k(end,:);
            extent=maxXYZ-minXYZ;
            longDimMask=max(extent)==extent;
            segmentLength=extent(longDimMask);
%             numBoxes=9;
            pointA=minXYZ;
            pointB=maxXYZ;
            %     There are 8 unique verticies per box. Starting from the lowest XYZ.
            Vertices=zeros(8,3,numBoxes);
            segPointA=pointA;
            segPointB=pointB;
            for i=1:numBoxes
                segPointA(longDimMask)=minXYZ(longDimMask)+(i-1)*segmentLength/numBoxes;
                segPointB(longDimMask)=minXYZ(longDimMask)+i*segmentLength/numBoxes;
                
                dimentionMask=~longDimMask;
                dimentionMask(find(dimentionMask,true,'last'))=false;
                [fitPointA, fitPointB]=findIntersection(obj,segPointA,segPointB,dimentionMask);
                
                
                
                dimentionMask=~longDimMask;
                dimentionMask(find(dimentionMask,true,'first'))=false;
                [fitPointA, fitPointB]=findIntersection(obj,fitPointA,fitPointB,dimentionMask);
                
                [tri(i*36-35:i*36,:) Vertices(:,:,i) Faces ]=twoPoints2box(fitPointA, fitPointB);
                
            end
            
            %Set EdgeColor to 'b' and/or facealpha >0 (0.2 is good) to see boxes.
            crudeModel = meshBoundingBox(tri);
            set(crudeModel.P, 'facealpha',0);
            set(crudeModel.P, 'EdgeColor','none');
            set(crudeModel.P, 'facec',[.2 .2 .2]);
            
        end
    
    end
    
end

