# Adding a Windows entry to the OpenCore boot menu

This guide is for adding an entry for booting Windows to the OpenCore boot menu, so you don't have to use `0` as `ScanPolicy`. Instead, you can use `2687747` for example (or [**generate your own**](https://oc-scanpolicy.vercel.app/)), which excludes a lot of file systems and interfaces from scanning.

## Prerequisites

In order to add the Windows Boot Manager to OpenCore's boot menu, we need to find the location of the EFI Partition with the "Microsoft" folder that contains the Windows Bootloader. If you only use one HDD, it's located inside the same EFI folder as your OpenCore files. But on systems which have Windows on a separate disk, we need to find out its PCI path first via the Open Shell command line tool before we can add the path to the `config.plist`.

### Finding the PCI path of the Windows Bootloader using OpenShell

- Add `OpenShell.efi` to EFI/OC/Tools folder and `config.plist`.
- Reboot the system.
- From the OC boot menu, select `OpenShell.efi` (if it's configured as an `Auxiliary` tool, hit space bar to show it)
- Once Open Shell is running, we need to find the EFI partition containing the "Microsoft" folder:
	- Type `ls fs1:EFI` and hit `Enter`.
	- If it returns `ls: File not Found - 'fs1'`, continue searching.
	- Enter `ls fs2:EFI`, `ls fs3:EFI`, etc., until you find it. In my case it is located in `ls fs8:EFI`:</br>![shell](https://user-images.githubusercontent.com/76865553/161344509-3f4fe025-c9dc-4a72-acda-a577cf1ec9d4.png)
	- Enter `fsX:` (`X` = number of the EFI file system where the "Microsoft" folder is located – in my case `fs8:`).
	- Type `map > map.txt` and hit `Enter` &rarr; saves a list of the PCI devices as a text file on the selected EFI Partition of the Windows Disk.
	- Type `exit` and hit `Enter`. You will return to the boot picker.
- Boot back into macOS.

## Adding the PCI path to the Windows Boot Manager

Once you're back in macOS, do the following:

- Mount the EFI Partition of the Windows Disk.
- Copy the `map.txt` file located in the root folder of the EFI partition to your Desktop.
- Unmount the EFI partition
- Mount your regular EFI partition which has includes your OpenCore files.
- Open the `config.plist` with OCAT or a Plist Editor.
- Go to `Misc\Entries` and create a new entry:</br>![Entry](https://user-images.githubusercontent.com/76865553/148824089-a50c2167-3396-4e25-85f7-e2d49389bab2.png)
- Now, open the `map.txt` file and search for `fsX` (X = number of `fs` which contains the Microsoft Bootloader found using Open Shell; in my case `fs8`):</br>![PCIpth](https://user-images.githubusercontent.com/76865553/148824135-43e63b09-905f-46df-8e85-6fa8707580ce.png)
- Copy the PCI Path and paste to a text editor because we need to modify it.
- Append the following line to the PCI path: `/\EFI\Microsoft\Boot\bootmgfw.efi`
- The final path should have this form: `YOUR_PciRoot_Path/\EFI\Microsoft\Boot\bootmgfw.efi`
- Back in OCAT, copy the whole path into the `Path` field. The complete entry should look something like this:</br>![Entry](https://user-images.githubusercontent.com/76865553/161345017-a7643182-7899-4538-9c85-183da6a59d41.png)
- Change the `ScanPolicy` to your liking. I use `2687747`.
- Save your config and reboot. The Windows Entry should now be present in the OC boot menu:</br>
![win10flav](https://user-images.githubusercontent.com/76865553/148958994-60379e98-4b84-4e4b-b0d0-e2484813d06b.png)

> [!IMPORTANT]
> 
> - Remember that the PCI root path to the Microsoft Boot Manager may change if you format the HDD containing the Windows installation!
> - Revert `ScanPolicy` to `0` if other drives are missing from the Boot Picker GUI.
> - If macOS partitions are not shown in the Boot Picker GUI, change `MinDate` and `MinVersion` to `-1` for macOS versions older than macOS 11.

## Notes for using QWERTZ keyboard layouts with "umlauts"
If you run shell on a (german) "QWERTZ" keyboard, some keys are different:

US Layout | DE Layout
:--------:|:---------:
`:`       | `SHIFT+Ö`
`>`       | `SHIFT+.`
`\`       | `#`
`-`       | `ß`
`y`       | `z`

## Further Resources
- [OpenCore UEFI Shell for Hackintosh troubleshooting - a beginners guide](https://www.reddit.com/r/hackintosh/comments/sy2170/opencore_uefi_shell_for_hackintosh/)

