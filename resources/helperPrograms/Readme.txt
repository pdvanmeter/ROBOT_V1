In order to build all of these programs, you'll need:

1. The Windows SDK
    http://www.microsoft.com/en-us/download/details.aspx?id=8279

2. cygwin
    http://www.cygwin.com/

3. tvicport
    http://www.entechtaiwan.com/dev/port/index.shtm

If tvicport's certificate is ever revoked, then you'll need to find another way to
do low-level IO on windows and modify propeller.cpp to support it instead.