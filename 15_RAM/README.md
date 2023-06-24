# Fixing falsely reported RAM speed in macOS

## About
I recently acquired a Lenovo T490 Laptop. While checking the installed RAM, I noticed in System Profiler the the reported RAM speed was 2400 mHz:

![](/Users/stunner/Desktop/2400.png)

But in Windows it was reported correctly, running @2666 mHz:

![](/Users/stunner/Desktop/MemSpeed.png)

Since in Wintel systems RAM speed is are handle by the BIOS, I assume there's a memory speed reporting issue in macOS.

## Fix
In order to fix the falsely reported memory speed in macOS, yo *can* do the following. I say *can* because this fix a purely cosmetic:

## Gathering RAM data

1. Run Windows, open a command prompt and enter:
	
	```bash
	wmic memorychip list full
	```
2. This should result in something like this:

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

## Transfer the data 

1. Reboot into macOS
2. Run OpenCore Auxiliary Tools, mount the EFI and open your `config.plist`
3. Navigate to `PlatformInfo/Memory`
4. Enable `CustomMemory`
5. :warning: Mandatory: consult OC's "Documentation.pdf", chapter 10.4: "Memory Properties" for details about all the used parameters before entering the data
7. Enter the relevant data you gathered earlier and ensure it follows OpenCore's standards: ![](/Users/stunner/Desktop/CstmMem.png)
8. Save your config and reboot.

## Verify the data
- Run System Profiler
- Check "Memory" Section: <br>![](/Users/stunner/Desktop/2667.png)
- Done
