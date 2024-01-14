# Workaround for installing OTA System Updates on disk volumes with broken seals

## Cause
If you apply root patches to macOS with OpenCore Legacy Patcher (or other tools that install files on the system volume), this breaks the security seal of the volume.

You can check the status of the seal by entering the following command in Terminal:

```shell
diskutil apfs list
```
Here's the output of the APFS volume in my iMac that I applied root patches to with OCLP:

```
 +-> Volume disk1s6
        ---------------------------------------------------
        APFS Volume Disk (Role):   disk1s6 (System)
        Name:                      Big Sur (Case-insensitive)
        Mount Point:               Not Mounted
        Capacity Consumed:         15152431104 B (15.2 GB)
        Sealed:                    Broken
        FileVault:                 No
        |
        Snapshot:                  -----------------
        Snapshot Disk:             disk1s6s1
        Snapshot Mount Point:      /
        Snapshot Sealed:           Broken
```

As you can see, status of the `Snapshot Sealed` is `Broken`.

## Effect
Once a snapshot is broken, incremental (or delta) updates will no longer work. Instead, every time a System Update is available, the full macOS Installer is downloaded instead (approx. 13 GB), which takes a long time, causes a lot of traffic and requires more energy which in return is bad for the environment.

## Workaround
So to prevent that the full installer is downloaded every time, you can do the following:

- Run the OpenCore Legacy Patcher
- Click on "Post-Install Root Patch"
- Next, select `Revert Root Patches`: <br> ![revert](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/e5f9c409-7aad-4511-b1bc-e20466908913)
- Once reverting the patches is done, reboot. All the patches will be gone but the Snapshot seal will be intact again:
	```
	+-> Volume disk1s6
        	---------------------------------------------------
        	APFS Volume Disk (Role):   disk1s6 (System)
        	Name:                      Big Sur (Case-insensitive)
        	Mount Point:               Not Mounted
        	Capacity Consumed:         15152431104 B (15.2 GB)
        	Sealed:                    Broken
        	FileVault:                 No
        	|
        	Snapshot:                  -----------------
        	Snapshot Disk:             disk1s6s1
        	Snapshot Mount Point:      /
        	Snapshot Sealed:           Yes
	```
- If you check for updates now, the size of the update should be significantly smaller – usually between 1 to 2 GB.

> [!WARNING]
> 
> - This workaround only works on systems with 4th Gen Intel and newer CPUs. On Ivy Bridge and older, the update fails during the preparation phase! (&rarr; [Screenshot](https://github.com/5T33Z0/OC-Little-Translated/blob/main/S_System_Updates/Pics/SysUpd_Fail.png))
> - This workaround cannot be utilized if your system requires post-install patches for *both* Wi-Fi and Ethernet, because then you cannot access the internet to download updates!

## Notes
- Depending on the root patches your system need to be able to run macOS Ventura or newer, booting might only be possible in Safe Mode. To do so, hold <kbd>Shift</kbd> and press <kbd>Enter</kbd> in OpenCore's Boot Picker.
- To fix issues with System Update Notifications not showing at all, check [this article](https://github.com/5T33Z0/OC-Little-Translated/tree/main/S_System_Updates)

## Credits
Thanks to Cyberdevs from Insanelymac for his [explanations](https://www.insanelymac.com/forum/topic/356881-pre-release-macos-sonoma/page/61/#comment-2809998)
