# How to populate the MMIO Whitelist

- [About](#about)
- [Instructions](#instructions)
	- [1. Generating a bootlog](#1-generating-a-bootlog)
	- [2. Analyzing the bootlog](#2-analyzing-the-bootlog)
	- [3. Converting Hex to Decimal](#3-converting-hex-to-decimal)
	- [4. Populating and verifying the MMIO Whitelist](#4-populating-and-verifying-the-mmio-whitelist)
	- [5. Finishing touches](#5-finishing-touches)
- [Resources](#resources)

---

## About
MMIO stands for Memory-Mapped Input/Output. It's a method to perform I/O processes between the CPU and peripheral devices of a computer. The memory and registers of the I/O devices are mapped to (and associated with) address values. 

MMIO whitelist is a security feature that controls access to certain memory addresses in a computer system, allowing access only to specific processes or devices that have been explicitly granted permission and denying access to all others.

On some systems (like AMD Threadripper and Intel Ice Lake), these MMIO regions need to be whitelisted in OpenCore's `config.plist` in order to boot macOS successfully. There's also a Booter Quirk called `DevirtualiseMmmio` which needs to be enabled in order to find the MMIO regions which need to be whitelisted.

This guide assists you in finding the specific MMIO regions in your system and adding then to the MMIO Whitelist.

## Instructions

### 1. Generating a bootlog
Switch OpenCore from the RELEASE to the DEBUG version using OCAT:

- In OCAT, select "Edit > OpenCore DEBUG" from the menu bar (set checkmark)
- Mount your EFI and open your `config.plist`
- Backup your current EFI Folder on a FAT32 formatted USB flash drive!
- In `config.plist`, change the following:
	- Enable `DevirtualiseMmio` (in `Booter/Quirks`)
	- Set `Misc/Debug/Target` to: `67`
- Update OpenCore files and Drivers
- Save and reboot

The Bootlog will be stored in the `EFI` folder as a .txt file (even if boot fails)

### 2. Analyzing the bootlog
- Mount the EFI 
- Open the `OpenCore-xxxx-xx-xx.txt` file
- Press <kbd>CMD</kbd> + <kbd>F</kbd> to open the Find dialog
- Search for "**MMIO devirt**" or just "**devirt**"
- You might get something like this: </br>
	`MMIO devirt 0xF80F8000 (0x1 pages, 0x8000000000000001) skip 0` </br>
	`MMIO devirt 0xFED1C000 (0x4 pages, 0x8000000000000001) skip 0`

> [!NOTE]
> 
> Alternatively, you could use Corpnewt's [**MmioDevirt**](https://github.com/corpnewt/MmioDevirt) script to analyze the log and generate the MMIO Whitelist. In this case you can skip step 3 so you only have to copy the `MmioWhitelist` Array to your config.plist, save and reboot. Done.

### 3. Converting Hex to Decimal
In order to add the found addresses which are not skipped (`skip 0`) to the MMIO whitelist, we need to convert them to decimal first:

- Run Hackintool
- Click on the "Calc" Tab
- Use the "Value" section to convert the hex to decimal values.

**Examples**:

Hexadecimal | Decimal
------------|----------
0xF80F8000 | 4161765376
0xFED1C000 | 4275159040

### 4. Populating and verifying the MMIO Whitelist
- Open `config.plist`
- Add the decimal values of the address you found in the bootlog to `Booter/MmioWhitelist`, like so:</br>![MMIOWhitelist01](https://user-images.githubusercontent.com/76865553/205931912-fee2d569-3265-47fb-a493-4c9556658805.png)
- Save and reboot
- Back in macOS, check the newly created bootlog:</br>
	`MMIO devirt 0xF80F8000 (0x1 pages, 0x8000000000000001) skip 1`</br>
	`MMIO devirt 0xFED1C000 (0x4 pages, 0x8000000000000001) skip 1`
- As you can see, these 2 MMIO regions are now skipped (`skip 1`) which means, that the memory used for these regions is now available to the UEFI again.

### 5. Finishing touches
Once you are done with creating the MMIO Whitelist and testing, do the following:

- In OCAT, select "Edit > OpenCore DEBUG" again, to uncheck it
- Mount your EFI and open your `config.plist`
- Disable logging. Change `Misc/Debug/Target` to `3` (default) or `0` (Logging fully disabled)
- Update OpenCore files and Drivers to switch back to the RELEASE build
- Save and reboot

## Resources
- [**Using `DevirtuliseMmio`**](https://caizhiyuan.gitee.io/opencore-install-guide/extras/kaslr-fix.html#using-devirtualisemmio)
- [**DevirtualiseMmio and MMIO Whitelist**](https://www.macos86.it/topic/5511-let-talk-aboutdevirtualise-mmio-quirk-and-mmio-whitelist/)
