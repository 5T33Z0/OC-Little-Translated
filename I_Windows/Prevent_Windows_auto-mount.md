# Preventing a Volume from mounting at startup
You can use this to prevent Windows (or other) Volumes from auto-mounting under macOS.

1. Ensure that the disk you want to prevent from mounting at boot is currently mounted
2. Launch Hackintool
3. Click on the "Disks" Tab
4. Find the Windows Volume you want to prevent from mounting
5. Right-click its entry and select "Copy to Clipboard" > "Volume UUID"
6. Next, run Terminal
7. Enter `cd /etc`
8. Create/edit an `fstab` file. Enter: `sudo vifs`
9. Press `o` to edit the file 
10. Enter the following line:
	- For "blocking" an **NTFS** Volume (Windows): `UUID=PASTE YOUR UUID none ntfs rw,noauto`
	- For "blocking" an **APFS** Volume (macOS): `UUID=PASTE YOUR UUID none apfs rw,noauto`
	- For "blocking" an **HFS** Volume (macOS): `UUID=PASTE YOUR UUID none hfs rw,noauto`
11. Press `Esc` to finish editing.
12. Hold `Shift` and enter `ZZ` to save and exit vifs.
13. Enter to reset the auto mounter: `sudo automount -vc`
14. Quit Terminal and reboot to test it.

## Notes and Credits
- To revert the changes, delete the `fstab` file located under `/private/etc/` and reset the auto mounter. Since this directory is hidden, you need to press `Shift` and `.` (dot/full stop) in Finder to reveal it or use the "Go to" menu instead.
- You can also edit the file in Visual Studio Code if it exists already
- Original Guide: https://discussions.apple.com/docs/DOC-7942
