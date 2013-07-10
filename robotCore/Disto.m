classdef Disto
    %Models the range finder.
    
    properties
        portName;
        serialPort;
    end
    
    methods
        function obj=Disto(portName)
            obj.portName=portName;
            obj.serialPort = serial(portName, 'BaudRate', 9600);
            get(obj.serialPort);
            %obj.serialPort.Terminator=13;
            fopen(obj.serialPort);
            obj.serialPort.Timeout;
        end
        
        function delete(obj)
            try
                fclose(obj.serialPort);
                delete(obj.serialPort);
            catch err
            end
        end
        
        function flushBuffer(obj)
            if(obj.serialPort.BytesAvailable >0)
                fread(obj.serialPort, obj.serialPort.BytesAvailable);
            end
        end
        
        function theDistance = getDistance(obj)
            obj.flushBuffer();
            fprintf(obj.serialPort,'g');
            theReading = fscanf(obj.serialPort,'%s')
            %Sometimes we get a question mark after asking for the reading.
            while(theReading =='?')
                fprintf(obj.serialPort,'g');
                theReading = fscanf(obj.serialPort,'%s')
            end
            % When we have a good reading, it will look like this:
            % 31..05+00000221 51....+00000000
            theDistance=str2double(theReading(8:15))*10;
            obj.flushBuffer();
        end
        
        function laserOn(obj)
            fprintf(obj.serialPort,'o');
            obj.flushBuffer();
        end
        
        function laserOff(obj)
            fprintf(obj.serialPort,'p');
            obj.flushBuffer();
        end
        
    end
end

