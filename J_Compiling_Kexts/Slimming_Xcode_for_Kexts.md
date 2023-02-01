# Slimming Xcode for compiling Kexts

If you install Xcode on a Hackintosh it's usually for compiling kexts. Unfortunately the Xcode app is pretty hefty in terms of size – about 30 GB. That's because it contains code for building Apps for the whole line-up of Apple platforms: AppleTV OS, iPhone OS, WatchOS and macOS, of course. But since we you only need the macOS part for compiling Kexts, you can delete the rest and then you are left with about 5 GB. Needless to say you shouldn't delete platforms you are a actually developing for…

## Instructions

1. Quit Xcode if it is running 
2. Right-click on the Xcode app and select "Show Package Contents"
3. Navigate to Contents/Developer/Platforms: </br>![](/Users/5t33z0/Desktop/xcode_dev.png)
4. Delete the following folders:
	- AppleTVOS.platform
	- AppleTVSimulator.platform
	- iPhoneOS.platform
	- iPhoneSimulator.platform
	- WatchOS.platform.platform
	- WatchSimulator.platform
5. Empty the trash bin

Once I removed the unnecessary platforms the Xcode.app was only about 5 GB:</br>![](/Users/5t33z0/Desktop/Grandperspective.png)


