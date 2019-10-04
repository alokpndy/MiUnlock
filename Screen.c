//
//  Screen.c
//  miMac
//
//  Created by Alok pandey on 04/10/19.
//  Copyright © 2019 Alok pandey. All rights reserved.
//

#include "Screen.h"
#include <IOKit/pwr_mgt/IOPMLib.h>

void wakeDisplay(void)
{
    static IOPMAssertionID assertionID;
    IOPMAssertionDeclareUserActivity(CFSTR("BLEUnlock"), kIOPMUserActiveLocal, &assertionID);
}

void sleepDisplay(void)
{
    io_registry_entry_t reg = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/IOResources/IODisplayWrangler");
    if (reg) {
        IORegistryEntrySetCFProperty(reg, CFSTR("IORequestIdle"), kCFBooleanTrue);
        IOObjectRelease(reg);
    }
}
