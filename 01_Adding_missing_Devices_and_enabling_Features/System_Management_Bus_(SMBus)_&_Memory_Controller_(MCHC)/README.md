# Fixing AppleSMBus

## Description
What is AppleSMBus? Well, it mainly handles the System Management Bus, which has various functions, like:

* **AppleSMBusController**: Aids with correct Temperature, Fan, Voltage, ICH, and other readings.  
* **AppleSMBusPCI**: Same idea as AppleSMBusController except for low bandwidth PCI devices.
* **Memory Reporting**: Aids in proper memory reporting and can aid in getting better memory-related kernel panic details.

Other things SMBus does: read the [SMBus WIKI](https://en.wikipedia.org/wiki/System_Management_Bus)

## Patch Instructions

### 1. Find the device name of your system's SMBus
Search for `0x001F0003` (before generation 6) or `0x001F0004` (generation 6 and later) in `DSDT` to find the name of the device it belongs to. It's will either be called `SBUS` or `SMBU`. **NOTE**: In ThinkPads it's mostly called `SMBU`.

### 2. Pick the corresponding SSDT
Depending on the results of your search, add the corresponding SSDT to your ACPI Folder and config.plist:

- If th device name is `SBUS`, use ***SSDT-SBUS***
- If the device name is `SMBU`, use ***SSDT-SMBU***
- If the device name is other name, modify the patch content by yourself

### 3. Test if AppleSMBus is working
After you've added the correct SSDT reboot your system. To find out if the AppleSMBUS is working, run Terminal and enter:

`kextstat | grep -E "AppleSMBusController|AppleSMBusPCI"`

If the Termonal output contains the following 2 drivers, your SMBus is working correctly:

- com.apple.driver.AppleSMBusPCI
- com.apple.driver.AppleSMBusController

## Editorial Note:
Additional background information about `AppleSMBus` as well as the GREP command for testing the functinality of the SMBUs Driver were taken from Dortania's Post-Install Guide for OpenCore, since the original README by DahlianSky was lacking in this regard. The official SSDT sample included in the OpenCore package combines SSDT-SMBUS and SSDT-MCHC into one file (`SSDT-SBUS-MCHC.aml`), so I suggest you use this instead. 
