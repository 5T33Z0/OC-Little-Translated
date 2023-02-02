# Slimming Xcode for compiling Kexts

If you install Xcode on a Hackintosh it's usually for compiling Kexts. Unfortunately, the Xcode app is pretty hefty in terms of size – about 30 GB. That's because it contains code for building Apps for the whole line-up of Apple devices: AppleTV OS, iPhone OS, WatchOS and macOS, of course. Since you only need the macOS part for compiling Kexts, you can delete the rest and then you are left with about 5 GB. Needless to say you shouldn't delete platforms you are a actually developing for…

## Instructions

1. Quit Xcode if it is running 
2. Right-click on the Xcode app and select "Show Package Contents"
3. Navigate to Contents/Developer/Platforms:</br>![xcode_dev](https://user-images.githubusercontent.com/76865553/216172977-6bb0b379-1254-40ce-80f9-76e42d10522e.png)
4. Delete the following folders:
	- AppleTVOS.platform
	- AppleTVSimulator.platform
	- iPhoneOS.platform
	- iPhoneSimulator.platform
	- WatchOS.platform.platform
	- WatchSimulator.platform
5. Empty the trash bin

Once I removed the unnecessary platforms the Xcode.app was only about 5 GB.

**Before**:</br>![before](https://user-images.githubusercontent.com/76865553/216173933-43d9bf47-2238-4218-8261-9de8bc6ad8d6.png)

**After**:</br>![after](https://user-images.githubusercontent.com/76865553/216174032-5dad4393-bffe-4df3-80d9-e29102d34640.png)
