# Disabling PCI devices

## Description

Sometimes we want to disable a PCI device. For example, the HDMI Audio Device of a discrete GPU or SD Card Readers attached via PCIe Bus are usually not driven, and even if they are driven, they hardly work. In this case, we can disable this device with a custom SSDT patch.

- These devices have the following characteristics:
  - It is a **child device** of a **parent PCI device**
  - The **parent device** defines some variables of type `PCI_Config`or `SystemMemory`, where bit `D4` of the data at offset `0x55` is the device operational property
  - It has a **Subdevice** address: `Name (_ADR, Zero)`  

## Device name

- The **child device** name on newer machine is **`PXSX`**; **parent device** name is **`RP01`**, **`RP02`**, **`RP03`**, etc.
- Early ThinkPad machines use **child devices** with the name **`SLOT`** or **none**; **parent device** with the name **`EXP1`**, **`EXP2`**, **`EXP3`**, etc.
- The Laptop's built-in wireless network card belongs to such a device.
- Other machines may use other names.

## SSDT Disable Patch Example

- The SD card of dell Latitude 5480 belongs to PCI device, device path: `_SB.PCI0.RP01.PXSX`
- Patch file: ***SSDT-RP01.PXSX-disable***:

  ```swift
  External (_SB.PCI0.RP01, DeviceObj)
  Scope (_SB.PCI0.RP01)
      {
      OperationRegion (DE01, PCI_Config, 0x50, 0x01)
      Field (DE01, AnyAcc, NoLock, Preserve)
      {
              , 4,
          DDDD, 1
      }
  		//possible start
  		Method (_STA, 0, Serialized)
  		{
  				If (_OSI ("Darwin"))
  				{
  					Return (Zero)
  				}
  		}
  		//possible end
  }  
  Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          \_SB.PCI0.RP01.DDDD = One
      }
  }
  ```

## Caution

- If there are multiple **child devices** to a **parent device**, please **use this method with caution**.
- When using it, replace `RP01` in the example with the name of the **parent** to which the disabled device belongs, as in the example.
- If the disabled device already includes the `_STA` method, ignore the *possible start* to *possible end* content, refer to the comments of the example.
- This method does not disconnect the device from the PCI Bus.
