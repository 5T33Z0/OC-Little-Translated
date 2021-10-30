# Configuring Active State Power Management (ASPM)

## Description

- ASPM, **Active State Power Management**, is a power link management scheme supported at the system level. Under ASPM management, PCI devices attempt to enter power saving mode when they are idle.
- ASPM operates in several modes:
  
  - L0-Normal mode.
  - L0s-Standby mode. L0s mode enables fast entry and exit from the idle state, and after entering the idle state, the device is placed at a lower power consumption.
  - L1-low power standby mode. l1 further reduces power consumption compared to L0s. However, the time to enter or exit the idle state is longer than L0s.
  - L2-Auxiliary power mode. Omitted.
- For machines with `AOAC` technology, try to change the ASPM mode of PCI devices such as `Wireless NIC`, `SSD`, etc. to reduce the power consumption of the machine.
- Changing the ASPM mode of PCI devices may solve issues of some third-party devices not being driven correctly during boot. For example, the SD Card Reader of RTS525A model may not be recognized in `L0s` mode (default mode). After changing it to `L1`, it is recognized correctly.

## Injecting ASPM operation Mode

### `DeviceProperties` injection (preferred method)

- Inject `pci-aspm-default` into the PCI **parent device** and its **child device** respectively
- **Parent Device**
	- L0s/L1 Mode: `pci-aspm-default` = `03000000` [data]
	- L1 Mode: `pci-aspm-default` = `02000000` [data]
   	- Disable ASPM: `pci-aspm-default` = `00000000` [data]
- **Subdevice**
	- L0s/L1 mode: `pci-aspm-default` = `03010000` [data]
	- L1 mode: `pci-aspm-default` = `02010000` [data]
	- Disable ASPM: `pci-aspm-default` = `00000000` [data]
- **Example**:
	The default ASPM of Xiaoxin PRO13 wireless card is L0s/L1, and the device path is: `PciRoot(0x0)/Pci(0x1C,0x0)/Pci(0x0,0x0)`. Refer to the above method, change the ASPM to L1 by injecting `pci-aspm-default`:
  
	```text
	PciRoot(0x0)/Pci(0x1C,0x0)
	pci-aspm-default = 02000000
	......
	PciRoot(0x0)/Pci(0x1C,0x0)/Pci(0x0,0x0)
	pci-aspm-default = 02010000
	```

### SSDT Patch

An SSDT patch can also set ASPM working mode. For example, set a device ASPM to L1 mode, see the example.

- The patch principle is the same as `Disable PCI Devices`, please refer to it.
- Example: ***SSDT-PCI0.RPXX-ASPM***:

	```swift
	External (_SB.PCI0.RP05, DeviceObj)
    Scope (_SB.PCI0.RP05)
    {
        OperationRegion (LLLL, PCI_Config, 0x50, 1)
        Field (LLLL, AnyAcc, NoLock, Preserve)
        {
            L1,   1
        }
    }
    
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            \_SB.PCI0.RP05.L1 = Zero   //Set ASPM = L1
        }
	```           
  
**Note 1**: Xiaoxin PRO13 wireless card path is `_SB.PCI0.RP05`  
**Note 2**: `\_SB.PCI0.RP05.L1 = 1`, ASPM = L0s/L1; `\_SB.PCI0.RP05.L1 = 0`, ASPM = L1.

## Caution

- ***Hackintool*** allows you to view the device ASPM operating mode.
- After changing ASPM, please restore ASPM if an abnormal condition occurs.
