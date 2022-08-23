# Configuring Active State Power Management (ASPM)

## Description

ASPM, **Active State Power Management**, is a power link management scheme supported at system level. Under ASPM management, PCI devices attempt to enter power saving mode when they are idle.

- ASPM operates in several modes or states:
  - **`L0`** = Active state: All PCIe transactions and operations are enabled.
  - **`L0s`** = Standby mode. L0s mode enables fast entry and exit from the idle state, and after entering the idle state, the device is placed at a lower power consumption.
  - **`L1`** = Higher latency, lower power standby state. L1 further reduces power consumption compared to L0s. However, the time to enter and exit this state takes longer than in L0s.
  - **`L2`** = Auxiliary-powered link, deep-energy-saving state: in L2, the component’s main power supply inputs and reference clock inputs are shut off. Not covered here.
- For machines using [**AOAC**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines) technology, try to change the ASPM mode of PCI devices such as Wireless cards, SSDs, etc. to reduce overall power consumption of the machine.
- Changing the ASPM mode of PCI devices can solve issues with third-party devices not being detected during boot. For example, Realtek's RTS525A SD Card Reader is only detected after changing its default state from `L0s` to `L1`.

## Injecting ASPM operation mode
There are two methods for setting/changing the ASPM mode: via DeviceProperties or with SSDTs.

### Method 1: Injecting ASPM mode via `DeviceProperties` (recommended):
- Inject `pci-aspm-default` into the PCI **parent device** and its **child device** respectively
- **Parent Device**
	- L0s/L1 Mode: `pci-aspm-default` = `03000000` [data]
	- L1 Mode: `pci-aspm-default` = `02000000` [data]
   	- Disable ASPM: `pci-aspm-default` = `00000000` [data]
- **Subdevice**
	- L0s/L1 mode: `pci-aspm-default` = `03010000` [data]
	- L1 mode: `pci-aspm-default` = `02010000` [data]
	- Disable ASPM: `pci-aspm-default` = `00000000` [data]

#### Example 1: Changing the ASPM mode of an NVMe Disk
You can manually set the ASPM mode of 3rd party SATA and NVMe drives if it's not detected correctly by macOS:

- Open Hackintool
- Click on the `PCIe` Tab
- Check for NVMe disks (listed in the "Subclass" column as "Non-Volatile Memory controller")
- In the "ASPM" column, check the current state of the disk. If it's "Disabled", you may change it.
- Right-click on the entry for the device and select "Copy Device Path"
- Open your `config.plist` with OCAT or a Plist Editor.
- Click on `DeviceProperties` and add an Entry to the "PCIList"
- Paste in the Device path, in this example: `PciRoot(0x0)/Pci(0x1D,0x0)/Pci(0x0,0x0)`
- Next, add the following Properties:
	|Key|Class|Value|
	|---|-----|-----|
	built-in|Data|`01000000` 
	pci-aspm-default|Data |`03010000` (for L0s/L1 mode) or `02010000` (for L1)
	device_type|String|Non-Volatile memory controller (optional key)
	model|String|Name of the Drive (optional key)
- Save the config, reboot
- In hackintool, check the if the ASPM state for the NVMe Disk has changed.

**NOTE**: if you are uncertain which ASPM states are supported by your NVMe Disk, you could use Acidanthera's [NVMeFix kext](https://github.com/acidanthera/NVMeFix) instead, which provides "Autonomous Power State Transition to reduce idle power consumption of the controller".

#### Example 2: Changing the ASPM mode of a WiFi Card
The default ASPM mode of Xiaoxin PRO13 wireless card is `L0s/L1`. Folowing the instructions above, changing the ASPM from `L0s/L1` to `L1` by injecting `pci-aspm-default` would result in:

|PCI Path|Device Property [DATA]|Description
|--------|----------------------|----------
PciRoot(0x0)/Pci(0x1C,0x0)/Pci(0x0,0x0)|pci-aspm-default = 02000000|L0s/L1 (default)
PciRoot(0x0)/Pci(0x1C,0x0)/Pci(0x0,0x0)|pci-aspm-default = 02010000|L1 (modified)

### Method 2: Injecting ASPM via SSDT
An SSDT patch can also set the ASPM working mode. For example, set a device ASPM to L1 mode, see the example.

- The patch principle is the same as for [Disabling PCI Devices](https://github.com/5T33Z0/OC-Little-Translated/tree/main/02_Disabling_Devices/Disabling_PCI_Devices).
- Example: ***SSDT-PCI0.RPXX-ASPM***:
  ```asl
  External (_SB.PCI0.RP05, DeviceObj)
  Scope (_SB.PCI0.RP05)
  {
      OperationRegion (LLLL, PCI_Config, 0x50, 0x01)
      Field (LLLL, AnyAcc, NoLock, Preserve)
      {
          L1,   1
      }
  }
  
  Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          \_SB.PCI0.RP05.L1 = Zero  /* Set ASPM = L1 */
      }
  }
  ```
:bulb:**Note1**: `_SB.PCI0.RP05` = path of the Xiaoxin PRO13 wireless card.</br>
:bulb:**Note2**: L1 = 1 in `\_SB.PCI0.RP05.L1 = 1` actually sets ASPM to `L0s/L1`, whereas L1 = 0 in `\_SB.PCI0.RP05.L1 = 0` sets ASPM to `L1`.

## :warning: Caution
If you notice abnormal behavior of the system after changing the ASPM mode of a device, please restore the original ASPM mode and reboot the system.

