function [ laserTrans ] = transformTool( tool )
laserTrans= rotX(tool(1)) * rotY(tool(2)) * transXYZ(tool(3),tool(4),tool(5));
end

