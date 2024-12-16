# Applying root patches during macOS install automatically 

## About

Did you ever wonder what the `AutoPkgInstaller.kext` and the `AutoPkg-Asstets.pkg` which can be found on the OpenCore Legacy Patcher repository are actually for?

Well, if you add the kext to your OpenCore EFI folder and add the `.pkg` file to the macOS USB Installer in a specific location, your system will get root patched during install *automatically*!

You still to have to prepare your EFI folder and config as described in my guides in order to run macOS 14 and newer, but if they are configured correctly, you don't have to run OCLP in Post-Install. And the OCLP app will get installed automatically as well.

## Instructions

1. [Prepare](https://github.com/5T33Z0/OC-Little-Translated/tree/main/14_OCLP_Wintel#configuration-guides) your OpenCore `config.plist` and `EFI` folder for installing macOS 13 and newer based on the configuration guide for your CPU family
2. Add [`AutoPkgInstaller.kext`](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) to your EFI folder and `config.plist`
3. [Create a macOS USB Installer](https://dortania.github.io/OpenCore-Legacy-Patcher/INSTALLER.html#downloading-the-installer) with OpenCore Legacy Patcher
4. Download the latest [AutoPkg-Assets.pkg](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) file from the OCLP repo.
5. Once the USB install media creation us completed, select the USB Installer ("Install macOS…") in the Finder's side bar
6. Show hidden files (CMD+Shift+.)
7. Navigate to `Library` 
8. Create a new folder and name it `Packages`
9. Add the `AutoPkg-Asstets.pkg` to it:<br>![](/Users/5t33z0/Desktop/pkg.png)
10. Install macOS from the USB flash drive

Once the installation reaches the first time set-up stage, iGPU/GPU acceleratiion, external displays, Wi-Fi, Bluetooth will work already.

## Credits

- Thanks to [HorizontalUnix](https://github.com/HorizonUnix/PatchSonomaWiFiOnTheFly) for explaining where the `AutoPkg-Asstets.pkg` has to be placed on the macOS USB Installer!