# Operating System Patch (`_OSI to XOSI`) 

## About

`ACPI` can use the `_OSI` (=Operating System Interface) method to check which `Windows` version it is currently running on. However, when running macOS on a PC, none of these checks will return `true` since `Darwin` (name of the macOS Kernels) is running.

But by simulating a certain version of `Windows` when running `Darwin`, we can utilize system behaviors which normally are limited to windows `Windows`. This is useful to better support certain devices like touchpads, etc.

**The Patch consist of two elements**: 

1. Binary renames and a
2. SSDT Hotpatch

**NOTE**: More info about to included more windows versions can be found here: [OSI Strings for Windows Operating Systems](https://docs.microsoft.com/en-us/windows-hardware/drivers/acpi/winacpi-osi#_osi-strings-for-windows-operating-systems) 

## Part 1: Rename Method `_OSI` to `XOSI` 

1. Search for `OSI` in the original `DSDT` 
2. If you find it, add the `_OSI to XOSI` rename listed below.

Add the following Renames (if applicable) to config.plist:

- **OSID to XSID** (only necessary if present in `DSDT` to avoid match with _OSI to XOSI Rename)
 
  ```text
  Find: 4F534944
  Replace: 58534944
  ```
- **OSIF to XSIF** (only necessary if present in `DSDT` to avoid match with _OSI to XOSI Rename)

  ```text
  Find: 4F534946
  Replace: 58534946
  ```
- **_OSI to XOSI** (must be last in this Sequence)

  ```text
  Find: 5F4F5349
  Replace: 584F5349
  ```
  
## Part 2: Hotpatch ***SSDT-OC-XOSI***

```swift
Method(XOSI, 1)
	{
    If (_OSI ("Darwin"))
    {
        If (Arg0 == //"Windows 2009" // = win7, Win Server 2008 R2
                    //"Windows 2012" // = Win8, Win Server 2012
                    //"Windows 2013" // = win8.1
                    //"Windows 2015" // = Win10
                    //"Windows 2016" // = Win10 version 1607
                    //"Windows 2017" // = Win10 version 1703
                    //"Windows 2017.2" // = Win10 version 1709
                    //"Windows 2018" // = Win10 version 1803
                    //"Windows 2018.2"// = Win10 version 1809
                    //"Windows 2018" // = Win10 version 1903
                    //"Windows 2019"  //  = Win10 version 1903
                      "Windows 2020"  //  = Win10 version 2004
            )
        {
            Return (0xFFFFFFFF)
        }
        Else
        {
            Return (Zero)
        }
    }
    Else
    {
        Return (_OSI (Arg0))
    }
}
```

### Usage

- **Maximum Value**: For a single Windows installation, you can set the operating system parameter to the maximum value allowed by the DSDT. For example, if the maximum value of the DSDT is `Windows 2018`, then set `Arg0 == "Windows 2018"`. Usually `Arg0 == "Windows 2013"` above will unlock the system limit for the part.

  **Note**: **OS Patches** are not recommended for single systems.

- **Matching values**: For dual boot system, the set OS parameters should be the same as the Windows system version. For example, if the Windows system is win7, set Arg0 == "Windows 2009".

## :Waring: Important
Some machines use methods indicated by underscores `_` with similar names to `_OSI` (e.g. some Dell machines use `_OSID`, some ThinkPads ues `_OSIF`). If these methods contain the letters "O-S-I" and are located on the `_SB` level, they will accidentally be renamed to `XOSI` by binary renames, which causes ACPI Errors in Windows. So therefore, you need to rename methods like `OSID` and `OSIF` to something else (e.g. `OSID` to `XSID` or `OSID` to `XSIF`) prior to applying the `_OSI to XOSI` rename to avoid ACPI errors. In other words, renames like `OSID to XSID` or `OSIF to XSIF` have to be listed before `_OSI to XOSI` in the `config.plist`.

## Appendix: Origin of OS Patches
When the system is loaded, ACPI's `_OSI` receives a parameter. Different systems receive different parameters and ACPI executes different instructions. For example, if the system is **Win7**, this parameter is `Windows 2009`, and if the system is **Win8**, this parameter is `Windows 2012`. For example:

```swift
If ((_OSI ("Windows 2009") || _OSI ("Windows 2013")))
{
      OperationRegion (PCF0, SystemMemory, 0xF0100000, 0x0200)
      Field (PCF0, ByteAcc, NoLock, Preserve)
      {
          HVD0, 32,
          Offset (0x160),
          TPR0, 8
      }
      ...
  }
  ...
  Method (_INI, 0, Serialized) /* _INI: Initialize */
  {
      OSYS = 0x07D0
      If (CondRefOf (\_OSI))
      {
          If (_OSI ("Windows 2001"))
          {
              OSYS = 0x07D1
          }

          If (_OSI ("Windows 2001 SP1"))
          {
              OSYS = 0x07D1
          }
          ...
          If (_OSI ("Windows 2013"))
          {
              OSYS = 0x07DD
          }

          If (_OSI ("Windows 2015"))
          {
              OSYS = 0x07DF
          }
          ...
      }
  }
  
```
ACPI also defines `OSYS` which describes the used Windows Version in HEX code based on the year. The relationship between `OSYS` and the used Windows version is as follows:
  - `OSYS = 0x07D9`: Win7 system, i.e. `Windows 2009`</br>
  - `OSYS = 0x07DC`: Win8 systems, i.e. `Windows 2012`</br>
  - `OSYS = 0x07DD`: Win8.1 system, i.e. `Windows 2013`</br>
  - `OSYS = 0x07DF`: Win10 system, i.e. `Windows 2015`</br>
  - `OSYS = 0x07E0`: Win10 1607, i.e. `Windows 2016`</br>
  - `OSYS = 0x07E1`: Win10 1703, i.e. `Windows 2017`</br>
  - `OSYS = 0x07E1`: Win10 1709, i.e. `Windows 2017.2`</br>
  - `OSYS = 0x07E2`: Win10 1803, i.e. `Windows 2018`</br>
  - `OSYS = 0x07E2`: Win10 1809, i.e. `Windows 2018.2`</br>
  - `OSYS = 0x7E3`: Win10 1903, i.e. `Windows 2019`</br>
  - `OSYS = 0x7E5`: Win11 21H2, ie `Windows 2021`</br>

**NOTES**:

- When the loaded OS is not recognized by ACPI, `OSYS` is given a default value which varies from machine to machine, some for `Linux`, some for `Windows 2003`, and some for other values.
- Different operating systems support different hardware, for example, I2C devices are only supported from `Win8` onwards.
- When loading macOS, `_OSI` accepts parameters that are not recognized by ACPI, and `OSYS` is given a default value. This default value is usually smaller than the value required by Win8, and obviously I2C does not work. This requires a patch to correct this error, and OS patches are derived from this.
- Some other components may also be related to `OSYS`.
