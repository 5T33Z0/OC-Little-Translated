# Dos and Don'ts of running beta versions of macOS

1. Backup your EFI folder on a FAT32 (MBR) formatted USB flash drive for recovery
2. Use the latest kexts and OpenCore files before installing a public/developer build of macOS! By "latest" I mean the [latest commits](https://dortania.github.io/builds/?product=OpenCorePkg&viewall=true) of OpenCore and Kexts – not the tagged, monthly builds from the "Releases" section since they won't contain the latest adjustments required to run the new OS!
3. Test booting with the updated EFI folder before installing the new OS
4. Don't install a beta or developer build of a new macOS version via System Update over your existing installation! Instead, download an image of the OS, create a new APFS Volume to install it on! This way, you seperate both OSes and can use the current one for daily use and the one currently in development for testing.
5. Make use of boot-args like `-lilubeta` or `-lilubetaall` to force-looad kexts in newer versions of macOS. This is necessary for kexts to load which haven't been updated yet. See, kexts contain an entry in their .plists which about the supported macOS version. using `-lilubetaall` will override this limitation. 
6. Ensure that you have the latest night build of OpenCore Patcher for applying root patches installed.
7. Last but not least: follow and read the "Issues" section on the OCLP repo carefuly. Especially the entries titled "macOS XYZ OpenCore Legacy Patcher Support". If the devs say, the patcher is not ready for use with macOS XYZ yet, then don't try installing macOS XYZ on your unsupported system. Period!
