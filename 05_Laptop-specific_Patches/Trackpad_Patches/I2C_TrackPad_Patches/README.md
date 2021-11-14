# I2C-TPXX Patch Method

## Description

This method provides a solution for implementing Hotpatch patches to I2C devices. This method does not cover the specific process and details of I2C patching. For more details on I2C, check:

- [VoodooI2C official documentation](https://voodooi2c.github.io/)
- GZXiaoBai's [TouchPad-Hotfix Example Library](https://github.com/GZXiaoBai/Hackintosh-TouchPad-Hotpatch)
- [VoodooI2C Official Forum Post](https://www.tonymacx86.com/threads/voodooi2c-help-and-support.243378/)

## New kexts for I2C Synaptic and ELAN Touchpads
If your touchpad is controlled via SMBus you could try one of these kexts:

- [**VoodooRMI**](https://github.com/VoodooSMBus/VoodooRMI): Synaptic Trackpad driver over SMBus/I2C for macOS 
- [**VoodooSMBUS**](https://github.com/VoodooSMBus/VoodooSMBus): I2C-I801 driver port for macOS X + ELAN SMBus for Thinkpad T480s, L380, P52 
- [**VoodooElan**](https://github.com/VoodooSMBus/VoodooElan): ELAN Touchpad/Trackpoint driver for macOS over SMBus 
- [**VoodooTrackpoint**](https://github.com/VoodooSMBus/VoodooTrackpoint):  Generic Trackpoint/Pointer device handler kext for macOS  


## Patch principle and process

- Disable the original I2C device. Check "Binary renaming and preset variables" for details.

```swift
  /*
   * GPI0 enable
   */
  DefinitionBlock("", "SSDT", 2, "OCLT", "GPI0", 0)
  {
      External(GPEN, FieldUnitObj)
      // External(GPHD, FieldUnitObj)
      Scope (\)
      {
          If (_OSI ("Darwin"))
          {
              GPEN = 1
              // GPHD = 2
          }
      }
  }
```
- Create a new I2C device `TPXX` and port all the contents of the original device to `TPXX`.
- Fix `TPXX` related content.
  - Replace the original I2C device `name` with `TPXX` in its entirety.
  - **FIXED** `_STA` part to
	
	```swift
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
- **Corrected** the ``relevant content`` of the variables used when the original I2C device was disabled, so that they are logically related.
- **Corrected** the ``relevant content'' of the operating system variable OSYS to make it logical.
- Exclude errors
- I2C patch

### Example (Dell Latitude 5480, device path: `\_SB.PCI0.I2C1.TPD1`)
- Disable ``TPD1`` using the Preset Variable Method.

 ```swift
  Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          SDS1 = 0
      }
  }
  ```
- Create a new device `TPXX` and port all the contents of the original `TPD1` to `TPXX`.
	```swift
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
 
```swift
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
	
	```swift
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

```swift
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

To make the Hotpatch work, disable the original by renaming it from `USTP` to `XSTP`. In `ACPI > Patch`, add the following rename rule:

```text
Comment: Change USTP to XSTP
Find: 5553545008
Replace: 5853545008
```
