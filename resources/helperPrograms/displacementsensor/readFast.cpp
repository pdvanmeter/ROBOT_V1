#include <windows.h>
#include <string>
#include <iostream>
#include <sstream>
using namespace std;

void takeReading(HANDLE hSerial)
{
    DWORD dwBytesRead = 0;
    unsigned char theReading[7];
    theReading[6]=0;

    for(int i=0; i<6; i++)
        theReading[i]=' ';

    while(theReading[5] != 0x0D || (theReading[0]==0x0D || theReading[1]==0x0D || theReading[2]==0x0D || theReading[3]==0x0D || theReading[4]==0x0D) )
    {
        for(int i=0; i<5; i++)
            theReading[i] = theReading[i+1];

        if(!ReadFile(hSerial, &(theReading[5]), 1, &dwBytesRead, NULL))
        {
            break;
        }
    }

    for(int i=0; i<6; i++)
        theReading[i]=' ';

    while(theReading[5] != 0x0D || (theReading[0]==0x0D || theReading[1]==0x0D || theReading[2]==0x0D || theReading[3]==0x0D || theReading[4]==0x0D) )
    {
        for(int i=0; i<5; i++)
            theReading[i] = theReading[i+1];
        if(!ReadFile(hSerial, &(theReading[5]), 1, &dwBytesRead, NULL))
        {
            break;
        }
    }
    theReading[5]=' ';
    cout<<theReading;
}




int main()
{
    HANDLE hSerial;
    hSerial = CreateFile("\\\\.\\COM14",
                         GENERIC_READ | GENERIC_WRITE,
                         0,
                         0,
                         OPEN_EXISTING,
                         FILE_ATTRIBUTE_NORMAL,
                         0);
    if(hSerial==INVALID_HANDLE_VALUE) {
        if(GetLastError()==ERROR_FILE_NOT_FOUND) {
            //serial port does not exist. Inform user.
        }
        //some other error occurred. Inform user.
        return 0;
    }



    DCB dcbSerialParams = {0};
    dcbSerialParams.DCBlength=sizeof(dcbSerialParams);
    if (!GetCommState(hSerial, &dcbSerialParams)) {
//error getting state
        return 0;
    }
    dcbSerialParams.BaudRate=CBR_115200;
    dcbSerialParams.ByteSize=8;
    dcbSerialParams.StopBits=ONESTOPBIT;
    dcbSerialParams.Parity=NOPARITY;
    if(!SetCommState(hSerial, &dcbSerialParams)) {
//error setting serial port state
        return 0;
    }

    COMMTIMEOUTS timeouts= {0};
    timeouts.ReadIntervalTimeout=50;
    timeouts.ReadTotalTimeoutConstant=50;
    timeouts.ReadTotalTimeoutMultiplier=10;

    timeouts.WriteTotalTimeoutConstant=50;
    timeouts.WriteTotalTimeoutMultiplier=10;
    if(!SetCommTimeouts(hSerial, &timeouts)) {
//error occureed. Inform user
    }
    FlushFileBuffers(hSerial);
    takeReading(hSerial);

    CloseHandle(hSerial);

}

