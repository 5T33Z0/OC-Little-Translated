# I2C-TPXX Patch Method

## Description

This method provides a solution for implementing Hotpatch patches to I2C devices. This method does not cover the specific process and details of I2C patching. For more details on I2C, check:

- [**Official VoodooI2C Documentation**](https://voodooi2c.github.io/)
- [**TouchPad-Hotfix Example Library**](https://github.com/GZXiaoBai/Hackintosh-TouchPad-Hotpatch) by GZXiaoBai
- [**Official VoodooI2C Support Thread**](https://www.tonymacx86.com/threads/voodooi2c-help-and-support.243378/)
- [**VoodooI2C Support on Gitter**](https://gitter.im/alexandred/VoodooI2C) – Ask the  VoodooI2C dev for support directly

## Patching principle

### 1. Enable GPI0
> **SAMPLEs**: `SSDT-GPI0_GPEN` and `SSDT-GPI0_GPHD`
  
- If GPI0 is to be enabled, its `_STA` must be `Return (0x0F)`.
- Make sure that `GPEN` or `GPHD` exists in `_STA` of `GPI0` device (check "Binary renaming and preset variables" for details)
- Disable the original I2C device:
	```asl
	DefinitionBlock("", "SSDT", 2, "OCLT", "GPI0", 0)
	{
		External(GPEN, FieldUnitObj)
		//External(GPHD, FieldUnitObj)
		
		Scope (\)
    	{
			If (_OSI ("Darwin"))
			{
				GPEN = 1
				//GPHD = 2
			}
		}
	}
	```
### 2. Create a new I2C Device

- Create a new I2C device `TPXX` and migrate all the contents of the original device to `TPXX`.
- Fix `TPXX` related content.
- Replace the original I2C device `name` by `TPXX` (all ocurrances).
- Enable it for macOS only (set `_STA` to `0x0F`)
	```asl
    Method (_STA, 0, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            Return (0x0F)
        }
        Else
        {
            Return (Zero)
        }
    }
	```
- Continue adding the required I2C patch for your device

## Example: Dell Latitude 5480
> Device path: `\_SB.PCI0.I2C1.TPD1`

- Disable ``TPD1`` using the Preset Variable Method.
	```asl
  Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          SDS1 = 0
      }
  }
  	```
- Create a new device `TPXX` and port all the contents of the original `TPD1` to `TPXX`.
	```asl
  External(_SB.PCI0.I2C1, DeviceObj)
  Scope (_SB.PCI0.I2C1)
  {
      Device (TPXX)
      {
         Original TPD1 content
      }
  }
	  ```
- Amend `TPXX` content:
	- All `TPD1` replaced with `TPXX`.
  	- Replace the `_STA` part of the patch with
 	```asl
	Method (_STA, 0, NotSerialized)
	{
        If (_OSI ("Darwin"))
        {
            Return (0x0F)
        }
        Else
        {
            Return (Zero)
        }
    }
	```
 - Look up `SDS1` (the variable used when `TPD1` is disabled) and change the original `If (SDS1...) ` to `If (one)`.  
 - Look up `OSYS` and remove (comment out) the following.
	
	```asl
    //If (LLess (OSYS, 0x07DC))
    //{
    // SRXO (GPDI, One)
    //}
	```
	**Note**: I2C devices do not work when `OSYS` is less than `0x07DC` (`0x07DC` stands for Windows 8).
	
	- Add external reference `External…` to fix all errors.
	- I2C patch (omitted)

## Other I2C Hotpatches
In the file list above you will also find `SSDT-USTP.dsl` (in 2 variants), which are widely used in hackintosh laptops for enabling Trackpads. Use either or. 

**Applicable to**: Laptops (6th to 10th Gen Intel Core CPUs)

### Adding SSDT-USTP
#### Patch Method
- In `DSDT`, search for `USTP`
- If present, check which I2C device is used in the scope it is related to. 
- If the scope points to device `I2C0`, add `SSDT-I2C0_USTP.aml`.
- If the scope points to device `I2C1`, add `SSDT-I2C1_USTP.aml`.

In this example, it is related to `I2C1`:

```asl
If (USTP)
  {
      Scope (_SB.PCI0.I2C1)
      {
          Method (SSCN, 0, NotSerialized)
          {
              Return (PKG3 (SSHI, SSLI, SSDI))
          }

          Method (FMCN, 0, NotSerialized)
          {
              Return (PKG3 (FMHI, FMLI, FMDI))
          }

          Method (FPCN, 0, NotSerialized)
          {
              Return (PKG3 (FPHI, FPLI, FPDI))
          }

          Method (M0D3, 0, NotSerialized)
          {
              Return (PKG1 (M0CI))
          }

          Method (M1D3, 0, NotSerialized)
          {
              Return (PKG1 (M1CI))
          }
      }
  }
```
To make the Hotpatch work, disable the original by renaming it from `USTP` to `XSTP`. In `ACPI/Patch`, add the following rename rule:

```text
Comment: Change USTP to XSTP
Find: 5553545008
Replace: 5853545008
```
### Adding SSDT-I2C_SPED
#### Patch Method
- In `DSDT`, search for the `I2C0` or `I2C1` Controller
- If present, check if it contains the methods `SSCN` and `FMCN`. They are essential for Trackpads to work properly in macOS. 
- When no matches are found add `SSDT-I2C_SPED` 

**NOTE**: Make sure the PCI path used in the SSDT matches the one used in the DSDT to make the whol construct work.

## New kexts for I2C Synaptic and ELAN Touchpads
If your touchpad is controlled via SMBus you could try one of these kexts:

- [**VoodooRMI**](https://github.com/VoodooSMBus/VoodooRMI): Synaptic Trackpad driver over SMBus/I2C for macOS 
- [**VoodooSMBUS**](https://github.com/VoodooSMBus/VoodooSMBus): I2C-I801 driver port for macOS X + ELAN SMBus for Thinkpad T480s, L380, P52 
- [**VoodooElan**](https://github.com/VoodooSMBus/VoodooElan): ELAN Touchpad/Trackpoint driver for macOS over SMBus 
- [**VoodooTrackpoint**](https://github.com/VoodooSMBus/VoodooTrackpoint):  Generic Trackpoint/Pointer device handler kext for macOS  
