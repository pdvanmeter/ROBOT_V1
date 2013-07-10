# Nmake macros for building Windows 32-Bit apps

!include <Win32.Mak>

all: $(OUTDIR) $(OUTDIR)\LaserOn.exe $(OUTDIR)\LaserOff.exe

#----- If OUTDIR does not exist, then create directory
$(OUTDIR) :
    if not exist "$(OUTDIR)/$(NULL)" mkdir $(OUTDIR)

$(OUTDIR)\LaserOn.obj: LaserOn.cpp
    $(cc) $(cflags) $(cvars)  /Fo"$(OUTDIR)\\" /Fd"$(OUTDIR)\\" LaserOn.cpp

$(OUTDIR)\LaserOff.obj: LaserOff.cpp
    $(cc) $(cflags) $(cvars)  /Fo"$(OUTDIR)\\" /Fd"$(OUTDIR)\\" LaserOff.cpp

$(OUTDIR)\LaserOn.exe: $(OUTDIR)\LaserOn.obj
    $(link) $(conflags) -out:$(OUTDIR)\LaserOn.exe $(OUTDIR)\LaserOn.obj TVicPort.lib $(conlibs)

$(OUTDIR)\LaserOff.exe: $(OUTDIR)\LaserOff.obj
    $(link) $(conflags) -out:$(OUTDIR)\LaserOff.exe $(OUTDIR)\LaserOff.obj TVicPort.lib $(conlibs)

#--------------------- Clean Rule --------------------------------------------------------
# Rules for cleaning out those old files
clean:
        $(CLEANUP)
