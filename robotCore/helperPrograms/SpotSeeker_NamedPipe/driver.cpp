#undef UNICODE
#undef _UNICODE

#include "spotseeker.h"
#include "math.h"

#include <iostream>
#include <string>
#include <sstream>

#include <windows.h> 
#include <stdio.h> 
#include <tchar.h>
#include <strsafe.h>

#define BUFSIZE 512
 
DWORD WINAPI InstanceThread(LPVOID); 
VOID GetAnswerToRequest(LPTSTR, LPTSTR, LPDWORD);

using namespace std;

void runShell(std::istream& fin, std::ostream & fout);
void displayHelp();

SpotSeeker theBot;

CRITICAL_SECTION theLock;

class CS_Acquire {
    CRITICAL_SECTION & cs;
public:
    CS_Acquire(CRITICAL_SECTION& _cs) : cs(_cs) { EnterCriticalSection(&cs); }
    ~CS_Acquire() { LeaveCriticalSection(&cs); }
};


template <class T>
bool from_string(T& t, const std::string& s, std::ios_base& (*f)(std::ios_base&))
{
	std::istringstream iss(s);
	return !(iss >> f >> t).fail();
};

int _tmain(VOID) 
{ 
   BOOL   fConnected = FALSE; 
   DWORD  dwThreadId = 0; 
   HANDLE hPipe = INVALID_HANDLE_VALUE, hThread = NULL; 
   LPTSTR lpszPipename = TEXT("\\\\.\\pipe\\mynamedpipe");
   InitializeCriticalSection(&theLock);
 
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
	//InstanceThread((LPVOID)hPipe);
	
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

// Loop until done reading
   while (1) 
   { 
   // Read client requests from the pipe. This simplistic code only allows messages
   // up to BUFSIZE characters in length.
      fSuccess = ReadFile( 
         hPipe,        // handle to pipe 
         pchRequest,    // buffer to receive data 
         BUFSIZE*sizeof(TCHAR), // size of buffer 
         &cbBytesRead, // number of bytes read 
         NULL);        // not overlapped I/O 

      if (!fSuccess || cbBytesRead == 0)
      {   
          if (GetLastError() == ERROR_BROKEN_PIPE)
          {
              _tprintf(TEXT("InstanceThread: client disconnected.\n"), GetLastError()); 
          }
          else
          {
              _tprintf(TEXT("InstanceThread ReadFile failed, GLE=%d.\n"), GetLastError()); 
          }
          break;
      }

   // Process the incoming message.
      GetAnswerToRequest(pchRequest, pchReply, &cbReplyBytes); 
 
   // Write the reply to the pipe. 
      fSuccess = WriteFile( 
         hPipe,        // handle to pipe 
         pchReply,     // buffer to write from 
         cbReplyBytes, // number of bytes to write 
         &cbWritten,   // number of bytes written 
         NULL);        // not overlapped I/O 

      if (!fSuccess || cbReplyBytes != cbWritten)
      {   
          _tprintf(TEXT("InstanceThread WriteFile failed, GLE=%d.\n"), GetLastError()); 
          break;
      }
  }

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

VOID GetAnswerToRequest( LPTSTR pchRequest, 
                         LPTSTR pchReply, 
                         LPDWORD pchBytes )
// This routine is a simple function to print the client request to the console
// and populate the reply buffer with a default data string. This is where you
// would put the actual client request processing code that runs in the context
// of an instance thread. Keep in mind the main thread will continue to wait for
// and receive other client connections while the instance thread is working.
{
    _tprintf( TEXT("Client Request String:\"%s\"\n"), pchRequest );
    stringstream theInput;
    theInput << pchRequest;

    stringstream theOutput;
    runShell(theInput, theOutput);	
    

    // Check the outgoing message to make sure it's not too long for the buffer.
   cout<<theOutput.str().c_str()<<endl;
    if (FAILED(StringCchCopy( pchReply, BUFSIZE, theOutput.str().c_str() )))
    {
        *pchBytes = 0;
        pchReply[0] = 0;
        printf("StringCchCopy failed, no outgoing message.\n");
        return;
    }
    *pchBytes = (lstrlen(pchReply)+1)*sizeof(TCHAR);
}


int Verbose;
bool steady=false;
//Modify this to read from the pipe.
void runShell(std::istream& fin = cin, std::ostream & fout = cout)
{
	CS_Acquire acquire(theLock);
	const int strLimit=200;
	char cmdtype;
	char cmdsubtype;
	int cmdvalue;

	int str_size;
	char str_char[strLimit+1];
	int i;
	int act_pulses;


	//initially powered off, in non-verbose mode

	while(!fin.eof()) {
		//Wait for a PC command ( CR terminated string)
		fout<<"COMMAND:";
		str_size=fin.getline(str_char,strLimit).gcount();

		//'Mininum command is two characters and a <CR>, otherwise discard
		if ( str_size < 2  && toupper(str_char[0]) != 'H' && toupper(str_char[0]) !='Q')
		{
			fout<<"Error: <2 Char"<<endl;
			continue;
		}

		cmdtype = toupper(str_char[0]);      //get value of 0th character in command string
		cmdsubtype = toupper(str_char[1]);
		cmdvalue   = 0;             //zero by default

		//If more than just two-letters + <CR>, then cmdvalue present also

		if (str_size > 2)
		{
			if (!from_string<int>(cmdvalue, &str_char[2], std::dec))
				cmdtype=-1;
		}

		//Test 0th character of command string
		switch (cmdtype)
		{
		case 'Q':
			return;
			break;		
		case -1:
			//'Numeric error
			fout<<"Error: Invalid Number";
			break;

		case 'H':
			displayHelp();
			break;

		case 'V':
			//'Verbose reply to M commands
			if (cmdsubtype == '1')
			{
				Verbose = 1;
				fout<<"1";
			}
			else
			{
				Verbose = 0;
				fout<<"0";
			}
			break;

		case 'P':
			//'Power Control
			if (cmdsubtype == '1')         // 'P1
			{				
				if (Verbose)
					fout<<"Power: On";
				else
					fout<<"1";
			}
			else                          //'P0
			{
				if (Verbose)
					fout<<"Power: Off";
				else
					fout<<"0";
			}
			break;
		case 'S':
			//'Power Control
			if (cmdsubtype == '1')         // 'P1
			{				
				if (Verbose)
					fout<<"Steady: On";
				else
					fout<<"1";
				steady=true;
			}
			else                          //'P0
			{
				if (Verbose)
					fout<<"Steady: Off";
				else
					fout<<"0";
				steady=false;
			}
			break;


		case 'L':
			//'Location Set/Get
			switch (cmdsubtype)
			{
			case '0':
				//Set the current location as our origin (0,0,0,0), (x,y,z,r)
				theBot.setOrigin();
				fout<<"0";
				break;

			case 'X':
				fout<<theBot.getPosition().x;
				break;
			case 'Y':
				fout<<theBot.getPosition().y;
				break;
			case 'Z':
				fout<<theBot.getPosition().z;
				break;
			case 'R':
				fout<<theBot.getPosition().r;
				break;
			default:
				fout<<"Error: Invalid SubCmd";
				break;
			}
		case 'M':
			//'Move Command
			switch(cmdsubtype)
			{
			case 'X':
				//'Move X Stepper
				if (Verbose)
				{
					if (cmdvalue < 0)
						fout<<"Left: ";
					else
						fout<<"Right: ";
					fout<<cmdvalue;
					fout<<", Moved: ";
				}
				act_pulses = theBot.moveLink(0,cmdvalue,steady);
				fout<<act_pulses;
				break;
			case 'Y':
				//'Move Y Stepper
				if (Verbose)
				{
					if (cmdvalue < 0)
						fout<<"Down: ";
					else
						fout<<"Up: ";
					fout<<cmdvalue;
					fout<<", Moved: ";
				}
				act_pulses = theBot.moveLink(1,cmdvalue,steady);
				fout<<act_pulses;
				break;
			case 'Z':
				//'Move Z Stepper
				if (Verbose)
				{
					if (cmdvalue < 0)
						fout<<"Out: ";
					else
						fout<<"In: ";
					fout<<cmdvalue;
					fout<<", Moved: ";
				}
				act_pulses = theBot.moveLink(2,cmdvalue,steady);
				fout<<act_pulses;
				break;
			case 'R':
				//'Move R Stepper
				if (Verbose)
				{
					if (cmdvalue < 0)
						fout<<"CCW: ";
					else
						fout<<"CW: ";
					fout<<cmdvalue;
					fout<<", Moved: ";
				}
				act_pulses = theBot.moveLink(3,cmdvalue,steady);
				fout<<act_pulses;
				break;
			default:
				fout<<"Error: Invalid SubCmd";
				break;
			}
			break;
		default:
			fout<<"Error: Invalid Cmd";
			break;
		}
		fout<<endl;
	} 
}

void displayHelp()
{
	cout<<"Power must be ON prior to move commands! Default: OFF"<<endl;
	cout<<"P1 : Power On"<<endl;
	cout<<"P0 : Power Off"<<endl<<endl;

	cout<<"Q : Quit"<<endl<<endl;
	cout<<"X & Y : 3200 steps/inch, or 0.3125 mils/step"<<endl;
	cout<<"    Z : 1000 steps/inch, or 1 mil/step"<<endl;
	cout<<"    R : 2400 steps/revolution, or 0.15deg/step"<<endl<<endl;

	cout<<"MX-3200 : Move X 3200 Pulses Left(-) [-1.0 inch]"<<endl;
	cout<<"MY1600  : Move Y 1600 Pulses Up(+)   [+0.5 inch]"<<endl;
	cout<<"MZ1000  : Move Z 1000 Pulses In(+)   [+1.0 inch]"<<endl;
	cout<<"MR600   : Move Z  600 Pulses CW(+)   [ +90 degs]"<<endl<<endl;
	
	cout<<"SX-3200 : Steadily Move X 3200 Pulses Left(-) [-1.0 inch]"<<endl;
	cout<<"SY1600  : Steadily Move Y 1600 Pulses Up(+)   [+0.5 inch]"<<endl;
	cout<<"SZ1000  : Steadily Move Z 1000 Pulses In(+)   [+1.0 inch]"<<endl;
	cout<<"SR600   : Steadily Move Z  600 Pulses CW(+)   [ +90 degs]"<<endl<<endl;


	cout<<"L0 : Set current location as new origin."<<endl;
	cout<<"LX : Read current X location."<<endl;
	cout<<"LY : Read current Y location."<<endl;
	cout<<"LZ : Read current Z location."<<endl;
	cout<<"LR : Read current R location."<<endl<<endl;

	cout<<"V1 : Enable verbose reply to M commands."<<endl;
	cout<<"V0 : Reply to M commands with only the pulses moved."<<endl<<endl;
}
