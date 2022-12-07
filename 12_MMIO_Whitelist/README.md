# How to populate the MMIO Whitelist

MMIO stands for Memory-Mapped I/O is a method of to perform I/O processes between the CPU and peripheral devices of a computer. The memory and registers of the I/O devices are mapped to (associated with) address values. 

On some systems (like AMD Threadripper and Intel Ice Lake), these MMIO areas need to be whitelisted in OpenCore's `config.plist` in order to boot successfully. There's also a Booter Quirk called `DevirtualszeMmmio` associated with it which can be used to find the the MMIO regions which need to be whitelisted.

This guide assists you in finding these specifi MMIO regions and adding then to the MMIO Whitelist.

## Instructions

### 1. Generating a bootlog
- Backup your current EFI Folder on a FAT32 formatted USB flash drive!
- Switch OpenCore from the RELEASE to the DEBUG version using OCAT:
	- Mount your EFI and open your `config.plist`
	- In OCAT, select "Edit > OpenCore DEBUG" from the menu bar
	- Update OpenCore files and Drivers
- In `config.plist`, change the following:
	- Enable `DevirtualiseMmio` (in `Booter/Quirks`)
	- `Misc/Debug/Target` to: `67`
-  Save and reboot

The Bootlog will be stored in the `EFI` folder as a .txt file (even if boot fails)

### 2. Analyzing the bootlog
- Mount the EFI 
- Open the `OpenCore-xxxx-xx-xx.txt` file
- Press <kbd>CMD</kbd> + <kbd>F</kbd> to open the Find dialog
- Search for "**MMIO devirt**" or just "**devirt**"
- You might get something like this: </br>
	`MMIO devirt 0xF80F8000 (0x1 pages, 0x8000000000000001) skip 0` </br>
	`MMIO devirt 0xFED1C000 (0x4 pages, 0x8000000000000001) skip 0`

### 3. Converting Hex to Decimal
In order to add the found addresses (here: `0xF80F8000` and `0xFED1C000`) to the MMIO Whitelist, we need to convert them to decimal:

- Convert all the hex values of "MMIO Devirt" matches which are not skipped (`skip 0`). You can use Hackintool for this.
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
- As you can see, these 2 MMIO regions are now skipped which means, that they are now available to the UEFI again.

### 5. Finishing touches
Once you are done with creating the MMIO Whitelist and testing, do the following:

- Disable logging (change `Misc/Debug/Target` to `3`)
- Switch OpenCore back to the Release version:
	- Mount your EFI and open your `config.plist`
	- In OCAT, select "Edit > OpenCore DEBUG" again, to uncheck it
	- Update OpenCore files and Drivers
- Save and reboot

## Resources
- [**Using `DevirtuliseMmio`**](https://caizhiyuan.gitee.io/opencore-install-guide/extras/kaslr-fix.html#using-devirtualisemmio)
- [**DevirtualiseMmio and MMIO Whitelist**](https://www.macos86.it/topic/5511-let-talk-aboutdevirtualise-mmio-quirk-and-mmio-whitelist/)
