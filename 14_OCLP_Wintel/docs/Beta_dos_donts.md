# Dos and Don'ts of running beta versions of macOS

## Backup!
Backup your EFI folder on a FAT32 (MBR) formatted USB flash drive for recovery

## Go nightly!
Use the latest kexts and OpenCore files before installing a public/developer build of macOS! By "latest" I mean the [latest commits](https://dortania.github.io/builds/?product=OpenCorePkg&viewall=true) of OpenCore and Kexts – not the tagged, monthly builds from the "Releases" section since they won't contain the latest adjustments required to run the new OS!

## Test!
Test booting with the updated EFI folder from a USB stick before installing the new OS

## Separate macOS installs!
Don't install a beta or developer build of a new macOS version via System Update over your existing installation! Instead, download an image of the OS, create a new APFS Volume to install it on! This way, you separate both OSes and can use the current one for daily use and the one currently in development for testing.

## Use boot-args!
Make use of boot-args like `-lilubeta` or `-lilubetaall` to force-load kexts in newer versions of macOS. This is necessary for kexts to load which haven't been updated yet. See, kexts contain an entry in their .plists which about the supported macOS version. using `-lilubetaall` will override this limitation. 

## Stay informed!
Follow and read the [**Issues**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues) section on the OCLP repo carefully. Especially the entries titled "macOS XYZ OpenCore Legacy Patcher Support". If the devs say, the patcher is not ready for use with macOS XYZ yet, then don't try installing macOS XYZ on your unsupported system!

## Disable downloading macOS updates in the Background
If your system is not registered for receiving beta updates (public/development), ***disable*** the following option under General &rarr; Software Update &rarr; Automatic Updates:

![updates](https://github.com/user-attachments/assets/545f2ad9-bbc8-42f0-9ec6-ad9e5c99c8d6)

**Why?**

Because it will download the newest OS in the background and prepare it for installation. This will upgrade you to the newest OS and then you could be stuck. Even if you don't install the update it will change the version info in the `SystemVersion.plist`. This happened to me and I could no longer apply root patches to the Sonoma install:

![oclplog](https://github.com/user-attachments/assets/a27acd40-9c0c-48b9-b765-ca11972d66f2)

In my case, macOS Sequoia was installed on a separate volume. After applying root patches via OCLP, I rebooted into macOS Sonoma and noticed that the iGPU acceleration was no longer working properly: although the external display was working, there was no transparency and the system felt sluggish. Somehow patching macOS Sequoia had an affect on my macOS Sonoma install. So I tried to reinstall the root patches again. But since the downloaded Sequoia update was still present sometwhere on the Sonoma disk, I could no longer patch the system. So I basicayll had to re-install Sonoma

**Best Practice**

My suggestion would be to register your system for beta updates and enable them. Because then you can decide which update to download and which not.
