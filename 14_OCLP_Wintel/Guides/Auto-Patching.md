# Applying root patches during macOS install automatically 

:contsruction: Work in progress

## About

Did you ever wonder what the `AutoPkgInstaller.kext` and the `AutoPkg-Asstets.pkg` which can be found on the OpenCore Legacy Patcher repository are actually for?

> `AutoPkg-Assets.pkg` is a support package used by the autopatcher during OS installation. It is automatically added to any USB installer created by OCLP and is run using an *undocumented* macOS post-installation administration feature. […]
> 
> – [**Jazzny**](https://forums.macrumors.com/threads/macos-12-monterey-on-unsupported-macs-thread.2299557/page-283?post=31315624#post-31315624)

If you add the `AutoPkgInstaller.kext` to your OpenCore EFI folder and add the `.pkg` file to the macOS USB Installer in a specific location, root patches will be applied to your system during macOS installation *automatically*!

You still to have to prepare your EFI folder and config as described in my guides in order to run macOS 14 and newer, but if they are configured correctly, you don't have to run OCLP in Post-Install. And the OCLP app will get installed automatically as well.

> [!CAUTION]
> 
> `AutoPkg-Asstets.pkg` is not designed to be run by users. It is only for the autopatcher. Running it manually by the user may result in bricked installations!

## Instructions

### Option 1: Using OCLP to prepare a USB installer


### Option 2: Modifying an existing USB installer

1. [Prepare](https://github.com/5T33Z0/OC-Little-Translated/tree/main/14_OCLP_Wintel#configuration-guides) your OpenCore `config.plist` and `EFI` folder for installing macOS 13 and newer based on the configuration guide for your CPU family
2. Add [`AutoPkgInstaller.kext`](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) to your EFI folder and `config.plist`
3. [Create a macOS USB Installer](https://dortania.github.io/OpenCore-Legacy-Patcher/INSTALLER.html#downloading-the-installer) with OpenCore Legacy Patcher
4. Download the latest [AutoPkg-Assets.pkg](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) file from the OCLP repo.
5. Once the USB install media creation us completed, select the USB Installer ("Install macOS…") in the Finder's side bar
6. Show hidden files (CMD+Shift+.)
7. Navigate to `Library` 
8. Create a new folder and name it `Packages`
9. Add the `AutoPkg-Asstets.pkg` to it:<br>![pkg](https://github.com/user-attachments/assets/fa8ceb1d-2faa-42cb-9695-c2b23314fde0)
10. Install macOS from the USB flash drive

Once the installation reaches the first time set-up stage, iGPU/GPU acceleratiion, external displays, Wi-Fi, Bluetooth will work already.



## Credits

- Thanks to [HorizontalUnix](https://github.com/HorizonUnix/PatchSonomaWiFiOnTheFly) for explaining where the `AutoPkg-Asstets.pkg` has to be placed on the macOS USB Installer!
