classdef RX130
   %    This initializes the phisical connection with the robot via the serial port
% Once the connection is established the functions below interface with the
% commands that are required in the "shell" of the robot command prompt.
% (With the exception of loadJs and readJoints which interface in the
% command prompts but initialize programs saved on the control box.) The
% best way to see what is actually going on is the enter the strings into
% the terminal by hand to see what they put out. If there is no responce
% when using this object, abort the command and open a putty terminal and
% see what were the latest commands and see what the error messages say.
% TODO display error messages or save them in a file in MATLAB
% Created by William Berry and Mario Fugal 2011-2012
    
    properties
        portName;
        serialPort;
    end
    
    methods
        
        function obj=RX130(portName)
            obj.portName=portName;
            obj.serialPort = serial(portName, 'BaudRate', 9600);
            get(obj.serialPort);
            obj.serialPort.Terminator=13;
            obj.serialPort.InputBufferSize=1e6;
            fopen(obj.serialPort);
            obj.serialPort.Timeout
            obj.runCmd('');
            obj.runCmd('load movej.pg');
            obj.runCmd('load wherej.pg');
            obj.runCmd('');
        end
        
        function delete(obj)
            fclose(obj.serialPort);
            delete(obj.serialPort);
        end
        
        function flushBuffer(obj)
            if(obj.serialPort.BytesAvailable >0)
                fread(obj.serialPort, obj.serialPort.BytesAvailable);
            end
        end
        
        function waitReady(obj)
            obj.serialPort.Timeout=10000;
            buf=zeros(1,3);
            %We know the controller is ready for new input when we see
            %either
            %.
            %or
            %Change?
            %on a single line in the output.
            %Todo: Check this assumption against the manual.
            %While we don't see either, keep reading and waiting.
            while(~((buf(1)==13 && buf(2)==10 && buf(3)==46)) && ~((buf(1)==103 && buf(2)==101 && buf(3)==63)))
                r_buf= fread(obj.serialPort,1);
                buf(1)=buf(2);
                buf(2)=buf(3);
                buf(3)=r_buf(1);
            end
        end
        
        function runCmd(obj,cmdString)
            obj.flushBuffer();
            fprintf(obj.serialPort,cmdString);
            obj.waitReady();
        end
        
        function runCmdAsync(obj,cmdString)
            obj.flushBuffer();
            fprintf(obj.serialPort,cmdString);
            pause(.1);
        end
        
        function drive(obj,Joint, Amount)
            Amount=rad2deg(Amount);
            driveCmd = horzcat('do drive ', num2str(Joint),', ',num2str(Amount,'%f'),', 100');
            obj.flushBuffer();
            fprintf(obj.serialPort,driveCmd);
            obj.waitReady();
        end
        
        function newPosition=moveJ(obj,J)
            obj.runCmd('ex movej');
            J=rad2deg(J);
            str=num2str(J,'%20.10G \t');
            fprintf(obj.serialPort,str);
            out=obj.serialPort.fscanf();
            out=obj.serialPort.fscanf();
            newPositionStr=obj.serialPort.fscanf();
            newPosition=str2num(newPositionStr);
            newPosition=deg2rad(newPosition);

        end
        function J=whereJ(obj)
            
            obj.runCmd('ex wherej');
            out=fscanf(obj.serialPort);
            position=fscanf(obj.serialPort);
            J=str2num(strtrim(position));
            J=deg2rad(J);
            
            %             J=deg2rad(J);
            % J=0
        end
        
        function movesJ(obj,J)
            J=rad2deg(J);
            obj.runCmd('point #p');
            str=num2str(J(1),'%f');
            for(i=2:6)
                str=horzcat(str,',',num2str(J(i),'%f'));
            end
            str
            obj.runCmd(str);
            obj.runCmd('');
            obj.runCmd('do moves #p');
        end
        
        function moveJAsync(obj,J)
            J=rad2deg(J);
            obj.runCmd('point #p');
            str=num2str(J(1),'%f');
            for(i=2:6)
                str=horzcat(str,',',num2str(J(i),'%f'));
            end
            str
            obj.runCmd(str);
            obj.runCmd('');
            obj.runCmdAsync('do move #p');
        end
        
        function panic(obj)
            fprintf(obj.serialPort,'panic');
            obj.waitReady();
        end
        
        function [J, R] = where(obj)
            whereCmd='where';
            obj.flushBuffer();
            
            fprintf(obj.serialPort,whereCmd);
            
            %Junk
            out=fscanf(obj.serialPort);
            
            %Cartesian Labels
            out=fscanf(obj.serialPort);
            %Cartesian Coordinates
            out=fscanf(obj.serialPort);
            
            R=str2num(strtrim(out));
            R(4:6)=deg2rad(R(4:6));
            
            %Joint Labels
            out=fscanf(obj.serialPort);
            %Joint Coordinates
            out=fscanf(obj.serialPort);
            J=str2num(strtrim(out));
            J=deg2rad(J);
        end
        
        function [T] = whereT(obj)
            [J R]=obj.where();
            T=transformRobot(modelRobot,J);
            %T=makeTransform(R(1),R(2), R(3),(R(4)), (R(5)), (R(6)));
        end
        
               
        function loadJs(obj,js)
            obj.runCmd('load cutting');
            obj.runCmd('ex loadppoints');
            num_actuations=length(js(:,1));
            obj.runCmd(num2str(num_actuations));
            js=rad2deg(js);
            for i=1:num_actuations
                obj.runCmd(num2str(js(i,:)))
                i
            end
        end
        
        function all=readJoints(obj)
            fprintf(obj.serialPort,'ex res3');
            i=1;
            pause (1)
            if obj.serialPort.BytesAvailable>2
                out=fscanf(obj.serialPort)
                str2num(strtrim(out))
                pause(.1)
                while obj.serialPort.BytesAvailable>2
                    i=i+1;
                    out=fscanf(obj.serialPort)
                    pause(.1)
%                     all(i,:)=str2num(strtrim(out))
                    %             ;i=i+1;
                end
            end
            all='done'
        end
    end
end

