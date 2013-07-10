#include "spotseeker.h"
#include "math.h"

#include <iostream>
#include <string>
#include <sstream>
#include "string.h"
using namespace std;

template <class T>
bool from_string(T& t, const std::string& s, std::ios_base& (*f)(std::ios_base&))
{
	std::istringstream iss(s);
	return !(iss >> f >> t).fail();
};

int main(int argc, char *argv[])
{
	SpotSeeker theBot;
	
	const int strLimit=200;
	char cmdtype;
	char cmdsubtype;
	int cmdvalue;

	int str_size;
	char *str_char;
	int i;
	int act_pulses;
	int Verbose;
	bool steady=false;

 		str_char= argv[1];
		str_size=strlen(str_char);

		//'Mininum command is two characters and a <CR>, otherwise discard
		if ( str_size < 2  && toupper(str_char[0]) != 'H' && toupper(str_char[0]) !='Q')
		{
			cout<<"Error: <2 Char"<<endl;
			return 0;
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
			return 0;
			break;		
		case -1:
			//'Numeric error
			cout<<"Error: Invalid Number";
			break;


		case 'V':
			//'Verbose reply to M commands
			if (cmdsubtype == '1')
			{
				Verbose = 1;
				cout<<"1";
			}
			else
			{
				Verbose = 0;
				cout<<"0";
			}
			break;

		case 'P':
			//'Power Control
			if (cmdsubtype == '1')         // 'P1
			{				
				if (Verbose)
					cout<<"Power: On";
				else
					cout<<"1";
			}
			else                          //'P0
			{
				if (Verbose)
					cout<<"Power: Off";
				else
					cout<<"0";
			}
			break;
		case 'S':
			//'Power Control
			if (cmdsubtype == '1')         // 'P1
			{				
				if (Verbose)
					cout<<"Steady: On";
				else
					cout<<"1";
				steady=true;
			}
			else                          //'P0
			{
				if (Verbose)
					cout<<"Steady: Off";
				else
					cout<<"0";
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
				cout<<"0";
				break;

			case 'X':
				cout<<theBot.getPosition().x;
				break;
			case 'Y':
				cout<<theBot.getPosition().y;
				break;
			case 'Z':
				cout<<theBot.getPosition().z;
				break;
			case 'R':
				cout<<theBot.getPosition().r;
				break;
			default:
				cout<<"Error: Invalid SubCmd";
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
						cout<<"Left: ";
					else
						cout<<"Right: ";
					cout<<cmdvalue;
					cout<<", Moved: ";
				}
				act_pulses = theBot.moveLink(0,cmdvalue,steady);
				cout<<act_pulses;
				break;
			case 'Y':
				//'Move Y Stepper
				if (Verbose)
				{
					if (cmdvalue < 0)
						cout<<"Down: ";
					else
						cout<<"Up: ";
					cout<<cmdvalue;
					cout<<", Moved: ";
				}
				act_pulses = theBot.moveLink(1,cmdvalue,steady);
				cout<<act_pulses;
				break;
			case 'Z':
				//'Move Z Stepper
				if (Verbose)
				{
					if (cmdvalue < 0)
						cout<<"Out: ";
					else
						cout<<"In: ";
					cout<<cmdvalue;
					cout<<", Moved: ";
				}
				act_pulses = theBot.moveLink(2,cmdvalue,steady);
				cout<<act_pulses;
				break;
			case 'R':
				//'Move R Stepper
				if (Verbose)
				{
					if (cmdvalue < 0)
						cout<<"CCW: ";
					else
						cout<<"CW: ";
					cout<<cmdvalue;
					cout<<", Moved: ";
				}
				act_pulses = theBot.moveLink(3,cmdvalue,steady);
				cout<<act_pulses;
				break;
			default:
				cout<<"Error: Invalid SubCmd";
				break;
			}
			break;
		default:
			cout<<"Error: Invalid Cmd";
			break;
		}
		cout<<endl;
return 0;
}