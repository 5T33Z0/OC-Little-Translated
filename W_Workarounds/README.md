# Workaround for upgrading from macOS Sonoma 14.3.1 to 14.4

[![OpenCore Version](https://img.shields.io/badge/OpenCore_Version:-0.9.9+-success.svg)](https://github.com/acidanthera/OpenCorePkg) ![macOS](https://img.shields.io/badge/Supported_macOS:-≤14.4-white.svg)

## About
I've noticed that I could not upgrade from macOS 14.3.1 to 14.4 on 2 of my machines when using `Software Update`. One was my Gigabyte Z490 workstation, the other one was my Lenovo T490. Below is how I solved it.

##  Symptoms

- Incremental updates download fine via Software Update
- The preparation stage works fine as well
- After the reboot the installer crashes early
- Starting macOS afterwards results in an installation process, but afterwards the system is still at version 14.3.1

I don't have a clue why this happens, but it seems something changed drastically between macOS 13.3.1 and 13.4. that makes it impossible on some systems to upgrade via incremental updates.

## Workaround

### Install via USB flash drive

- Update OpenCore, drivers and kexts to the latest version
- Download OpenCore Legacy Patcher
- Use it to download macOS 14.4 and create a USB Installer
- Reboot
- Run the Installer from the USB flash drive
- Create a new APFS volume on your SSD/NVME in Disk Utility
- Install macOS on it – if your EFI and config were working fine before, the installation should work without problems
- If you face problems, disable `SecureBootModel` during installation

### Post-Install

- Run the Migration Manager to copy over the data from your previous macOS installation
- Delete the old 14.3.1 macOS Sonoma Volume 
- Re-Enable `SecureBootModel`

## Failed workaround attempts (aka: Don't do this)

- Someone suggested to change `SecureBootModel` and the install macOS over the existing 14.3.1 install. DON'T DO THIS!
- The system partiton will be deleted but the installer will crash afterwards – so you are left with no OS and the Data partition only
- Although you can acces your User Account and data after installing macOS on a new APFS Volume via Finder later, you cannot access it via Migration Assistant: ![masucksazz](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/2c850846-ee6d-4b37-8af0-f0522a83c96b)
- In this case you have to copy over all your Data manually. 

> [!NOTE]
> 
> If someone has any clues why upgrading from macOS 14.3.1 is such a pita, let me know! Because comments like "Upgrade worked fine for me" followedd by the obligatory ovesized screenshots of "About this Mac" on Forums are helping nobody!
