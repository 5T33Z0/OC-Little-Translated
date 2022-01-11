# Adding a Windows entry to the OpenCore boot menu
This guide is for adding an entry for booting Windows to the OpenCore boot menu, so you don't have to use `0` as `ScanPolicy`. Instead, you can use `2687747` for example, which excludes a lot of  file systems and interfaces from scanning:

![scanpol](https://user-images.githubusercontent.com/76865553/148823944-b4573389-520f-4816-a639-dc8a9a4ce962.png)
**Source**: https://oc-scanpolicy.vercel.app/

## Prerequisites
In order to add the Microsoft Bootmanager to OpenCore's boot menu, we need to find the location of the EFI Parttion containing the "Microsoft" folder. If you only use one HDD, it's located inside the same EFI folder as your OpenCore files. But on systems which have Windows on a separte disk, we need to find out its PCI path first via the Open Shell command line tool before we can add the path to the config.plist. 

### Finding the PCI path of the Windows Bootloader using OpenShell
- Add `OpenShell.efi` to EFI/OC/Tools folder and `config.plist`.
- Reboot the system.
- From the OC boot menu, select `OpenSheel.efi` (if it's configured as an `Auxiliary` tool, hit space bar to show it)
- Once OpenShell is running, we need to find the EFI partition containing the "Microsoft" folder:
	- Type `ls fs1:EFI` and hit `Enter`.
	- If it returns `ls: File not Found - 'fs1'`, continue searching.
	- Enter `ls fs2:EFI`, `ls fs3:EFI`, etc., until you find it. In my case it is located in `ls fs8:EFI`:</br>![found](https://user-images.githubusercontent.com/76865553/148824053-5987d044-1081-46f9-bc46-77efaf55bd00.png)
	- Enter `fsX:` (`X` = number of the EFI filesystem where the "Microsoft" folder is located – in my case `fs8:`).
	- Type `map > map.txt` and hit `Enter` &rarr; saves a list of the PCI devices as a text file on the selected EFI Partition of the Windows Disk.
	- Type `exit` and hit `Enter`. You will return to the bootpicker.
- Boot back into macOS.

## Adding the PCI path to the Windows Boot Manager
Once you return back to macOS, do the following:

- Mount the EFI Partion of the Windows Disk.
- Copy the `map.txt` file located in the root folder of the EFI partition to your Desktop.
- Unmount the EFI partition
- Mount your regular EFI partition which has includes your OpenCore files.
- Open the `config.plist` with OCAT or a Plist Editor.
- Go to `Misc\Entries` and create a new entry:</br>![Entry](https://user-images.githubusercontent.com/76865553/148824089-a50c2167-3396-4e25-85f7-e2d49389bab2.png)
- Now, open the `map.txt` file and search for `fsX` (X = number of `fs` which contains the Microsoft Bootloader found using OpenShell; in my case `fs8`):</br>![PCIpth](https://user-images.githubusercontent.com/76865553/148824135-43e63b09-905f-46df-8e85-6fa8707580ce.png)
- Copy the PCI Path and paste to a text editor because we need to modify it. In my case: `PciRoot(0x0)/Pci(0x17,0x0)/Sata(0x2,0xFFFF,0x0)/HD(1,GPT,2B711BAD-3092-49DB-871F-5D4C8EA06A66,0x800,0x32000)`
- Append the following line to the PCI path: `/\EFI\Microsoft\Boot\bootmgfw.efi`
- The final path has this form: `YOUR_PciRoot_Path/\EFI\Microsoft\Boot\bootmgfw.efi`
- Back in OCAT, copy the whole path into the `Path` field. In my case: `PciRoot(0x0)/Pci(0x17,0x0)/Sata(0x2,0xFFFF,0x0)/HD(1,GPT,2B711BAD-3092-49DB-871F-5D4C8EA06A66,0x800,0x32000)/\EFI\Microsoft\Boot\bootmgfw.efi`.
- Change the ScanPolicy to your liking. I use `2687747`.
- Save your config and reboot. The Windows Entry should now be present in the OC boot menu:</br>
![win10](https://user-images.githubusercontent.com/76865553/148824219-1388998c-17e7-43cc-9749-146a26a48769.png)

**Done**!

## :warning: Caution
-  Remember that the PCI root path to the Microsoft Boot Manager changes if you format the HHD containing the Windows Installation!
-  If macOS partitions are not shown in the botloader GUI, change `MinDate` and `MinVersion` to `-1` for macOS versions older than macOS 11.
-  Revert `ScanPolicy` to `0` if other drives are missing from the bootloader GUI.
