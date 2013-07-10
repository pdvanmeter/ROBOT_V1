#ifndef DISPLACEMENTSENSOR_H
#define DISPLACEMENTSENSOR_H
#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <string.h>
#include <string>
#include <fstream>
#include <math.h>
#include <arpa/inet.h>
#include <sstream>

using namespace std;

template <class T>
bool from_string(T& t, const std::string& s, std::ios_base& (*f)(std::ios_base&))
{
    std::istringstream iss(s);
    return !(iss >> f >> t).fail();
};

class DisplacementSensor
{
    struct termios tio;
    int tty_fd;
    //fd_set rdset;
    unsigned char thePacket[32];
    char serialDevice[128];

public:
    void recv()
    {
        int bytes_read=0;
        unsigned char shift_reg[4] = {0,0,0,0};
        unsigned char reading;

        bytes_read = read(tty_fd,shift_reg,4);
        for(int i=0; i<bytes_read; i++)
        {
            //printf("%X=%c\n",shift_reg[i], shift_reg[i]);
            //printf("%c",shift_reg[i]);
        }
        while(!(shift_reg[0]==0x20 && shift_reg[1]==0x20 && shift_reg[2]==0x0D && shift_reg[3]==0x0A))
        {
            shift_reg[0]=shift_reg[1];
            shift_reg[1]=shift_reg[2];
            shift_reg[2]=shift_reg[3];
            bytes_read = read(tty_fd,&shift_reg[3],1);
            //printf("%X=%c\n",shift_reg[3], shift_reg[3]);
            //printf("%c",shift_reg[3]);
        }

        //printf("Received %d\n", bytes_written);
        //printf("--------\n");
        //for(int i=0;i<bytes_read;i++)
        //	printf("%X=%c\n",reading[i], reading[i]);
        //printf("--------\n\n");

    }

    void send_raw(unsigned char * cmdString, int cmdLength)
    {
        int bytes_written=0;

        bytes_written=write(tty_fd,cmdString,cmdLength);
        tcdrain(tty_fd);

        //printf("Sent %d\n", bytes_written);
        //printf("--------\n");
        //for(int i=0;i<cmdLength;i++)
        //	printf("%X=%c\n",cmdString[i], cmdString[i]);
        //printf("--------\n\n");
    }

    void send_recv_raw(unsigned char * cmdString, int cmdLength)
    {
        send_raw(cmdString, cmdLength);
        recv();
    }

    void send_recv_cmd(unsigned char *cmdString, int cmdLength)
    {
        //We need to prepend the preamble to cmdString before blasting it to the port.
        memcpy(&thePacket[8],cmdString, cmdLength);
        send_recv_raw(thePacket, 8+cmdLength);
        memset(&thePacket[8],0, 24);
    }

    void send_cmd(unsigned char *cmdString, int cmdLength)
    {
        //We need to prepend the preamble to cmdString before blasting it to the port.
        memcpy(&thePacket[8],cmdString, cmdLength);
        send_raw(thePacket, 8+cmdLength);
        memset(&thePacket[8],0, 24);
    }

    void openSerial(const char * serialDevice,speed_t speed)
    {
        if(tty_fd>=0)
        {
            tcflush(tty_fd,TCIOFLUSH);
            close(tty_fd);
            tty_fd=-1;
        }

        memset(&tio,0,sizeof(tio));
        tio.c_iflag=0;
        tio.c_oflag=0;
        tio.c_cflag= CS8 | CREAD | CLOCAL;           // 8n1, see termios.h for more information
        tio.c_lflag=0;
        tio.c_cc[VMIN]=1;
        tio.c_cc[VTIME]=5;
        tty_fd=open(serialDevice, O_RDWR | O_NOCTTY);

        if(tty_fd <0)
        {
            throw("ERROR: Couldn't Access Serial Port");
        }

        cfsetospeed(&tio,speed);
        cfsetispeed(&tio,speed);

        tcsetattr(tty_fd,TCSANOW,&tio);
    }

    void changeSpeed(speed_t speed)
    {
        tcflush(tty_fd,TCIOFLUSH);

        cfsetospeed(&tio,speed);
        cfsetispeed(&tio,speed);

        tcsetattr(tty_fd,TCSANOW,&tio);
    }

    void GET_INFO()
    {
        unsigned char theCmd[4]= {0x20, 0x49, 0x00, 0x02};
        send_recv_cmd(theCmd,4);
    }

    void GET_SETTINGS()
    {
        unsigned char theCmd[4]= {0x20, 0x4A, 0x00, 0x02};
        send_recv_cmd(theCmd,4);
    }

    // avgType = 0 --> Moving average
    // avgType = 1 --> Median
    // avgNumber = 1 ... 128 --> Moving average, if average type = moving average
    // avgNumber = 3, 5, 7, 9 --> Median, if average type = Median
    void SET_AV(unsigned char avgType, unsigned char avgNumber)
    {
        unsigned char theCmd[12] = {0x20, 0x7F, 0x00, 0x04,
                                    0x00, 0x00, 0x00, avgType,
                                    0x00, 0x00, 0x00, avgNumber
                                   };
        send_recv_cmd(theCmd,12);
    }

    void DAT_OUT_OFF()
    {
        unsigned char theCmd[4]= {0x20, 0x76, 0x00, 0x02};
        send_recv_cmd(theCmd,4);
    }

    void DAT_OUT_ON()
    {
        unsigned char theCmd[4]= {0x20, 0x77, 0x00, 0x02};
        send_recv_cmd(theCmd,4);
    }

    //-- X = 0 --> continuously each measurement, depending on baud rate and the measuring frequency;
    //delay = (Bit quantity / Baud rate) * measuring frequency [Hz], if delay < 0, delay = delay +1)
    //delay = number of cycles with no serial output
    //-- X = 1 --> time-based, see Chap. 8.4.10.
    //-- X = 2 --> trigger controlled, see Chap. 8.4.14.
    void SET_OUTPUTMODE(unsigned char outputMode)
    {
        unsigned char theCmd[8]= {0x20, 0xF4, 0x00, 0x03,
                                  0x00, 0x00, 0x00, outputMode
                                 };
        send_recv_cmd(theCmd,8);
    }

    void SET_OUTPUTTIME_MS(unsigned short outputTime)
    {
        unsigned char * tPointer = (unsigned char *) &outputTime;
        unsigned char theCmd[8]= {0x20, 0xF5, 0x00, 0x03,
                                  0x00, 0x00, tPointer[1], tPointer[0]
                                 };
        send_recv_cmd(theCmd,8);
    }

    //-- X = 0 --> Analog output (4 ... 20 mA)
    //-- X = 1 --> Digital output (RS422)
    void SET_OUTPUT_CHANNEL(unsigned char outputChannel)
    {
        unsigned char theCmd[8]= {0x20, 0x90, 0x00, 0x03,
                                  0x00, 0x00, 0x00, outputChannel
                                 };
        send_recv_cmd(theCmd,8);
    }

    //-- X = 0 --> 115200
    //-- X = 1 --> 57600
    //-- X = 2 --> 38400
    //-- X = 3 --> 19200
    //-- X = 4 --> 9600
    void SET_BAUDRATE(unsigned char baudRate)
    {
        speed_t speed[5] = {B115200, B57600, B38400, B19200, B9600};
        if(baudRate<=4)
        {
            unsigned char theCmd[8]= {0x20, 0x80, 0x00, 0x03,
                                      0x00, 0x00, 0x00, baudRate
                                     };
            send_cmd(theCmd,8);
            //Now change the serial port to match it.
            changeSpeed(speed[baudRate]);
            recv();
        }
    }

    //-- X = 0 --> 1500 - X = 3 --> 375
    //-- X = 1 --> 1000 - X = 4 --> 50
    //-- X = 2 --> 750
    void SET_SCANRATE(unsigned char scanRate)
    {
        unsigned char theCmd[8]= {0x20, 0x85, 0x00, 0x03,
                                  0x00, 0x00, 0x00, scanRate
                                 };
        send_recv_cmd(theCmd,8);
    }

    //-- X = 0 --> hold last measurement value
    //-- X = 1 --> error value (3.75 mA)
    //-- X = 2 … 99 --> hold last measurement value for 2 … 99 images respectively cycles
    void SET_ANALOG_ERROR_HANDLER(unsigned char errorHandler)
    {
        unsigned char theCmd[8]= {0x20, 0x81, 0x00, 0x03,
                                  0x00, 0x00, 0x00, errorHandler
                                 };
        send_recv_cmd(theCmd,8);
    }

    //-- X = 0 --> external input operates as scaling input
    //-- X = 1 --> external input operates as trigger controlled input for the data output
    void SET_EXT_INPUT_MODE(unsigned char inputMode)
    {
        unsigned char theCmd[8]= {0x20, 0xF8, 0x00, 0x03,
                                  0x00, 0x00, 0x00, inputMode
                                 };
        send_recv_cmd(theCmd,8);
    }

    void LASER_ON()
    {
        unsigned char theCmd[4]= {0x20, 0x87, 0x00, 0x02};
        send_recv_cmd(theCmd,4);
    }

    void LASER_OFF()
    {
        unsigned char theCmd[4]= {0x20, 0x86, 0x00, 0x02};
        send_recv_cmd(theCmd,4);
    }

    //-- X = 0 --> Binary output (2 Byte)
    //-- X = 1 --> ASCII output (6 Byte)
    void ASCII_OUTPUT(unsigned char outputFormat)
    {
        unsigned char theCmd[8]= {0x20, 0x88, 0x00, 0x03,
                                  0x00, 0x00, 0x00, outputFormat
                                 };
        send_recv_cmd(theCmd,8);
    }

    //-- X = 0 --> enable key
    //-- X = 1 --> lock key
    //-- X = 2 --> key locked automatically after 5 min power on
    void SET_KEYLOCK(unsigned char lockMode)
    {
        unsigned char theCmd[8]= {0x20, 0x60, 0x00, 0x03,
                                  0x00, 0x00, 0x00, lockMode
                                 };
        send_recv_cmd(theCmd,8);
    }

    void SET_DEFAULT()
    {
        unsigned char theCmd[4]= {0x20, 0xF1, 0x00, 0x02};
        send_cmd(theCmd,4);
        openSerial(serialDevice,B115200);
        recv();
    }

    void RESET_BOOT()
    {
        unsigned char theCmd[4]= {0x20, 0xF0, 0x00, 0x02};
        send_recv_cmd(theCmd,4);
    }

    //-- X = 0 --> transmitted new settings are stored in the RAM and valid until power off.
    //-- X = 1 --> transmitted new settings are stored in the FLASH and are thus are generally valid.
    void SET_SAVE_SETTINGS_MODE(unsigned char saveMode)
    {
        unsigned char theCmd[8]= {0x20, 0xF7, 0x00, 0x03,
                                  0x00, 0x00, 0x00, saveMode
                                 };
        send_recv_cmd(theCmd,8);
    }

    void SET_TEACH_VALUE( float tVal1, float tVal2)
    {
        unsigned char * t1 = (unsigned char *) &tVal1;
        unsigned char * t2 = (unsigned char *) &tVal2;

        unsigned char theCmd[12]= {0x20, 0xF9, 0x00, 0x04,
                                   t1[3], t1[2], t1[1], t1[0],
                                   t2[3], t2[2], t2[1], t2[0]
                                  };
        send_recv_cmd(theCmd,12);
    }

    void RESET_TEACH_VALUE()
    {
        unsigned char theCmd[4]= {0x20, 0xFA, 0x00, 0x02};
        send_recv_cmd(theCmd,4);
    }

    //-- X = 0 --> peak with global maximum
    //-- X = 1 --> first peak, direction pixel 0 up to pixel 127, left to right
    //-- X = 2 --> last peak, direction pixel 0 up to pixel 127, left to right
    void SET_PEAKSEARCHING(unsigned char X)
    {
        unsigned char theCmd[8]= {0x20, 0xFB, 0x00, 0x03,
                                  0x00, 0x00, 0x00, X
                                 };
        send_recv_cmd(theCmd,8);
    }

    //-- X = 0 --> lower than standard
    //-- X = 1 --> Standard
    //-- X = 2 --> higher than standard
    //-- X = 3 --> highest
    void SET_THRESHOLD(unsigned char X)
    {
        unsigned char theCmd[8]= {0x20, 0xFC, 0x00, 0x03,
                                  0x00, 0x00, 0x00, X
                                 };
        send_recv_cmd(theCmd,8);
    }

    //This one breaks the pattern (every other response ends with 0x20200D0A) and we don't really need it
    /*
     * void GET_CI_MODE()
     * {
     * unsigned char theCmd[4]={'-','-','-','R'};
     * sendRaw(theCmd,4);
     * }
     */

    DisplacementSensor(const char * theDevice, speed_t speed)
    {
        unsigned char somePacket[32]=  { 0x2B, 0x2B, 0x2B, 0x0D,
                                         0x49, 0x4C, 0x44, 0x31,
                                         0x00, 0x00, 0x00, 0x00,
                                         0x00, 0x00, 0x00, 0x00,
                                         0x00, 0x00, 0x00, 0x00,
                                         0x00, 0x00, 0x00, 0x00,
                                         0x00, 0x00, 0x00, 0x00,
                                         0x00, 0x00, 0x00, 0x00
                                       };

        memcpy(thePacket, somePacket, 32);
        tty_fd=-1;
        strcpy(serialDevice, theDevice);
        openSerial(serialDevice,speed);
    }

    ~DisplacementSensor()
    {
        close(tty_fd);
    }

    //This one's solid, brah!
    int getReadingASCII()
    {
        tcflush(tty_fd,TCIFLUSH);
        unsigned char theReading[7];

        theReading[6]=0;

        for(int i=0; i<6; i++)
            theReading[i]=' ';

        while(theReading[5] != 0x0D || (theReading[0]==0x0D || theReading[1]==0x0D || theReading[2]==0x0D || theReading[3]==0x0D || theReading[4]==0x0D) )
        {
            for(int i=0; i<5; i++)
                theReading[i] = theReading[i+1];
            read(tty_fd,&(theReading[5]),1);
        }

        for(int i=0; i<6; i++)
            theReading[i]=' ';

        while(theReading[5] != 0x0D || (theReading[0]==0x0D || theReading[1]==0x0D || theReading[2]==0x0D || theReading[3]==0x0D || theReading[4]==0x0D) )
        {
            for(int i=0; i<5; i++)
                theReading[i] = theReading[i+1];
            read(tty_fd,&(theReading[5]),1);
        }

        int returnValue=0;
        from_string<int>(returnValue, (const char *)theReading, std::dec);
        return returnValue;
    }

    //Do not use this function until I have a chance to fix it.
    // WB 8/9/2012
    void getReadings(int readingsCount, double readingValues[])
    {
        for(int i=0; i<readingsCount; i++)
        {
            tcflush(tty_fd,TCIFLUSH);
            unsigned char theReading[2]= {0,0};
            int errorCode = read(tty_fd,theReading,2);
            if(errorCode<0)
                throw("ERROR: Timeout");
            if(theReading[0] & 0x80)
                readingValues[i] = ((theReading[0] & 0x7F)<<7) | theReading[1];
            else
                readingValues[i] = ((theReading[1] & 0x7F)<<7) | theReading[0];
        }
    }

    //Do not use this function until I have a chance to fix it.
    // WB 8/9/2012
    double getReading()
    {
        unsigned char theReading[2]= {0,0};
        tcflush(tty_fd,TCIFLUSH);
        int errorCode = read(tty_fd,theReading,2);
        if(errorCode<0)
            throw("ERROR: Timeout");
        unsigned short returnValue=0;
        if(theReading[0] & 0x80)
            returnValue = ((theReading[0] & 0x7F)<<7) | theReading[1];
        else
            returnValue = ((theReading[1] & 0x7F)<<7) | theReading[0];

        return returnValue;
    }

};

#endif
