classdef displacementSensor
    %Models the displacementSensor.
    
    properties
        portName;
        serialPort;
    end
    
    methods
        function obj=displacementSensor(portName)
            system('taskkill /IM readSensor.exe')
            system('taskkill /IM startSensor.exe')
            system('C:\Device\startSensor.bat');
            pause(.5);
            system('taskkill /IM startSensor.exe')
            obj.portName=portName;
            obj.serialPort = serial(portName, 'BaudRate', 115200);
            obj.serialPort.Terminator=13;
            obj.serialPort.InputBufferSize=600;
            get(obj.serialPort);
            fopen(obj.serialPort);
        end
        
        function flushBuffer(obj)
            for i=1:1200,
                fscanf(obj.serialPort);
            end
        end
        
        function reading=getReading(obj)
            obj.flushBuffer();
            disp('bufferFlushed')
            obj.serialPort.BytesAvailable();
            numReads=100;
            readings=zeros(1,numReads);
            for i=1:numReads,
                readings(i)=str2double(fscanf(obj.serialPort));
            end
            reading=mode(readings);
        end
        
        function reading=getReadingRaw(obj)
                fscanf(obj.serialPort);
                reading=str2num(fscanf(obj.serialPort));
        end
        function reading = readConstant(obj)
           while(true)
               obj.getReadingRaw()
           end
        end
        
        function [readings] = brad(obj,counter)
           count = 100;
           obj.getReading();
           if(nargin>1)
               count = counter;
           end
           readings = double(count);
           for i=1:count
              readings(i) = obj.getReading()
           end
        end
        function delete(obj)
            fclose(obj.serialPort);
            delete(obj.serialPort);
        end
        function [reading] = read_dZ(obj, num)
            count = 50;
            moved = false;
            if(nargin>1)
               count = num; 
            end
            for i=1:count
                reading(i) = obj.getReading();
                if(moved == false)
                   moveSpotSeeker('Z', 500);
                   moved = true;
                elseif(moved == true)
                    moveSpotSeeker('Z',-500);
                    moved = false;
                end   
            
            end
        end
    end
    
end

