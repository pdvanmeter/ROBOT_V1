Background:
This project allows us to configure the displacement sensor and take readings from it.

startSensor.exe configures the sensor properly and tells it to start spewing readings.
readSensor.exe gets a reading from the sensor.
readFast.exe is the same as readSensor.exe, only fast.

Building and Deploying:
Open cygwin, then do:
g++ '/cygdrive/c/Users/wberry/My Documents/MATLAB/helperPrograms/displacementSensor/startSensor.cpp' -o /cygdrive/c/Device/startSensor.exe
g++ '/cygdrive/c/Users/wberry/My Documents/MATLAB/helperPrograms/displacementSensor/readSensor.cpp' -o /cygdrive/c/Device/readSensor.exe

For readFast,
cl readFast.cpp