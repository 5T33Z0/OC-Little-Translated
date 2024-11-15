# Configuring Active State Power Management (ASPM)

## About ASPM

**Active State Power Management** (ASPM) is a power management technique that allows a computer to reduce the power consumption of its hardware components when they are not in use. It is used to extend the battery life of portable devices and to reduce power consumption in desktop and server systems.

ASPM works by putting certain hardware components into a low-power state when they are not being used, and then waking them up when they are needed. This allows the system to reduce its overall power consumption while still maintaining the necessary performance and functionality.

ASPM is typically implemented at the hardware level and is controlled by the system BIOS or operating system. It is supported by a number of hardware components, including the PCI Express (PCIe) bus, the system memory, and the processor.

ASPM is an important part of power management in modern computers and is used to reduce energy consumption and improve system efficiency. It is often used in conjunction with other power management techniques, such as CPU idle states and power-saving modes, to further reduce power consumption.

### ASPM States

ASPM supports a number of different power states, depending on the specific hardware components and system configurations. Some common ASPM power states include:  

- **`L0`** = Active state: All PCIe transactions and operations are enabled.
- **`L0s`** = Standby mode. L0s mode enables fast entry and exit from the idle state, and after entering the idle state, the device is placed at a lower power consumption. 
- **`L1`**: This is a low-power state in which the hardware component is partially powered down. It may have reduced clock frequencies or may be placed in a sleep state, but it is still able to respond to requests and perform basic functions. However, the time to enter and exit this state takes longer than in L0s.
- **`L2`**: This is a deeper low-power state in which the hardware component is almost completely powered down. It may take longer to wake up from this state, but it consumes significantly less power.
- **`L3`**: This is the deepest low-power state, in which the hardware component is powered off and is not able to perform any functions.

Changing the ASPM operatio modes of PCI devices can resolve issues with third-party devices not being detected during boot. For example, Realtek's RTS525A SD Card Reader is only detected after changing its default state from `L0s` to `L1`.

To check the default ASPM values of PCI devices, you can use the following GREP command (≤ macOS Sonoma):

```terminal
ioreg -l -p IODeviceTree | grep pci-aspm-default
```

### AOAC Devices and ASPM

For machines using Always-On Always-Connected technology [(**AOAC**)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Fixing_AOAC_Machines), try changing the ASPM modes of PCI devices such as Wireless cards, SSDs, etc. to reduce overall power consumption.

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
	device_type|String| Non-Volatile memory controller (for NVME disks, optional) or <br> SATA Controller (for SATA SSDs, optional)
	model|String|Name of the Drive (optional key)
- Save the config, reboot
- In hackintool, check the if the ASPM state for the NVMe Disk has changed.

>[!NOTE]
> If you are uncertain which ASPM states are supported by your NVMe Disk, you could use Acidanthera's [NVMeFix kext](https://github.com/acidanthera/NVMeFix) instead, which provides "Autonomous Power State Transition to reduce idle power consumption of the controller".

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

> [!IMPORTANT]
> If you notice an unusual behavior of the system after changing the ASPM mode of a device, please restore the original ASPM mode and reboot the system.

