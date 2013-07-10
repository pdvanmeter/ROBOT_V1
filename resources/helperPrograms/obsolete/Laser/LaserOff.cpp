// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved.

#include <stdio.h>
#include "windows.h"
#include "TVicPort.h"

int main()
{
	OpenTVicPort();

        WritePort(0x2050,0x00);

	CloseTVicPort();
        return(0);
}
