classdef geometricModel < handle
    %     The geometricModel of the robot origionally came for the Staubli
    %     website where cad version of the robot was downloadable. The parts
    %     were then separated and stored in stl format. Other parts were hand
    %     made, like the floor and walls. It is possible to create other parts
    %     in cad programs however one must be careful about the origin of the
    %     new parts. Each part needs to have the origin of the cad model
    %     related to the origin in the numberic models. For example, if you
    %     make a tool, and export the stl file in auto cad, you will need to
    %     keep with it a transform that places the desired origin of the tool
    %     to the center of the flange.
    % This was written my William Berry and others in 2011-2012
    properties
        % Each of the following parts is a segment of the robot
        
        % Array to hold parts and bounding boxes
        componentArray = meshModel.empty(21,0);
        boundingBoxArray = meshBoundingBox.empty(21,0);
        
        % Transformation
        world2Link
        
        % The current actuation
        J
        
        % The tool position and orientation in the room coordinates (4X4)
        pose
        
        % The flange position and orientation in the room coordinatobj = geometricModel()es (4X4)
        % Perhaps this could be changed to return xyzrpy like the controller
        % does;
        poseFl
        
        % The tool parameters hard coded into the geometric model.
        toolPars
        
        % The ready position
        Home
    end
    
    methods
        % Default Constructor. Generates the model.
        function obj = geometricModel()
            
            % Generate the RX130 Robot. Components 1 - 7
            obj.componentArray(1) = meshModel('RX130B-HB_RX130B BASE HORIZONTAL CABLE OUTLET_1.stl');
            obj.boundingBoxArray(1) = obj.componentArray(1).getConformalBoundingBoxes(3);
            
            obj.componentArray(2) = meshModel('RX130B-HB_RX130B SHOULDER_2.stl');
            obj.boundingBoxArray(2) = obj.componentArray(2).getConformalBoundingBoxes(1);
            
            obj.componentArray(3) = meshModel('RX130B-HB_RX130B ARM_3.stl');
            obj.boundingBoxArray(3) = obj.componentArray(3).getConformalBoundingBoxes(1);
            
            obj.componentArray(4) = meshModel('RX130B-HB_RX130B ELBOW_4.stl');
            obj.boundingBoxArray(4) = obj.componentArray(4).getConformalBoundingBoxes(1);
            
            obj.componentArray(5) = meshModel('RX130B-HB_RX130B FOREARM_5.stl');
            obj.boundingBoxArray(5) = obj.componentArray(5).getConformalBoundingBoxes(9);
            
            obj.componentArray(6) = meshModel('RX130B-HB_RX130B WRIST_6.stl');
            obj.boundingBoxArray(6) = obj.componentArray(6).getConformalBoundingBoxes(1);
            
            obj.componentArray(7) = meshModel('RX130B-HB_RX130B TOOL FLANGE_7.stl');
            obj.boundingBoxArray(7) = obj.componentArray(7).getConformalBoundingBoxes(1);
            
            % Generate the floor and walls. Component 8
            obj.componentArray(8) = meshModel('floor.stl');
            set(obj.componentArray(8).P, 'facec', 'r');              % Set the face color (force it)
            set(obj.componentArray(8).P,'FaceAlpha',.5);
            % Surrounds area with a box. Seems to work well enough.
            obj.boundingBoxArray(8) = obj.componentArray(8).getBoundingBox();
            
            % Generate tool and pose. Component 9
            obj.J = deg2rad([0 -90 90 0 0 0]);
            obj.Home = deg2rad([0 -90 90 0 0 0]);
            [tool2World obj.world2Link] = transformRobot(modelRobot(),obj.Home);
            %[toolModel transBit_Flng transTool2Flng transBit2tool] = modelDrill();
            [toolModel transTool2Flng] = modelToolMount();
            obj.toolPars = toolModel;
            %obj.componentArray(9) = meshModel('modelDrill.stl',obj.world2Link(:,:,6)*transTool2Flng);
            obj.componentArray(9) = meshModel('tool_mount.stl',obj.world2Link(:,:,6)*transTool2Flng);
            obj.pose = transformRobot(modelRobot(), obj.J)*transformTool(obj.toolPars);
            obj.poseFl = transformRobot(modelRobot(), obj.J);
            obj.boundingBoxArray(9) = obj.componentArray(9).getConformalBoundingBoxes(6);
            set(obj.componentArray(9).P,'facec', [.4 .4 .4]);    %set the color
            set(obj.componentArray(9).P,'FaceAlpha', 1);
            
            % Generate the laser. Component 10
            obj.componentArray(10) = meshModel('laser.stl',transformTool(modelLaser)*obj.world2Link(:,:,6));
            set(obj.componentArray(10).P,'facec', 'r');
            obj.boundingBoxArray(10) = obj.componentArray(10).getConformalBoundingBoxes(1);
            
            % Generate the table and force the location. Component 11
            tableYPRstl = [0,-pi/2,pi/2];       % The orientation of the table, relative to stl file.
            [ypr tO sphereGrid sO] = modelTableAndSpheres();       % These values will be used for the spheres also
            setTable = makeTransform(0,0,0,tableYPRstl(1),tableYPRstl(2),tableYPRstl(3));
            % Additional transformation matrix to orient the stl file and
            % then correctly position the table.
            rotateTable = makeTransform(tO(1),tO(2),tO(3),ypr(1),ypr(2),ypr(3));
            setTable = rotateTable*setTable;
            obj.componentArray(11) = meshModel('table.stl',setTable);
            obj.boundingBoxArray(11) = obj.componentArray(11).getConformalBoundingBoxes(1);
            set(obj.componentArray(11).P,'facec',[.4,.4,.4]);
            
            % Generate the sphere array and force the locations. Components 12-21
            % Sphere Origin and relative placement grid.
            sphereYPRstl = [0,-pi/2,-pi/2];      % The orientation of the spheres, relative to stl file.
            sphereTransform = makeTransform(sO(1),sO(2),sO(3),ypr(1),ypr(2),ypr(3));
            pnt = sphereTransform*sphereGrid;
            % Now use the oriented grid to place and orient the spheres
            for n = 1:10
                sphereTransform = makeTransform(0,0,0,sphereYPRstl(1),sphereYPRstl(2),sphereYPRstl(3));
                setSpheres = makeTransform(pnt(1,n),pnt(2,n),pnt(3,n),ypr(1),ypr(2),ypr(3));
                sphereTransform = setSpheres*sphereTransform;
                obj.componentArray(n + 11) = meshModel('ball_with_base.stl',sphereTransform);
                obj.boundingBoxArray(n + 11) = obj.componentArray(n+11).getConformalBoundingBoxes(1);
                set(obj.componentArray(n + 11).P,'facec',[.8,.8,.8]);
            end
            
            % Set up the viewing window
            light                               % add a default light
            daspect([1 1 1])                    % Setting the aspect ratio
            view([90 30])                       % rotation around z from -y axis, rotation above xy plane
            %xlim([00,1000])                    % set viewing window
            %ylim([-400,400])
            %zlim([100,500])                    % Isometric view
            
            xlim([-1000,1500])                  % Threw these in to fix the weird view
            ylim([-1000,1500])                  % Delete in due time
            zlim([0,2500])                      % That would return to "drill view"
            
            xlabel('X'),ylabel('Y'),zlabel('Z')
        end
        
        % Checks if the laser is obscured. Currently deprecated
        function collisionMatrix = getLaserObstacles(obj)
            % This is legacy code, and has been removed for speed
            collisionMatrix = zeros(10,10);
            % TODO: write a loop to do this for vicki if needed
        end
        
        % Iteratively checks for component collisions
        function collisionMatrix = getIntersections(obj)
            % See the Index Key in getAdjacencyMatrix for index values
            adjacencyMatrix = getAdjacencyMatrix(1);
            collisionMatrix=zeros(length(adjacencyMatrix),length(adjacencyMatrix));
            
            % Using the upper triangular part of the adjacencyMatrix as a
            % guide, loop through and check for possible collisions of the
            % bounding boxes. Then, if the boxes intersect check the actual
            % vertices of the part.
            for n = 1:length(adjacencyMatrix)
                for m = n:length(adjacencyMatrix)
                    if adjacencyMatrix(n,m) == 0
                        if(obj.boundingBoxArray(n).intersects(obj.boundingBoxArray(m)))
                            % Troubleshooting
                            fprintf('Bounding box collision at (%d,%d)\n',n,m);
                            if(obj.componentArray(n).intersects(obj.componentArray(m)))
                                fprintf('Model collision at (%d,%d)\n',n,m);
                                collisionMatrix(n,m) = 1;
                            end
                        end
                    end
                end
            end
        end
        
        % Places the robot in a given configuration, startJ
        function [robotCrashes collisionMatrix laserObscured] = setJ(obj, startJ)
            % Establish sstating J's and transformation
            obj.J = startJ;
            [tool2World newWorld2Link] = transformRobot(modelRobot(),startJ);
            
            % Loop to transform robot parts
            for n = 1:6
                obj.componentArray(n+1).transform(newWorld2Link(:,:,n)/obj.world2Link(:,:,n));
                obj.boundingBoxArray(n+1).transform(newWorld2Link(:,:,n)/obj.world2Link(:,:,n));
            end
            
            % Transform tool and laser
            for n = 9:10
                obj.componentArray(n).transform(newWorld2Link(:,:,6)/obj.world2Link(:,:,6));
                obj.boundingBoxArray(n).transform(newWorld2Link(:,:,6)/obj.world2Link(:,:,6));
            end
            
            % Check for collisions
            robotCrashes = 0;
            laserObscured = 0;
            
            collisionMatrix = obj.getIntersections();
            drawnow
            
            if(find(collisionMatrix))
                robotCrashes = 1;        % Unsuppress to give result
            end
            
            % Not currently relevant. Flag is currently never set.
            if(~robotCrashes)
                if(find(obj.getLaserObstacles()))
                    laserObscured=1;
                end
            end
            
            obj.J = startJ;
            obj.pose = transformRobot(modelRobot(), obj.J)*transformTool(obj.toolPars);
            obj.poseFl = transformRobot(modelRobot(), obj.J);
        end
        
        % Updated function to animate movement
        function [robotCrashes laserObscured ] = moveJ(obj, startJ,endJ)
            robotCrashes=0;
            laserObscured=0;
            Jres = deg2rad([6.79493E-04 6.790161E-04 8.69751E-04 8.987652E-04 1.171112E-03 2.74582E-03]);
            keyframes=abs(max((endJ-startJ)./Jres))/1000
            diff = (endJ-startJ)/keyframes;
            for t=1:keyframes,
                startJ=startJ+diff;
                obj.J = startJ;
                [robotCrashes] = obj.setJ(startJ);
                if(robotCrashes)
                    break;
                end
            end
            obj.pose = transformRobot(modelRobot(), obj.J)*transformTool(obj.toolPars);
            obj.poseFl = transformRobot(modelRobot(), obj.J);
        end
    end
end
