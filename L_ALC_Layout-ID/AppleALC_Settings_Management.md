# AppleALC settings management
This is a workflow suggestion for testing differently configured AppleALC kexts without losing the settings that went into creating them. 

Let's say you have configured your Layout-ID, compiled the kext, added it to your EFI Folder and Config, rebooted and noticed that isn't working 100% yet. So you have to get back into the `PinConfig` and the `Platforms.xml` to change settings. This would make you lose the current settings.

Since you may have to perform a lot of tests when creating your own ALC Layout-ID, you will eventually lose track of all the combinations of settings you've tried already. So in order to prevent this, I've developed a workflow to revert changes at any stage.

This also takes the guesswork out of the equation when it comes to creating a Pull Request on Github to get your Layout integrated into Acidanthera's AppleALC repo.

## Backing up and restoring AppleALC settings
Build your `AppleALC.kext` in Xcode and test it. If an Input/Output which wasn't working before is now working but you lost another Input/Output in the process, you have to modify the PinConfig and/or the PathMap. But before you do, backup the files that went into building the kext:

1. In Finder, navigate to `/AppleALC/build/Release`
2. Unzip the `AppleALC-1.7.2-RELEASE.zip` 
3. Add a Number to the Folder: `AppleALC-1.7.2-RELEASE 1`
4. Copy the following files into it for backup so you can always restore the parameters that wentinto compiling this kext:
	- `PinConfigs.kext` (located in `/AppleALC/Resources`)
	- `PlatformsXX.xml` (located in `/AppleALC/Resources/ALCXXX` for your Codec)
	- `layoutXX.xml` (same location)
	- `Info.plist` (same location)
5. Modify what you need to modify in the Source Code
6. Compile the kext
7. Test it. If it's not working, repeat from Step 2 but add 1 to the "Release" folder counter.

To revert to settings of a previous build, you only have to copy the backed up files from the "Release" folder to their original locations: 

![Backup-n-Restore](https://user-images.githubusercontent.com/76865553/172054278-8b98ab30-97a6-4a64-b705-d560b11f13c0.png)

