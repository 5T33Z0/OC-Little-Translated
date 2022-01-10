# Adding Windows entry to OpenCore Bootmenu

## About
This guide is for adding a Windows boot menu entry so you don't have to use `0` as `ScanPolicy`. Instead, you can use `2687747` for example, which excludes a lot of unnecessary file systems and interfaces from scanning:

![scanpol](https://user-images.githubusercontent.com/76865553/148823944-b4573389-520f-4816-a639-dc8a9a4ce962.png)

**Source**: https://oc-scanpolicy.vercel.app/

## Prerequisites
In order to add the Microsoft Bootloader to OpenCore's boot menu, we need to find the location of the ESP and EFI Folder that contains the Microsoft Bootmanager (inside the "Microsoft" folder). If you only use one HDD, it's located inside the same EFI folder your OpenCore files. But om systems which have Windows on a separte disk, we need to find out its PCI path first via Open Sheel. 

### Finding the PCI path of the Windows Bootloader
1. Add `OpenShell.efi` to EFI/OC/Tools folder and `config.plist`.
2. Reboot the system
3. In OC Menu, run `OpenSheel.efi`: </br>![01](https://user-images.githubusercontent.com/76865553/148824001-ba1d1cc2-3f10-4fdb-b9eb-53240c1abec5.png)
4. Once OpenShell is up, we need to find the EFI folder containing a "Microsoft" folder. </br>Enter `ls fs1:EFI`
5. If it returns `ls: File not Found - 'fs1'`, we continue searching
6. Enter `ls fs2:EFI`, `ls fs3:EFI`, etc., until you find it.
7. In my case it was found when looking for `ls fs8:EFI`:</br>![found](https://user-images.githubusercontent.com/76865553/148824053-5987d044-1081-46f9-bc46-77efaf55bd00.png)
8. Type `fs8` and hit `Enter` to select the filesystem
9. Next, type `map > map.txt `and hit `Enter` &rarr; This saves a list of the PCI devices as a .txt file on the selected EFI Partition (of the Windows Disk, in this case)
10. Type Exit.
11. Boot back into macOS

## Adding the PCI path to the Windows bootloader
Once you return back to macOS, do the following:

1. Mount the EFI Partion of the Windows Disk
2. Copy the `map.txt` file included in the root folder of the EFI partition to your Desktop
3. Unmount the EFI partition
4. Mount your regular EFI partition which holds your OC EFI
5. Open your `config.plist` with OCAT or a Plist Editor.
6. Go to Misc > Entries
7. Create a new entry:</br>![Entry](https://user-images.githubusercontent.com/76865553/148824089-a50c2167-3396-4e25-85f7-e2d49389bab2.png)
8. Now, open the `map.txt` file and search for `fsX` (X = number of `fs` which contains the Microsoft Bootloader found using OpenShell; in my case `fs8`):</br>![PCIpth](https://user-images.githubusercontent.com/76865553/148824135-43e63b09-905f-46df-8e85-6fa8707580ce.png)
9. Copy the PCI Path. In this example and paste to a text editor: `PciRoot(0x0)/Pci(0x17,0x0)/Sata(0x2,0xFFFF,0x0)/HD(1,GPT,2B711BAD-3092-49DB-871F-5D4C8EA06A66,0x800,0x32000)`
10. Append the following to this path: `/\EFI\Microsoft\Boot\bootmgfw.efi`
11. So the final path has this form: `YOUR_PciRoot_Path/\EFI\Microsoft\Boot\bootmgfw.efi`
12. Back in OCAT, copy the whole path into the `Path` field. In my case: `PciRoot(0x0)/Pci(0x17,0x0)/Sata(0x2,0xFFFF,0x0)/HD(1,GPT,2B711BAD-3092-49DB-871F-5D4C8EA06A66,0x800,0x32000)/\EFI\Microsoft\Boot\bootmgfw.efi`.
13. Change the ScanPolicy to your liking.
14. Save your config and reboot.

The Windows Entry should now be present in the OC boot menu:
![win10](https://user-images.githubusercontent.com/76865553/148824219-1388998c-17e7-43cc-9749-146a26a48769.png)
