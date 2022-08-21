# SSDT Patching Guidelines and Examples
> WORK IN PROGRESS…

## Dos and Don'ts
- **Avoid Binary Renames!** Although the binary rename method is especially effective on systems running macOS only, these patches should be used with **caution**. On multi-boot systems with different Operating Systems, they can cause issues since binary renames apply system-wide when using OpenCore. The best way to avoid such issues is to bypass OpenCore when booting into a different OS altogether. Or use Clover instead, since it does not inject patches into other OSes by default.
- **Use SSDTs!** Whenever possible, use SSDTs to inject preset variables and/or (virtual) Devices since this method is very reliable and ACPI conform (if done correctly). **Recommended approach**. 
- **Use SSDTs to rename devices!** Instead of using binary renames to rename a device, you can write a simple SSDT which makes use of **External Reference**, **Scopes** and the  **`_STA`** method to disable the original device, add it under a new name for macOS only which is much cleaner. **Example**: &rarr; [**SSDT-NAVI.aml**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/GPU/AMD_Navi/README.md#ssdt-navi-content)
- **Combine Binary Renames and SSDTs!** If your have to use a binary rename to disable a method inside of a device (e.g. `_DSM` to `XDSM`), limit its reach by specifing the ACPI path (use the `base` parameter). Combine it with an SSDT (`SSDT-XDSM`) with **External References and Scopes** to modify the renamed method (here `XDSM`) and define some new for it: "when macOS is running do this, if it's not running return the orginal content of `_DSM`".
- Try new/different preset variables! There are more ways to modify the DSDT then just disabling devices and/or methods and redefining them. You can also address other parameters which can make patching even easier. **Example**: &rarr; [**SSDTT-PRW0**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/060D_Instant_Wake_Fix#method-2-using-ssdt-prw0aml-no-gprwuprw)

## Requirments
- Dump of unmodified ACPI tables from your system, mainly the `DSDT`. &rarr; [**Instructions**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features#obtaining-acpi-tables)
- An IDE to open, edit and export ASL files, like [**maciASL**](https://github.com/acidanthera/MaciASL) or [**Xiasl**](https://github.com/ic005k/Xiasl)

## Structure and components of a SSDT
The examples used in this section are code snippets that showcase the structure and principle of an SSDT.

### 1. The `DefinitionBlock`
The foundation of every SSDT is its `DefinitionBlock`. All ASL code must reside
inside of DefinitionBlock declarations `{}` to be valid. ASL code found outside of any DefinitionBlock will be regarded as invalid. 

General form of the DefinitionBlock (numbers indicate the amount of letters that can be used in each section):

```asl
DefinitionBlock ("", "1234", 2, "123456", "12345678", 0x00000000)
```

The `DefinitionBlock` provides information about itself (in brackets):

Parameter | Description|
----------|--------------
**AMLFileName**| Name of the AML file. Can be a null string.
**TableSignature**| Signature of the AML file (can be `DSDT` or `SSDT`). 4-character string
**ComplianceRevision**| A value of `2` or greater enables 64-bit arithmetic (for 64 bit Systems)</br>A value of `1` or less enables 32-bit arithmetic (for 32 bit Systems)
**OEM ID**| ID of the original equipment manufacturer (OEM) developing the ACPI table (6-character string)
**OEM Table ID**| A specific identifier for the table (8-character string)
**OEMRevision**| Revision number set by the OEM (32-bit number)

### Common `DefinitionBlock` Example
:bulb: For hackintoshing, we usually use something like this. The SSDT begins with:

```asl
DefinitionBlock ("", "SSDT", 2, "Hack", "CpuPlug", 0x00000000)
{
	// Your code goes here!
```
and is ended by:

```asl
}
```
**Translation**:

- `""` &rarr; **AMLFileName** 
- `"SSDT"` &rarr; **TableSignature**
- `2` &rarr; **ComplianceRevision** (for 64 bit OSes)
- `"hack"` &rarr; **OEM ID** (Author name): "hack" is pretty common bur genereic. OC Little tables use `"OCLT"`. For my own tables, I use `"5T33Z0"`. 
- `"CpuPlug"` &rarr; **OEM Table ID**: Name the SSDT is identified as in the ACPI environment (not the file name). Usually, we name the SSDT based on the `Device` or `Method` it addresses. In this example `"CpuPlug"`.

**NOTE**: If you write replacement tables (e.g. for USB port declarations), you need to use the same OEM Table ID as the table you want to replace. 

### 2. `External` References

External References (or Quotes) and Scopes are the backbone of an SSDT if you want to modify/replace content of the `DSDT`. You need them to tell the system, "Hey, look, I want you to check this location of the DSDT and change the following:…". 

Listed below you find commonly used external References. The most used being `DeviceObj` and `MethodObj` (for device and methods):

Object Type  | External Reference Example | Addresses    
:-----------:|----------------------------|------------- 
UnknownObj   | `External (\_SB.EROR, UnknownObj)`| (avoid to use)
IntObj       | `External (TEST, IntObj)`         | `Name (TEST, 0)`
StrObj       | `External (\_PR.MSTR, StrObj)`    | `Name (MSTR,"ASL")`                                                         BuffObj      | `External (\_SB.PCI0.I2C0.TPD0.SBFB, BuffObj` | `Name (SBFB, ResourceTemplate ()`<br/>`Name (BUF0, Buffer() {"abcde"})`
PkgObj       | `External (_SB.PCI0.RP01._PRW, PkgObj`        | `Name (_PRW, Package (0x02) { 0x0D, 0x03 })` 
FieldUnitObj | `External (OSYS, FieldUnitObj`                | `OSYS,   16,`                                                           
DeviceObj    | `External (\_SB.PCI0.I2C1.ETPD, DeviceObj)`    | `Device (ETPD)`                                                         
EventObj     | `External (XXXX, EventObj)`                    | `Event (XXXX)`                                                          
MethodObj    | `External (\_SB.PCI0.GPI0._STA, MethodObj)`    | `Method (_STA, 0, NotSerialized)`
MutexObj     | `External (_SB.PCI0.LPCB.EC0.BATM, MutexObj)`  | `Mutex (BATM, 0x07)`                                                    
OpRegionObj  | `External (GNVS, OpRegionObj)`                 | `OperationRegion (GNVS, SystemMemory, 0x7A4E7000, 0x0866)`
PowerResObj  | `External (\_SB.PCI0.XDCI, PowerResObj)`       | `PowerResource (USBC, 0, 0)`
ProcessorObj | `External (\_SB.PR00, ProcessorObj)`           | `Processor (PR00, 0x01, 0x00001810, 0x06)`
ThermalZoneObj| `External (\_TZ.THRM, ThermalZoneObj`         | `ThermalZone (THRM)`                                                    
BuffFieldObj  | `External (\_SB.PCI0._CRS.BBBB, BuffFieldObj` | `CreateField (AAAA, Zero, BBBB)`

### 3. `_OSI` (Operating System Interfaces)
The `_OSI` method is your best friend when it comes to hackintoshing. You should use it in every SSDT so the patch on applies when macOS is running. 

When the `_OSI` string matches the current system, it returns `1` since the `If` condition is valid. In other words: this only applies the patch defined in the SSDT if macOS is running. The string looks like this:

```asl
If (_OSI ("Darwin"))
```
**NOTE**: More [`_OSI` variants](https://uefi.org/specs/ACPI/6.4/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#osi-operating-system-interfaces) do exist, but for out puposes we only need this one.

### 4. `_STA` (Status)
This is another very useful method for hackintoshing. Unlike binary renames, you cannot simply delete or change text randomly in the DSDT when using SSDTs – you have to address locations and parameters specifically and find other ways to replace devices, methods and parameters. Therefore, you have to apply other strategies to do so. A very simple yet powerful technique is to just disable a device (set `_STA` to `Zero`) when macOS is running and replace it by another device instead that you inject via the SSDT.

It can be use
5 types of bit can be returned via `_STA` method:

| Bit     | Explanation                          |
| :-----: | :----------------------------------- |
| Bit [0] | Set if the device is present.
| Bit [1] | Set if the device is enabled and decoding its resources.
| Bit [2] | Set if the device should be shown in the UI.
| Bit [3] | Set if the device is functioning properly (cleared if device failed its diagnostics).
| Bit [4] | Set if the battery is present.

These bits can be turned on (1) and off (0). So, if we want bits 1 to 4 to be enabled, you convert `1111` from binary to HEX which results in the well-known `0x0F`. If we want none of the device to be disabled, we write `Zero`. In ASL, `Zero` and `One` are the only cases where you actual can use a word as a value.

We also encounter `0x0B` (= `1011`) and `0x1F` (= `11111`) sometimes. `0x0B` means the device is enabled but it is not allowed to decode its resources. `0x0B` is often utilized in ***`SSDT-PNLF`***. `0x1F` (`11111`) only appears to describe battery device in a laptop, the last bit is utilized to inform the Battery Controller `PNP0C0A` that the battery is present.

We can combine both the `_OSI` and `_STA` method to create the main building blocks for SSDTs which only apply their patches to macOS:

#### Enable in macOS

```asl
Method (_STA, 0, NotSerialized)
   {
        If (_OSI ("Darwin"))	// If the darwin kernel is running
        {
            Return (0x0F)		// Enable the device defined in the SSDT
        }
        Else					// If Darwin is not running,
        {
            Return (Zero) // Disable it
        }
    }
```

#### Disable in macOS
Naturally, you can also use this the other way around:
```asl
Method (_STA, 0, NotSerialized)  // _STA: Status
{
    If (_OSI ("Darwin"))
    {
        Return (0) // Disable in macOS!
    }
    Else
    {
        Return (0x0F) // Leaves enabled for all other OSes!
    }
}
```
**⚠️ CAUTION**: Two types of `_STA` method exist. Do not confuse it with `_STA` from `PowerResource`! It can only return `One` or `Zero`. Please refer to the `ACPI Specification` for details.

## SSDT Example 1: disable a device in favor of another one
With these four componens alone (`DefinitionBlock`, `External` reference, `_OSI` and `_STA` method), we can already write our first SSDT:

```asl
DefinitionBlock ("", "SSDT", 2, "OCLT", "AWAC", 0x00000000)
{
    External (STAS, FieldUnitObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            STAS = One
        }
    }
}
```
What it does: in the root of the `DSDT` (indicated by `\`) it looks for the `FieldUnitObj` called `STAS` and changes it's value to `1` if the macOS Kernel is running. We can understand it better, by looking into the `DSDT`. We find the following:

```asl
Device (AWAC)
{
    ...
    Method (_STA, 0, NotSerialized)
    {
            If ((STAS == Zero))		// If STAS = 0
            {
                Return (0x0F) 		// enable AWAC
            }
            Else					// if STAS ≠ 0
            {
                Return (Zero)		// disable AWAC
            }
    }
    ...
}

Device (RTC)
{
    ...
    Method (_STA, 0, NotSerialized)
    {
            If ((STAS == One)) // If STAS = 1
            {
                Return (0x0F)  // Turn RTC ON
            }
            Else 			   // if STAS ≠ 1
            {
                Return (Zero)  // Turn RTC OFF
            }
    }
    ...
}

```
As you can see, devices `RTC` and `AWAC` are switched on or off based on the value `_STA` has: if _STA is `0`, AWAC is enabled, and RTC is disabled. If the SSDT is `0x0F`, the switch is flipped and RTC is enabled instead.  

:warning: This SSDT is conditional – if it works or not depends on the content of the DSDT. If the default STA values for RTC and AWAC were the other way around in the DSDT, you wouldn't need this patch, because RTC were active. And using it in this case actually would disable the RTC and enable AWAC instead and the system wouldn't boot! So always cross reference with the DSDT before applying patches if you are uncertain.

### 5.Device Identification Objects

Device identification objects associate each platform device with a Plug and Play device ID for each device. The most commonly used ones in our context are `_ADR`, `_CID`, `_HID` and `_UID`:

Object | Description
------|---------
`_ADR`|Object that evaluates to a device’s address on its parent bus.
`_CID`| Object that evaluates to a device’s Plug and Play-compatible ID list.
`_CLS`|Object that evaluates to a package of coded device-class information.
`_DDN`|Object that associates a logical software name (for example, COM1) with a device.
`_HID`|Object that evaluates to a device’s Plug and Play hardware ID.
`_HRV`|Object that evaluates to an integer hardware revision number.
`_MLS`|Object that provides a human readable description of a device in multiple languages.
`_PLD`|Object that provides physical location description information.
`_SUB`|Object that evaluates to a device’s Plug and Play subsystem ID.
`_SUN`|Object that evaluates to the slot-unique ID number for a slot.
`_STR`|Object that contains a Unicode identifier for a device. Can also be used for thermal zones.
`_UID`|Object that specifies a device’s unique persistent ID, or a control method that generates it.

**Source**: [**ACPI Specs**, Chpt. 6.1](https://uefi.org/specs/ACPI/6.4/06_Device_Configuration/Device_Configuration.html#device-identification-objects)

### `_CRS` (Current Resource Settings)
`_CRS` returns a `Buffer`. It is often utilized to acquire touchable devices' `APIC Pin` or `GPIO Pin` for controlling the interrupt mode.

[…]

## SSDT Loading Sequence

Typically, SSDT patches are targeted at the machine's ACPI (either the DSDT or other SSDTs). Since the original ACPI is loaded prior to SSDT patches, there is no need for SSDTs in the `Add` list to be loaded in a specific order. But there are exceptions to this rule. For example, if you have 2 SSDTs (SSDT-X and SSDT-Y), where SSDT-X defines a `device` which SSDT-Y is "cross-referencing" via a `Scope`, then these the two patches have to be loaded in the correct order/sequence for the whole patch to work. Generally speaking, SSDTs being "scoped" into have to be loaded prior to the ones "scoping".

### Examples

- **Patch 1**：***SSDT-XXXX-1.aml***
  
  ```asl
  External (_SB.PCI0.LPCB, DeviceObj)
  Scope (_SB.PCI0.LPCB)
  {
      Device (XXXX)
      {
          Name (_HID, EisaId ("ABC1111"))
      }
  }
  ```
- **Patch 2**：***SSDT-XXXX-2.aml***

  ```asl
  External (_SB.PCI0.LPCB.XXXX, DeviceObj)
  Scope (_SB.PCI0.LPCB.XXXX)
  {
        Method (YYYY, 0, NotSerialized)
       {
           /* do nothing */
       }
    }
  ```
- SSDT Loading Sequence in `config.plist` under `ACPI/Add`: 

  ```XML
  Item 1
            path    <SSDT-XXXX-1.aml>
  Item 2
            path    <SSDT-XXXX-2.aml>
  ```
  
**TO BE CONTINUED…**

## CREDITS & RESOURCES
- Original [**ASL guide**](http://bbs.pcbeta.com/forum.php?mod=viewthread&tid=944566&archive=2&extra=page%3D1&page=1) by suhetao
- [**ACPI Specifications**](https://uefi.org/htmlspecs/ACPI_Spec_6_5_html/) by UEFI.org
- ASL Tutorial by acpica.org ([**PDF**](https://acpica.org/sites/acpica/files/asl_tutorial_v20190625.pdf)). Good starting point if you want to get into fixing your `DSDT` with `SSDT` hotpatches.
