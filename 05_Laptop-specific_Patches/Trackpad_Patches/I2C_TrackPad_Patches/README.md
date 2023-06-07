# I2C-TPXX Patch Method

## Description

This method provides a solution for implementing Hotpatch patches to I2C devices. This method does not cover the specific process and details of I2C patching. For more details on I2C, check:

- [**Official VoodooI2C Documentation**](https://voodooi2c.github.io/)
- [**TouchPad-Hotfix Example Library**](https://github.com/GZXiaoBai/Hackintosh-TouchPad-Hotpatch) by GZXiaoBai
- [**Official VoodooI2C Support Thread**](https://www.tonymacx86.com/threads/voodooi2c-help-and-support.243378/)
- [**VoodooI2C Support on Gitter**](https://gitter.im/alexandred/VoodooI2C) – Ask the  VoodooI2C dev for support directly

## Patching principle

### 1. Enable GPI0 Pin 

#### Example 1
> **Based on SSDT Samples**: `SSDT-GPI0_GPEN` and `SSDT-GPI0_GPHD`
  
- For `GPI0` to be enabled, `_STA` must be set to `Return (0x0F)`.
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
		```

#### Example 2: uses a different Device in DSDT
In `DSDT`, search for:

- `SBFG`, present in a valid `GPIO` Pin
- `CRS` return in methods `SBFB` and `SBFG`
- &rarr; `GPIO` requires **VoodooGPIO.kext** (included in VoodooI2C as a PugIn) to enable the GPIO controller, and also requires additional SSDTs.

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

## I2C Kexts
**Necessary base kext**: [**VoodooI2C**](https://github.com/VoodooI2C)</br>
Depending on the Touchpad model (vendor and used protocol), you need additional [**Satellite kexts**](https://voodooi2c.github.io/#Satellite%20Kexts/Satellite%20Kexts):

|Device/Protocol|Kext|Notes|
|---------------|------|-----|
|HID over I2C |**VoodooI2CHID**</br>(included in VoodooI2C)|Implements support for I2C HID using Microsoft's HID over I2C protocol. Can be used with I2C/USB Touchscreens and Touchpads. Requires IC2 HID with property `PNP0C50` (check ACPI device ID in IORegistryExplorer). For I2C HID that have their own propriety protocol (Atmel, Synaptics, ELAN, FTE), a different Satellite kext may produce better results.
|Atmel Multitouch Protocol|**VoodooI2CAtmelMXT**</br>(included in VoodooI2C)|Implements support for the propriety Atmel Multitouch Protocol.|
|ELAN Proprietary|**VoodooI2CElan**</br>(included in VoodooI2C)|Implements support for the Elan protocol for Elan trackpads and touchscreens. Your Elan device may have better support with this kext than with VoodooI2CHID. :warning: some Elan devices (such as ELAN1200+) use a newer protocol which is proprietary. As such, those devices will not work with **VoodooI2CElan**, so you have to use  **VoodooI2CHID** instead. Some ELAN Touchpads require polling to work. Force-enable by adding `force-polling` to the DeviceProperties of the Touchpad or using boot-arg `-vi2c-force-polling`.|
|FTE1001 Touchpad|**VoodooI2CFTE**</br>(included in VoodooI2C)|Implements support for the propriety FTE protocol found on the FTE1001 trackpad. Your FTE device may have better support with this kext than with **VoodooI2CHID**.|
|Synaptics HID |**VoodooI2CSynaptics**</br>(included in VoodooI2C)|Implements support for the propriety Synaptics protocol found on many Synaptics trackpads and touchscreens. Your Synaptics device may have better support with this kext than with **VoodooI2CHID**. :warning: Newer Synaptics devices (such as some of those found on Dell laptops and branded with a Dell ID) use the **F12** protocol which this kext does not yet support. As such, those devices will not work with VoodooI2CSynaptics but may work with **VoodooI2CHID**.
|**Third Party:**|
|Synaptics HID|[**VoodooRMI**](https://github.com/VoodooSMBus/VoodooRMI)|macOS port of Synaptic's RMI Trackpad driver from Linux. This works for both I2C HID Trackpads from Synaptic as well as Synaptic's SMBus trackpads. Requires VoodooI2C **ONLY** if the I2C protocol is used instead of the SMBUS.|
|Alps HID|[**AlpsHID**](https://github.com/blankmac/AlpsHID/releases) (I2C) or</br> [**VoodooPS2Controller**](https://github.com/acidanthera/VoodooPS2/releases) (PS2) |Can be used with USB and I2C/PS2 Alps Touchpads. Often seen on Dell Laptops|</br>
