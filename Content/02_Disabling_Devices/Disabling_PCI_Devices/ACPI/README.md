# Disabling PCI devices

**INDEX**

- [Description](#description)
- [Device name](#device-name)
- [SSDT Disable Patch Example](#ssdt-disable-patch-example)

---

## Description

In some cases you may want to disable a PCI device. For example, the HDMI Audio Device of a discrete GPU or a SD Card Reader attached via PCIe which is not working under macOS. You can disable PCI devices with a custom SSDT patch.

These devices have the following characteristics:

- It is a **child device** of a **parent PCI device**
- The **parent device** defines some variables, such as `PCI_Config` or `SystemMemory`, where bit `D4` of the data at offset `0x55` is the device operational property
- It has a **Subdevice** address: `Name (_ADR, Zero)`  

## Device name

- The **child device** name on newer machines usually is **`PXSX`**; whereas the **parent device** name is **`RP01`**, **`RP02`**, **`RP03`**, etc.
- Early ThinkPad machines use **child devices** with the name **`SLOT`** or **none** instead; the **parent device** name is **`EXP1`**, **`EXP2`**, **`EXP3`**, etc.
- Other machines may use other names.
- A Laptop's built-in wireless network card belongs to such a device.

## SSDT Disable Patch Example

- The SD card of dell Latitude 5480 belongs to PCI device, device path: `_SB.PCI0.RP01.PXSX`
- Patch file: ***SSDT-RP01.PXSX-disable***:
  ```asl
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

> [!CAUTION]
>
> - If there are multiple **child devices** to a **parent device**, please **use this method with caution**.
> - When using the SSDT, replace `RP01` in the example with the name of the **parent** device to which the disabled child device belongs to, as shown in the example.
> - If the disabled device already includes the `_STA` method, ignore the content between the *possible start* to *possible end* markers of the example.
> - This method does not release the device from the PCI Bus.
