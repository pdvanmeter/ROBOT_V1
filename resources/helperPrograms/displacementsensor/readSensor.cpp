#include "displacementsensor.h"

int main(int argc, char * argv[])
{
    try {
        char serialPort[128] = 	"/dev/com14";
        speed_t serialBaud = B115200;
        DisplacementSensor sensor(serialPort, serialBaud);
        /*
        sensor.DAT_OUT_OFF();
        sensor.LASER_ON();
        sensor.ASCII_OUTPUT(1);
        sensor.SET_OUTPUT_CHANNEL(1);

        sensor.SET_OUTPUTMODE(0);

        //sensor.SET_OUTPUTMODE(1);
        //sensor.SET_OUTPUTTIME_MS(750);

        //sensor.SET_TEACH_VALUE(100.0, 15000.0);
        sensor.RESET_TEACH_VALUE();
        sensor.GET_INFO();
        //sleep(1);
        sensor.DAT_OUT_ON();
        //cout<<endl<<endl;
        //sensor.startReading();
        */
        int theReading = sensor.getReadingASCII();
        cout<< theReading;
        return 0;
    }
    catch(char * errorMessage)
    {
        cout<<errorMessage<<endl;
        return -1;
    }
}
