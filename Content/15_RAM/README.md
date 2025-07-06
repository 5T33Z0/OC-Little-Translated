# Fixing falsely reported RAM speed in macOS

**INDEX**

- [About](#about)
- [Fix](#fix)
- [Gathering RAM data](#gathering-ram-data)
	- [Using Windows](#using-windows)
	- [Using Linux (recommended)](#using-linux-recommended)
- [Add the memory data to your config.plist](#add-the-memory-data-to-your-configplist)
- [Verify](#verify)
- [Further Resources](#further-resources)

---

## About
I recently acquired a Lenovo T490 Laptop. While checking the installed RAM, I noticed in System Profiler that the reported RAM speed was 2400 MHz:

![2400](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/e068bb0e-d9e7-4e0f-a591-50a6ba992ac4)

But in Windows it was reported correctly, running @2666 MHz:

![MemSpeed](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/41e21b50-d19c-4ac8-9c2e-5fbd615cfe01)

Since in Wintel systems RAM speed is are handle by the BIOS/UEFI Firmware, I assume there's a memory speed reporting issue in macOS.

## Fix
In order to fix the falsely reported memory speed in macOS, you *can* do the following. I say *can* because this fix is purely cosmetic:

## Gathering RAM data

### Using Windows
1. Run Windows, open a command prompt and enter:
	
	```bash
	wmic memorychip list full
	```
2. The output shoul look like this:
	```
	BankLabel=BANK 0
	Capacity=8589934592
	DataWidth=64
	Description=Physical Memory
	DeviceLocator=ChannelA-DIMM0
	FormFactor=12
	HotSwappable=
	InstallDate=
	InterleaveDataDepth=
	InterleavePosition=
	Manufacturer=Samsung
	MemoryType=0
	Model=
	Name=Physical Memory
	OtherIdentifyingInfo=
	PartNumber=M471A1K43BB1-CTD
	PositionInRow=
	PoweredOn=
	Removable=
	Replaceable=
	SerialNumber=00000000
	SKU=
	Speed=2667
	Status=
	Tag=Physical Memory 0
	TotalWidth=64
	TypeDetail=128
	Version=

	BankLabel=BANK 2
	Capacity=8589934592
	DataWidth=64
	Description=Physical Memory
	DeviceLocator=ChannelB-DIMM0
	FormFactor=12
	HotSwappable=
	InstallDate=
	InterleaveDataDepth=
	InterleavePosition=
	Manufacturer=Samsung
	MemoryType=0
	Model=
	Name=Physical Memory
	OtherIdentifyingInfo=
	PartNumber=M471A1K43CB1-CTD
	PositionInRow=
	PoweredOn=
	Removable=
	Replaceable=
	SerialNumber=397269CB
	SKU=
	Speed=2667
	Status=
	Tag=Physical Memory 1
	TotalWidth=64
	TypeDetail=128
	Version=
	```
3. Save the data as a .txt file so you can access it later from within macOS

### Using Linux (recommended)
Using Linux is recommended because the command used under Windows doesn't show the `AssetTag`. Listed below are the instructions to run a live version of Linux from a USB flash drive directly from an .iso, without needing to install Linux.

1. Prepare a USB Flash Drive with [**Ventoy**](https://github.com/ventoy/Ventoy)
2. Download an .iso of a Linux distribution of your choice (for example Ubuntu or Zorin, etc.)
3. Copy the .iso to your Ventoy USB stick
4. Reboot from USB flash drive
5. In the Ventoy menu, select your Linux distro and click on "Normal Boot"
6. Select the "Try" option instead of the "Install" option 
7. Once you've reached the Desktop, run Terminal and enter:
	```bash
	sudo dmidecode -t memory
	```
8. The output should look like this:
	```
	dmidecode 3.2
	Getting SMBIOS data from sysfs.
	SMBIOS 3.1.1 present.

	Handle 0x0002, DMI type 16, 23 bytes
	Physical Memory Array
		Location: System Board Or Motherboard
		Use: System Memory
		Error Correction Type: None
		Maximum Capacity: 16 GB
		Error Information Handle: Not Provided
		Number Of Devices: 2

	Handle 0x0003, DMI type 17, 40 bytes
	Memory Device
		Array Handle: 0x0002
		Error Information Handle: Not Provided
		Total Width: 64 bits
		Data Width: 64 bits
		Size: 8192 MB
		Form Factor: SODIMM
		Set: None
		Locator: ChannelA-DIMM0
		Bank Locator: BANK 0
		Type: DDR4
		Type Detail: Synchronous
		Speed: 2667 MT/s
		Manufacturer: Samsung
		Serial Number: 00000000
		Asset Tag: None
		Part Number: M471A1K43BB1-CTD    
		Rank: 1
		Configured Memory Speed: 2400 MT/s
		Minimum Voltage: Unknown
		Maximum Voltage: Unknown
		Configured Voltage: 1.2 V

	Handle 0x0004, DMI type 17, 40 bytes
	Memory Device
		Array Handle: 0x0002
		Error Information Handle: Not Provided
		Total Width: 64 bits
		Data Width: 64 bits
		Size: 8192 MB
		Form Factor: SODIMM	
		Set: None
		Locator: ChannelB-DIMM0
		Bank Locator: BANK 2
		Type: DDR4
		Type Detail: Synchronous
		Speed: 2667 MT/s
		Manufacturer: Samsung
		Serial Number: 397269CB
		Asset Tag: None
		Part Number: M471A1K43CB1-CTD    
		Rank: 1
		Configured Memory Speed: 2400 MT/s
		Minimum Voltage: Unknown
		Maximum Voltage: Unknown
	```
9. Save the data as a .txt file on a USB flash drive so you can access it later from within macOS

> [!NOTE]
>
> It seems that macOS displays the "Configured Memory Speed" value instead of the "Speed" value. And since the Configured Memory Speed is 2400 MT/s in my case, that's the reason why the reported speed is lower in macOS than in Windows. But "Configured Memory Speed" actually refers to the *actual* speed the RAM is running at and not the maximum possible speed it is capable of. This can be changed in BIOS but Laptop BIOSes usually don't let you configure RAM speeds. Mhh…

## Add the memory data to your config.plist 
:warning: Read OpenCore's "Documentation.pdf", chapter 10.4: "Memory Properties" to get familiar with the available parameters *before entering any data into your config.plist!* Because some parameters use different values in OpenCore and have to be converted from hex to decimal.

1. Reboot into macOS
2. Run OpenCore Auxiliary Tools, mount the EFI and open your `config.plist`
3. Navigate to `PlatformInfo/Memory`
4. Enable `CustomMemory` (disabling it ignores the whole `Memory` section)
5. Enter the relevant data you gathered earlier and ensure it follows OpenCore's standards: ![CstmMem](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/b40dd4e2-aca6-454f-86bd-75ab8faf78c6)
6. Save your config and reboot

## Verify
- Run System Profiler
- Check "Memory" Section. The correct memory speed should be reported now: <br>![2667](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/338f44f4-f7db-4bbf-91ca-53ec9afbf187)
- Done

## Further Resources
- [New Memory Properties Section](https://www.insanelymac.com/forum/topic/345520-opencore-063-new-memory-properties-section/) by miliuco
