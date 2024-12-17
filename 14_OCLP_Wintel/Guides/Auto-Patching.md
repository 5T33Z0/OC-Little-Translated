# Applying root patches during macOS install automatically 

## About

Did you ever wonder what the `AutoPkgInstaller.kext` and the `AutoPkg-Asstets.pkg` which can be found on the OpenCore Legacy Patcher repository are actually for?

> `AutoPkg-Assets.pkg` is a support package used by the autopatcher during OS installation. It is automatically added to any USB installer created by OCLP and is run using an *undocumented* macOS post-installation administration feature.
> 
> – [**Jazzny**](https://forums.macrumors.com/threads/macos-12-monterey-on-unsupported-macs-thread.2299557/page-283?post=31315624#post-31315624)

If you add `AutoPkgInstaller.kext` to your OpenCore EFI folder and the `.pkg` file to the macOS Installer in a specific location, root patches will be applied to your system during macOS installation *automatically*! The OpenCore-Patcher app will be installed automatically as well.

You still to have to prepare your EFI folder and config as described in my guides in order to run macOS 13 and newer, but if they are configured correctly, you don't have to run OCLP in Post-Install.

> [!CAUTION]
> 
> `AutoPkg-Asstets.pkg` is not designed to be run by users. Running it manually may result in bricked installations!

## Instructions
If you create a macOS USB installer with OpenCore Legacy Patcher,  `AutoPkg-Assets.pkg` will be added to the USB installer automatically, so you only have to make sure that `AutoPkgInstaller.kext` is present in your OpenCore EFI and `config.plist` in order to enable auto root-patching.

But if you just use OCLP to download the latest macOS Installer app and want to run it from within macOS to install a newer version of macOS on a separate volume or upgrade your existing install, you need to add `AutoPkg-Asstets.pkg` to the installer manually first:

1. [Prepare](https://github.com/5T33Z0/OC-Little-Translated/tree/main/14_OCLP_Wintel#configuration-guides) your OpenCore `config.plist` and `EFI` folder for installing macOS 13 and newer based on the configuration guide for your CPU family.
2. Add [`AutoPkgInstaller.kext`](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) to your EFI folder and `config.plist` if it is not present already.
3. Download the latest [AutoPkg-Assets.pkg](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) file from the OCLP repo.
4. Download macOS with OCLP:
   - Run OCLP
   - Click on "Create macOS Installer"
   - Click on "Download macOS Installer" 
   - Select the macOS Installer you want and click on "Download"
5. Once the download is completed the macOS Installer app will be located in "Programs"
6. Right-click the macOS Installer app and select "Show Package "
7. Show hidden files by pressing <kbd>CMD</kbd>+<kbd>Shift</kbd>+<kbd>.</kbd>
8. Navigate to `Library` 
9. Create a new folder and name it `Packages`
10. Copy the `AutoPkg-Asstets.pkg` into the `Packages` folder:<br>![pkg](https://github.com/user-attachments/assets/fa8ceb1d-2faa-42cb-9695-c2b23314fde0)
11. Install macOS

Once the installation reaches the first time set-up stage, iGPU/GPU acceleration, external displays, Wi-Fi, Bluetooth will work already.

## Credits

- [HorizontalUnix](https://github.com/HorizonUnix/PatchSonomaWiFiOnTheFly) for explaining where the `AutoPkg-Asstets.pkg` has to be placed!
