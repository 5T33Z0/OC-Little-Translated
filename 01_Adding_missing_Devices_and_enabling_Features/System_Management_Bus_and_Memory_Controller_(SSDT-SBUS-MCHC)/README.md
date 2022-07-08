# Fixing AppleSMBus (`SSDT-SBUS-MCHC`)

## Description
What is AppleSMBus? Well, it mainly handles the System Management Bus, which has various functions, such as:

* **AppleSMBusController**: Aids with correct Temperature, Fan, Voltage, ICH, and other readings.  
* **AppleSMBusPCI**: Same idea as AppleSMBusController except for low bandwidth PCI devices.
* **Memory Reporting**: Aids in proper memory reporting and can aid in getting better memory-related kernel panic details.

Other things SMBus does can be found in the [**SMBus WIKI**](https://en.wikipedia.org/wiki/System_Management_Bus).

## Instructions

### 1. Check if you need this Fix
Run Terminal and enter:

`kextstat | grep -E "AppleSMBusController|AppleSMBusPCI"`

If the Terminal output contains the following 2 drivers, your SMBus is working correctly:

![sbus_present](https://user-images.githubusercontent.com/76865553/140615883-3c8af435-b09a-4a3e-9746-28f8a05c9e37.png)

If non or only one of the drivers is listed, you need a fix.

### 2. Find the name and PCI path of your system's SMBus

In **DSDT**, search for:

- `0x001F0003` (Gen 6 and older) or `0x001F0004` (Gen 6 and later) 
- Find device name and location of the SMBus Device. It will either be called `SBUS` or `SMBU`. In this example, it's called `SMBU` and is located under `_SB/PCI0/`:</br>![sbusmchc](https://user-images.githubusercontent.com/76865553/177932530-f2190e85-17f2-4d15-9326-c37cd4c410e3.png)

### 3. Pick the correct SSDT[^1]
Depending on the results of your search, add the corresponding SSDT to your ACPI Folder and config.plist:

- If the device name is `SBUS`, use ***SSDT-SBUS.aml***
- If the device name is `SMBU`, use ***SSDT-SMBU.aml***
- If the device name differs, modify the patch content by yourself

### 4. Verify that it's working

Run the GREP command again:

`kextstat | grep -E "AppleSMBusController|AppleSMBusPCI"` 

If the Terminal output contains the following 2 drivers, your SMBus is working correctly:

![sbus_present](https://user-images.githubusercontent.com/76865553/140615883-3c8af435-b09a-4a3e-9746-28f8a05c9e37.png)

[^1]: Additional information about `AppleSMBus` as well as the `GREP` command for testing  were taken from Dortania's Post-Install Guide, since the original Guide by DalianSky was lacking in this regard. The SSDT sample included in the OpenCore package combines `SSDT-SBUS/SMBUS` and `SSDT-MCHC` into one file (`SSDT-SBUS-MCHC.aml`), so I suggest you use this instead.
