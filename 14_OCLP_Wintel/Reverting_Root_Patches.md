# Recovering from failed root patching attemps

## About
Whenever a new macOS Update is released, there’s a chance that Apple removed something else from the OS so that the root patches might fail or break something in macOS so that it becomes unusable,

This happened with the release of macOS 14.2 beta 3, where you could no longer log into macOS on Ivy Bridge systems after applying root patches with OCLP 1.2.1 to re-enable Intel HD 4000 graphics because it caused the Windowserver to crash. Luckily, the issue was resolved in OCLP 1.3.0 but it can happen again any time a new macOS update is released.

Listed below, you find some options to recover from failed root patching attemps. They are sorted from easiest (option 1) to most difficult (option 3).

## Preperations
Prior to reverting root patches, do the following if your system requires root patches in order to access the internet:
- Check if a newer version of [OCLP](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) is available and download it 
- If the macOS update is newer than the latest official OCLP release, check if newer commits to the source code exist and [download the latest nightly build](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/SOURCE.md) instead. The version number should be higher than the one of the official release.
- Download the latest [KernelDebugKit](https://github.com/dortania/KdkSupportPkg/releases) (KDK). Click on "Assets" and download the .dmg file.

> [!NOTE]
>
> If OCLP is installed already and can access the intenet, it automatically detects when a macOS update is being downloaded. It then notifies you that it needs to installs the latest KDK in order to perform the update (if it isn't installed already). Just click "Ok" and OCLP will take care of it.

## Option 1: Reverting Root Patches if macOS still can be used
If you can still boot into macOS and use it, do the following to revert Root Patches.

1. Run the OpenCore Patcher again
2. Click on “Post-Install Root Patch”
3. Next, click on the button “Revert Root Patches”
4. This will restore the previous unpatched snapshot
5. Reboot afterwards

Once everything is back to normal, check if a newer version of OCLP is available and apply root patches again.

## Option 2: Reverting Root Patches in Safe Mode
If you’ve applied root patches that leave macOS in an unusable, e.g. after installng iGPU/GPU drivers, recovering from this might be possible by running macOS in Safe Mode without hardware acceleration for graphics. Because in Safe Mode graphics drivers are not loaded so it might still be possible to get into macOS and revert root patches.

1. In OpenCore’s boot menu, select macOS
2. Hold <kbd>Shift</kbd> and press <kbd>Enter</kbd> to boot macOS in Safe Mode which takes significantly longer than a normal boot
3. Click on “Post-Install Root Patch”
4. Next, click on the button “Revert Root Patches”
5. This will restore the previous unpatched snapshot
6. Reboot afterwards

Once everything is back to normal, check if a newer version of OCLP is available and apply root patches again.

## Option 3: Reverting Root Patches via macOS Recovery and Terminal
This option is the last resort, if macOS won’t boot normally nor in safe mode. The idea is to boot into Recovery and use Terminal to restore the last working macOS Snapshot.

1. In OpenCore’s boot menu, press <kbd>Spacebar</kbd> to show hidden entries
2. Select the Recovery partition of the affected macOS version
3. Press <kbd>Enter</kbd> to boot into Recovery
4. Once you reach the recovery menu, select **Disk Utility**
5. Change “View” to “Show all Volumes” (or similar, depending on your language settings)
6. From the menu on the left, select the “Volumes of XYZ” entry (XYZ = NAME of the VOLUME that contains the broken macOS install). For example “Volumes of Sonoma”, if you named your Volume “Sonoma”.
7. Next, click on “Info” (or press <kbd>CMD</kbd> and <kbd>Enter</kbd>). This opens the Info dialog for the disk/volum.
8. Look for the entry “Mount Point”. It should be someting like “/Volume/XYZ”
9. Take note of that path and close Disk Utility
10. Back in the recovery menu, select “Utilities > Terminal” from the menu bar
11. Enter the following Commands one by one (replace "XYZ" by the name of your volume!): 
    ```
    mount -uw "/Volumes/XYZ”
    bless --mount "/Volumes/XYZ" -bootefi --last-sealed-snapshot
    ```
12. Close Terminal
13. Restart the system from the Apple Menu
14. Reboot macOS without Root Patches!
15. Click “Cancel” once OCLP asks you to re-apply root patches again!
16. Instead, check if a newer version of OCLP is available, download it and apply root patches again.

> [!IMPORTANT]
>
> If you don't have internet access, root patching might fail due to missing Kernel Debug Kit (KDK). In this case, install the KDK and run OCLP again!

> [!TIP]
>
> - If your system can connect to the internet via Ethernet cable without root patches you can use Safari in Recovery as well to follow the instructions.
> - There’s also a very helpful [YouTube video](https://youtu.be/mNcjmvzS0Vo?si=OtNeB4r1q3s3sW9T) that explains all the steps in detail.
