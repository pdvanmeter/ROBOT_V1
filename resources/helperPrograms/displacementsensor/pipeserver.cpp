#undef UNICODE
#undef _UNICODE

#include <windows.h>
#include <stdio.h>
#include <tchar.h>
#include <strsafe.h>
#include <iostream>
using namespace std;
#define BUFSIZE 512

DWORD WINAPI InstanceThread(LPVOID);
VOID GetAnswerToRequest(LPTSTR, LPTSTR, LPDWORD);

HANDLE hSerial;

BOOL takeReading(HANDLE hPipe)
{
    FlushFileBuffers(hSerial);
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
    DWORD cbWritten =0;
    return WriteFile(
               hPipe,        // handle to pipe
               theReading,     // buffer to write from
               6, // number of bytes to write
               &cbWritten,   // number of bytes written
               NULL);        // not overlapped I/O
}




int _tmain(VOID)
{
    BOOL   fConnected = FALSE;
    DWORD  dwThreadId = 0;
    HANDLE hPipe = INVALID_HANDLE_VALUE, hThread = NULL;

    LPTSTR lpszPipename = TEXT("\\\\.\\pipe\\sensorpipe");

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


// The main loop creates an instance of the named pipe and
// then waits for a client to connect to it. When the client
// connects, a thread is created to handle communications
// with that client, and this loop is free to wait for the
// next client connect request. It is an infinite loop.

    for (;;)
    {
        _tprintf( TEXT("\nPipe Server: Main thread awaiting client connection on %s\n"), lpszPipename);
        hPipe = CreateNamedPipe(
                    lpszPipename,             // pipe name
                    PIPE_ACCESS_DUPLEX,       // read/write access
                    PIPE_TYPE_MESSAGE |       // message type pipe
                    PIPE_READMODE_MESSAGE |   // message-read mode
                    PIPE_WAIT,                // blocking mode
                    PIPE_UNLIMITED_INSTANCES, // max. instances
                    BUFSIZE,                  // output buffer size
                    BUFSIZE,                  // input buffer size
                    0,                        // client time-out
                    NULL);                    // default security attribute

        if (hPipe == INVALID_HANDLE_VALUE)
        {
            _tprintf(TEXT("CreateNamedPipe failed, GLE=%d.\n"), GetLastError());
            return -1;
        }

        // Wait for the client to connect; if it succeeds,
        // the function returns a nonzero value. If the function
        // returns zero, GetLastError returns ERROR_PIPE_CONNECTED.

        fConnected = ConnectNamedPipe(hPipe, NULL) ?
                     TRUE : (GetLastError() == ERROR_PIPE_CONNECTED);

        if (fConnected)
        {
            printf("Client connected, creating a processing thread.\n");

            // Create a thread for this client.
            hThread = CreateThread(
                          NULL,              // no security attribute
                          0,                 // default stack size
                          InstanceThread,    // thread proc
                          (LPVOID) hPipe,    // thread parameter
                          0,                 // not suspended
                          &dwThreadId);      // returns thread ID

            if (hThread == NULL)
            {
                _tprintf(TEXT("CreateThread failed, GLE=%d.\n"), GetLastError());
                return -1;
            }
            else CloseHandle(hThread);
        }
        else
            // The client could not connect, so close the pipe.
            CloseHandle(hPipe);
    }

    return 0;
}

DWORD WINAPI InstanceThread(LPVOID lpvParam)
// This routine is a thread processing function to read from and reply to a client
// via the open pipe connection passed from the main loop. Note this allows
// the main loop to continue executing, potentially creating more threads of
// of this procedure to run concurrently, depending on the number of incoming
// client connections.
{
    HANDLE hHeap      = GetProcessHeap();
    TCHAR* pchRequest = (TCHAR*)HeapAlloc(hHeap, 0, BUFSIZE*sizeof(TCHAR));
    TCHAR* pchReply   = (TCHAR*)HeapAlloc(hHeap, 0, BUFSIZE*sizeof(TCHAR));

    DWORD cbBytesRead = 0, cbReplyBytes = 0, cbWritten = 0;
    BOOL fSuccess = FALSE;
    HANDLE hPipe  = NULL;

    // Do some extra error checking since the app will keep running even if this
    // thread fails.

    if (lpvParam == NULL)
    {
        printf( "\nERROR - Pipe Server Failure:\n");
        printf( "   InstanceThread got an unexpected NULL value in lpvParam.\n");
        printf( "   InstanceThread exitting.\n");
        if (pchReply != NULL) HeapFree(hHeap, 0, pchReply);
        if (pchRequest != NULL) HeapFree(hHeap, 0, pchRequest);
        return (DWORD)-1;
    }

    if (pchRequest == NULL)
    {
        printf( "\nERROR - Pipe Server Failure:\n");
        printf( "   InstanceThread got an unexpected NULL heap allocation.\n");
        printf( "   InstanceThread exitting.\n");
        if (pchReply != NULL) HeapFree(hHeap, 0, pchReply);
        return (DWORD)-1;
    }

    if (pchReply == NULL)
    {
        printf( "\nERROR - Pipe Server Failure:\n");
        printf( "   InstanceThread got an unexpected NULL heap allocation.\n");
        printf( "   InstanceThread exitting.\n");
        if (pchRequest != NULL) HeapFree(hHeap, 0, pchRequest);
        return (DWORD)-1;
    }

    // Print verbose messages. In production code, this should be for debugging only.
    printf("InstanceThread created, receiving and processing messages.\n");

// The thread's parameter is a handle to a pipe object instance.

    hPipe = (HANDLE) lpvParam;

    // Write the reply to the pipe.
    FlushFileBuffers(hSerial);
    takeReading(hPipe);


// Flush the pipe to allow the client to read the pipe's contents
// before disconnecting. Then disconnect the pipe, and close the
// handle to this pipe instance.

    FlushFileBuffers(hPipe);
    DisconnectNamedPipe(hPipe);
    CloseHandle(hPipe);

    HeapFree(hHeap, 0, pchRequest);
    HeapFree(hHeap, 0, pchReply);

    printf("InstanceThread exitting.\n");
    return 1;
}
