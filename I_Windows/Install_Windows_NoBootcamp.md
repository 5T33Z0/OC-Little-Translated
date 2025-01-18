# Installing Windows from within macOS without BootCamp

## About

I recently tried to install Windows 10 on my `iMac11,3` but it didn't work. According to Windows Setup, the partition I had prepared on the SSD did not use the GUID Partition Table (GPT). Trying to convert the disk to GPT via CLI didn't work. Luckily, I came a across an app called Windows Install that allows installing Windows from within macOS. It extracts the files of a Windows .ISO to a designated Windows partition and then adds the `Microsoft` bootloader folder to the EFI partition. It works on Hackintoshes as well, of course.

Once the installation is completed, you can reboot and the entry for booting Windows should be available from OpenCore's Bootpicker. I haven't tested it when using the Apple bootloader, though. I guess you just have to hold <kbd>Shift</kbd> after turning on the machine and the entry should appear.

## Instructions

### Disk Preparations

1. Run Disk Utility
2. Select "View" > "Show all Devices"
3. If you want to install Windows on the same disk, select the Container Disk of your SSD/NVMe from the side-panel 
4. Create a new FAT32 Partition. **SIZE**: At least **40 GB**. Windows 10 requires about 20 GB for the Installation + x GB RAM of installed RAM (this amount will be reserved by Windows for storing the Sleepimage) + whatever space you need for your programs. So if you have 16 Gigs of RAM that makes 36 GB – without any space left. So add at least 4 GB for apps and updates minimum. Otherwise, you have to disable hibernation and Windows recovery in order to have enough space on the disk to work with.
5. Take note of the Disk's device path (`diskXsX`)

> [!NOTE]
> 
> If you want to use a seperate physical disk for installing Windows instead you just have to format the disk as FAT32 and continue with "Install Windows"

### Windows Installation
1. Download [Windows_Install.zip](https://sourceforge.net/projects/windows-install/) from sourceforge and unpack it
2. Run the App
3. Drag your Windows Installation ISO into the app's window
4. The following Windows should be displayed:<br> ![Win10Config](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/b633cf25-ee19-4581-887c-42173a232a8f)
5. Under "index", enter the number representing the variant of Windows you want install
6. Under "Disk" and "s" enter the location your FAT32 formatted partition (double-check in Disk Utility)
7. Enter your macOS Login-Password so the installer can do its thing
8. Click on install and watch the progress.
9. Once the installation is complete the app will mount your System's EFI and add the "Microsoft" folder to it.
10. Reboot
11. Windows should now be available from the Bootpicker. If it's not, open your `config.plist`. Add `\EFI\Microsoft\Boot\bootmgfw.efi` to `Misc/BlessOverride`:<br>![Bless](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/fdb65892-ccea-4e7d-90f4-c60742a0124a)
12. Save and Reboot
13. Select Windows and the Installation starts. Once that's done, continue with Post-Install

## Post-Install (Apple Macs only)
Once Windows is up and running, we still need to install drivers for components used in Apple Macs. For Wintel machines you just get all the drivers you need via Windows update or download it from the vendor of a component directly.

1. Boot Windows
2. Download and Install [7zip](https://www.7-zip.org/)
3. Download and run [Brigardier](https://github.com/timsutton/brigadier/releases). It will fetch all the required drivers and files and will create an installer
4. Once that's done, navigate to the Downloads/Bridaier folder and run `Setup.exe` (you may neeed to run it in compatibility mode if it does not run in Windows 10+)
5. Once the drivers are installed reboot Windows 
6. Enjoy

## Resources
- Discussion on [insanelymac.com](https://www.insanelymac.com/forum/topic/348077-install-windows-on-mac-no-bootcamp/)
- Discussion on [Applelife.ru](https://applelife.ru/threads/skript-ustanovki-windows-iz-pod-macos.2942844/page-19#post-741961) (Russian)
- [Installation Video](https://www.youtube.com/watch?v=3_h9yOvrAKc) (YouTube)
