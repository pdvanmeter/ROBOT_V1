# Nmake macros for building Windows 32-Bit apps

!include <Win32.Mak>

all: $(OUTDIR) $(OUTDIR)\driver.exe $(OUTDIR)\move.exe $(OUTDIR)\terminal.exe

#----- If OUTDIR does not exist, then create directory
$(OUTDIR) :
    if not exist "$(OUTDIR)/$(NULL)" mkdir $(OUTDIR)

$(OUTDIR)\depend.obj: propeller.cpp spotseeker.cpp
    $(cc) $(cflags) $(cvars) /Fo"$(OUTDIR)\\" /Fd"$(OUTDIR)\\" propeller.cpp spotseeker.cpp

$(OUTDIR)\driver.obj: driver.cpp
    $(cc) $(cflags) $(cvars) /Fo"$(OUTDIR)\\" /Fd"$(OUTDIR)\\" driver.cpp

$(OUTDIR)\terminal.obj: terminal.cpp
    $(cc) $(cflags) $(cvars) /Fo"$(OUTDIR)\\" /Fd"$(OUTDIR)\\" terminal.cpp

$(OUTDIR)\move.obj: move.cpp
    $(cc) $(cflags) $(cvars) /Fo"$(OUTDIR)\\" /Fd"$(OUTDIR)\\" move.cpp

$(OUTDIR)\driver.exe: $(OUTDIR)\depend.obj $(OUTDIR)\driver.obj
    $(link) $(conflags) -out:$(OUTDIR)\driver.exe $(OUTDIR)\driver.obj $(OUTDIR)\propeller.obj $(OUTDIR)\spotseeker.obj TVicPort.lib $(conlibs)

$(OUTDIR)\move.exe: $(OUTDIR)\depend.obj $(OUTDIR)\move.obj
    $(link) $(conflags) -out:$(OUTDIR)\move.exe $(OUTDIR)\move.obj $(OUTDIR)\propeller.obj $(OUTDIR)\spotseeker.obj TVicPort.lib $(conlibs)

$(OUTDIR)\terminal.exe: $(OUTDIR)\depend.obj $(OUTDIR)\terminal.obj
    $(link) $(conflags) -out:$(OUTDIR)\terminal.exe $(OUTDIR)\terminal.obj $(OUTDIR)\propeller.obj $(OUTDIR)\spotseeker.obj TVicPort.lib $(conlibs)
#--------------------- Clean Rule --------------------------------------------------------
# Rules for cleaning out those old files
clean:
        $(CLEANUP)
