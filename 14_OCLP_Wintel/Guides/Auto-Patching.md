# Applying root patches during macOS install automatically 

## About

Did you ever wonder what the `AutoPkgInstaller.kext` and the `AutoPkg-Assets.pkg` found in the OpenCore Legacy Patcher repository are for?

> `AutoPkg-Assets.pkg` is a support package used by the autopatcher during OS installation. It is automatically added to any USB installer created by OCLP and is run using an *undocumented* macOS post-installation administration feature.
> 
> – [**Jazzny**](https://forums.macrumors.com/threads/macos-12-monterey-on-unsupported-macs-thread.2299557/page-283?post=31315624#post-31315624)

If you add `AutoPkgInstaller.kext` to your OpenCore EFI folder and the `.pkg` file to the macOS Installer in a specific location, root patches will be applied to your system during macOS installation *automatically!* The OpenCore-Patcher app will be installed automatically as well.

You still have to prepare your EFI folder and `config.plist` as described in my guides to run macOS 13 and newer, but if they are configured correctly, you don't have to run OCLP in Post-Install.

### Limitations
Auo-Patching only works when installing macOS either from the "Install macOS" app or when using a USB installer, but not when installung (delta) updates via the Software Update feature in system settings!

### Who is this method for?

If your system requires iGPU and/or GPU (AMD/NVIDIA) root patches to enable hardware graphics acceleration, then this method is highly recommended to avoid the super-sluggish software-rendered setup screen. If you just need to patch Wi-Fi, then not so much. In this case, I would recommend patching Wi-Fi in post-install as usual.

> [!CAUTION]
> 
> `AutoPkg-Assets.pkg` is not designed to be run by users. Running it manually may result in bricked installations!

## Instructions

### When using a USB Installer
If you create a macOS USB installer with OpenCore Legacy Patcher, `AutoPkg-Assets.pkg` will be added to the USB installer automatically. You only need to ensure that `AutoPkgInstaller.kext` is present in your OpenCore EFI and in your `config.plist` to enable auto root-patching.

### When using the macOS Installer app
If you use OCLP to download the macOS Installer app to install a newer version of macOS on a separate APFS volume or upgrade your existing install, you need to add `AutoPkg-Assets.pkg` to the app manually after the download and assembly of the macOS installer is completed:

1. [**Prepare**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/14_OCLP_Wintel#configuration-guides) your OpenCore `config.plist` and `EFI` folder for installing macOS 13 and newer based on the configuration guide for your CPU family.
2. Add [**`AutoPkgInstaller.kext`**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) to your EFI folder and `config.plist` if it is not present already.
3. Download the latest [**AutoPkg-Assets.pkg**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) file from the OCLP repo.
4. Download the macOS Installer with OCLP:
   - Run OCLP
   - Click on "Create macOS Installer"
   - Click on "Download macOS Installer" 
   - Select the macOS Installer you want and click on "Download"
5. Once the download is completed, the "Install macOS" app will be located in "Applications"
6. Right-click the macOS Installer app and select "Show Package Contents"
7. Show hidden files by pressing <kbd>CMD</kbd>+<kbd>Shift</kbd>+<kbd>.</kbd>
8. Navigate to `Library`
9. Create a new folder and name it `Packages`
10. Copy the `AutoPkg-Assets.pkg` into the `Packages` folder:<br>![pkg](https://github.com/user-attachments/assets/fa8ceb1d-2faa-42cb-9695-c2b23314fde0)
11. Install macOS

Once the installation reaches the first-time setup stage, iGPU/GPU acceleration, external displays, Wi-Fi, and Bluetooth will work already.

> [!TIP]
>
> If your system only supports Metal 1 (Intel Ivy Bridge, Intel Haswell, Nvidia Kepler), graphics acceleration may not work properly in macOS Sequoia after reaching the desktop. In this case, make sure that your system has internet access and apply root patches again. OCLP will check for the latest [**MetallibSupporPkg**](https://github.com/dortania/MetallibSupportPkg) and download it prior to applying root patches. Afterwards, hardware graphics acceleration should work as expected again.

## Resources
- [Background info about the inner workings of automatic root patching](https://github.com/dortania/OpenCore-Legacy-Patcher/pull/986)
- Khronokernel: [macOS Ventura and legacy Metal, Part 2: New challenges with Ventura](https://khronokernel.com/macos/2022/11/01/LEGACY-METAL-PART-2.html)
- [HorizontalUnix](https://github.com/HorizonUnix/PatchSonomaWiFiOnTheFly) for explaining where the `AutoPkg-Assets.pkg` has to be placed!
