Background:
This project allows us to move the SpotSeeker in Windows.

driver.exe is a server program which accepts commands through \\\\.\\pipe\\mynamedpipe
 and manipulates the SpotSeeker accordingly.  It assumes that the SpotSeeker is connected
 to the computer through the parallel port with base address 0x2030.

move.exe is a client which sends its first command line argument to driver.exe.

Dependencies:
 You need to have TVICPort installed in order to allow low-level communicate with the parallel port.

Building:
1. Open Windows SDK 7.1 Command Prompt
2. setenv /x86 /debug
3. cd C:\Users\wberry\Documents\MATLAB\helperPrograms\SpotSeeker_NamedPipe
4. nmake

Deploying:
1. copy C:\Users\wberry\Documents\MATLAB\helperPrograms\SpotSeeker_NamedPipe\WIN7_DEBUG\driver.exe c:\device\driver.exe
2. copy C:\Users\wberry\Documents\MATLAB\helperPrograms\SpotSeeker_NamedPipe\WIN7_DEBUG\move.exe c:\device\move.exe

Use:
1. Attach the SpotSeeker to the parallel port with base address 0x2030.
2. Run driver.exe
3. Use move.exe to send commands to driver.exe.  Example: move.exe mx100