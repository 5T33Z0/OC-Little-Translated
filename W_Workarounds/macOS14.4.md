# Workaround for upgrading from macOS Sonoma 14.3.1 to 14.4

[![OpenCore Version](https://img.shields.io/badge/OpenCore_Version:-0.9.9+-success.svg)](https://github.com/acidanthera/OpenCorePkg) ![macOS](https://img.shields.io/badge/Supported_macOS:-≤14.4-white.svg)

## About
I've noticed that I could not upgrade from macOS 14.3.1 to 14.4 on 2 of my machines when using `Software Update`. One was my [Gigabyte Z490](https://github.com/5T33Z0/Gigabyte-Z490-Vision-G-Hackintosh-OpenCore) workstation, the other one was my [Lenovo T490](https://github.com/5T33Z0/Thinkpad-T490-Hackintosh-OpenCore) Laptop. Below is how I solved it.

##  Symptoms

- Incremental updates download fine via Software Update
- The preparation stage works fine as well
- After rebooting, the installer crashes early
- Starting the existing macOS install results in what _looks_ and _behaves_ like an installation process, but in the end the system will still be on macOS 14.3.1

I don't have a clue why this happens, but it seems something changed drastically between macOS 13.3.1 and 13.4., that makes it impossible on some systems to upgrade via incremental updates.

## Workaround

### Option 1: Disable `SecureBootModel` and `Airportitlwm.kext`

On my Lenovo T490, disabling `SecureBootModel` and the beta version of `AirPortItlwm.kext` in favor of `ìtlwn.kext` did solve the issue of the macOS Installer crashing early, so disabling troublesome kexts *might* help to resolve the issue in similar circumstances.

- Set `Misc/Security/SecurebootModel` to `Disabled`
- Disable `AirPortItlwm.kext` if you have it
- Enable `itlwm.kext` (and install HeliPort App)
- Save your config and reboot
- Download the macOS 14.4+ update and install it
- Disable `itlwm.kext` and re-enable `AirPortItlwm.kext` again
- Re-enable `SecureBootModel`
- Safe and reboot

### Option 2: Install macOS on a new volume

- Update OpenCore, drivers and kexts to the latest version
- Download OpenCore Legacy Patcher
- Use it to download macOS 14.4+ and create a USB Installer
- Reboot
- Run the Installer from the USB flash drive
- Create a new APFS volume on your SSD/NVME in Disk Utility
- Install macOS on it – if your EFI and config were working fine prior tp installing 14.4, they should work fine now
- If you face problems, disable `SecureBootModel` prior to installing

#### Post-Install

- Run the Migration Manager to copy over the data from your previous macOS installation
- Delete the old 14.3.1 macOS Sonoma Volume 
- Re-Enable `SecureBootModel`

## Previously failed workaround attempts (aka: Don't do this!)

- Someone suggested to change `SecureBootModel` and the install macOS over the existing 14.3.1 install. ⚠️ DON'T DO THIS! The system volume will be deleted but the installer will crash when attempting to create a new system volume – so you will be left with the Data partition of the 14.3.1 install only – no bootable OS!
- In this case, you have to install macOS 14.4 on a new APFS volume
- Once macOS 14.4 is installe, you can acces the old User Account and Data via Finder, but you cannot use the Migration Assistant to get the data onto your current system: ![masucksazz](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/2c850846-ee6d-4b37-8af0-f0522a83c96b)
- In this case you have to copy over all your data manually.

> [!NOTE]
> 
> If someone has any clues why upgrading from macOS 14.3.1 is such a pita, let me know! Because comments like "Upgrade worked fine for me" followed by the obligatory oversized screenshots of the "About this Mac" section on Forums are not helping anybody.
