# Enabling 4k Output on Dell Optiplex systems

> **Models**: Dell Optiplex 3070 and 7070

If you have a 4k Display attached to your Dell Optiplex, you can use this guide to force-enable 4k resulotion by modifying UEFI parameters via a modified GRUB shell. Do this on your own risk! 

## Preparations

- :warning: Create a Backup of your currently working EFI folder and store it on a FAT32 formatted USB Flash drive!
- Dowload [modgrubshell.efi](https://github.com/datasone/grub-mod-setup_var/releases) 
- Add it to `EFI/OC/Tools`
- Add `modgrubshell.efi` to `config.plist` (UEFI/Drivers)
- Remove/Disable `stolenmem` from Framebufferpatch 
- Save and reboot

## Modifying BIOS parameters

- Back in the Boot Picker, Press <kbd>space bar</kd>
- Select modgrubshell and press <kbd>Enter</kbd>
- Enter the following commands:	
	```shell
	setup_var 0x8DC 
	```
	Check the current value – default should be `0x01` 
- Change it to `0x02`:
	```shell
	setup_var 0x8DC 0x2
	```
- Verify that the change has been applied
	```shell
	setup_var 0x8DC 
	```
	The output should be `0x02` now 
- Reboot

## Sources
- [Need help getting 4K working on Dell Optiplex 7070](https://www.insanelymac.com/forum/topic/357939-need-help-getting-4k-working-on-dell-optiplex-7070-mff-i7-8700/?do=findComment&comment=2813699)
- [4k Display on DELL_OptiPlex_3070](https://github.com/Jeffersoncharlles/DELL_OptiPlex_3070#4k-display)
- [How to use "mod GRUB Shell"?](https://www.reddit.com/r/hackintosh/comments/lz03ov/how_to_use_mod_grub_shell)
