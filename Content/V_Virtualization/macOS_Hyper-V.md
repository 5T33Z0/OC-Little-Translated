# Virtualizing macOS in Windows Hyper-V

**TABLE of CONTENTS**

- [About](#about)
- [1. System Requirements](#1-system-requirements)
- [2. Enabling Hyper-V](#2-enabling-hyper-v)
- [3. Building the macOS VM](#3-building-the-macos-vm)
	- [3.1 Building OpenCore](#31-building-opencore)
	- [3.2 Creating the EFI System Partition (`EFI.vhdx`)](#32-creating-the-efi-system-partition-efivhdx)
	- [3.3 Downloading the macOS Recovery Image](#33-downloading-the-macos-recovery-image)
	- [3.4 Adding the macOS Recovery Image to `EFI.vhdx`](#34-adding-the-macos-recovery-image-to-efivhdx)
	- [3.5 Creating the macOS VM](#35-creating-the-macos-vm)
	- [3.6 Adding the `EFI.vhdx` to the macOS VM](#36-adding-the-efivhdx-to-the-macos-vm)
- [4. Booting and installing macOS](#4-booting-and-installing-macos)
- [5. Post-Install](#5-post-install)
	- [5.1 Disable Gatekeeper](#51-disable-gatekeeper)
	- [5.2 Copying EFI content to the internal ESP](#52-copying-efi-content-to-the-internal-esp)
	- [5.3 Applying Post-Install Script](#53-applying-post-install-script)
- [6. Limitations](#6-limitations)
- [Credits and additional resources](#credits-and-additional-resources)

---

## About
Guide for running macOS as a Virtual Machine inside of Windows Hyper-V. It utilizes resources from other repos dedicated to macOS virtualization in order to automate the process to some degree by using PowerShell to build a preconfigured OpenCore EFI System Partition and downloading files required for macOS online recovery.

**Tested on**: macOS Sequoia.

---

## 1. System Requirements
- **CPU**: 64-bit Intel CPU with support for [virtualization technology](https://www.intel.com/content/www/us/en/support/articles/000005486/processors.html)
- **Mainboard** with UEFI support
- **RAM**: 16 GB or more (minimum requirement for current macOS versions is 8 GB; plus whatever is needed for running Windows, the Hypervisor and Hyper-V)
- **Windows Requirements**: 
  - **Client**: Windows 10 *Professional* v1809 or newer (non-pro versions don't support Hyper-V) 
  - **Server**: Windows Server 2019 or newer (OpenRuntime.efi doesn't work properly on previous versions)
- Hard Disk (preferably SSD) with enough space!
- Internet Connection

> [!NOTE]
> 
> This guide focusses on Intel machines primarily. If you want to virtualize macOS with AMD systems, you need to modify the OpenCore config [more details](https://github.com/Qonfused/OSX-Hyper-V#amd)

---

## 2. Enabling Hyper-V

- BIOS/UEFI Settings: enable Virtualization (VT-D or whatever your mainboard supports)
- Under Windows, type "features" into Cortana search and select "Turn Windows Features on or off" (alternatively, type `appwiz.cpl` and hit <kbd>Enter</kbd> to open "Programs and Features")
- Scroll down to `Hyper-V` and enable it: <br> ![01](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/32321e28-d890-408c-b566-435ec5dde640)
- Click "OK"
- The system has to reboot to install and enable the Hyper-Visor layer.
- Once the system has rebooted, continue with the next steps.

> [!TIP]
>
> You can also enable Hyper-V PowerShell. Run as Admin:
> 
> ```powershell
>  Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
> ```
> After a reboot, verify by running (as Admin):
>
> ```powershell
> Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V
> ```

----

## 3. Building the macOS VM

The VM for running macOS in Hyper-V requires two virtual disks: one with EFI System Partition containing the OpenCore Bootloader as well as the macOS Recovery. The other one is for the actual macOS Installation.

### 3.1 Building OpenCore
1. Download [OSX-Hyper-V](https://github.com/Qonfused/OSX-Hyper-V/archive/refs/heads/main.zip) and unzip it
2. Run PowerShell as Administrator
3. Change the Execution Policy in order to be able to execute scripts:
	```powershell
  	Set-ExecutionPolicy RemoteSigned
  	```
4. Next, navigate to the scripts folder:
	```powershell
	cd ~/Downloads/OSX-Hyper-V-main/scripts
  	```
 	**Note**: Adjust path accordingly when using a newer release 
5. Run the build script: 
	```powershell
  	powershell -ExecutionPolicy Bypass -File ".\build.ps1"
  	```
> [!NOTE]
>
> This will build the OpenCore EFI folder for use with Hyper-V. It will be located under `dist/`, alongside a `dist/Scripts/` directory containing scripts for creating and configuring the virtual machine. If the script fails to run or errors occur, download the latest pre-build OpenCore EFI [Release](https://github.com/Qonfused/OSX-Hyper-V/releases) and workk with it instead, since it contains the required scripts as well. 

### 3.2 Creating the EFI System Partition (`EFI.vhdx`)
Next, we build the virtual Disk with the EFI System Partition containing OpenCore.

1. Next, navigate to the `/dist/scripts` folder:
	```powershell
	cd ../dist/scripts
	```
2. Run the next script to build the `EFI.vhdx`:
	```powershell
	powershell -ExecutionPolicy Bypass -File ".\convert-efi-disk.ps1"
  	```
	The `EFI.vhdx` will be located in the `dist` folder.

> [!IMPORTANT]
>
> Once the `EFI.vhdx` is created, Windows explorer wants to format it. Cancel this!

### 3.3 Downloading the macOS Recovery Image

1. Run PowerShell as Administrator
2. Change the Execution Policy in order to be able to execute scripts:
	```powershell
  	Set-ExecutionPolicy RemoteSigned
  	```
3. Navigate to the Scripts Folder again:
	```powershell
	cd ~/Downloads/OSX-Hyper-V-main/dist/scripts
	```
4. Run the script to create the macOS Recovery partition:
   ```powershell
   powershell -ExecutionPolicy Bypass -File "./create-macos-recovery.ps1"
   ```
   :bulb: Press `A` if asked if you want to execute the script. The files will be located in the `dist` folder as `com.apple.recovery.boot`

### 3.4 Adding the macOS Recovery Image to `EFI.vhdx`

1. In Explorer, double-click the `EFI.vhdx` to mount it
2. Copy the `com.apple.recovery.boot` folder containing the `BaseSystem.chunklist` and `BaseSystem.dmg` onto the virtual EFI disk
3. Right-click the "EFI" disk in Windows Explorer and select "Eject" to unmount it.

### 3.5 Creating the macOS VM

1. Launch "Hyper-V Manager" via Cortana Search.
2. In the right sidebar, click on "Connect to Server" and select "Local Machine" 
3. Under **Action** &rarr; Select "New…" &rarr; "Virtual Machine…":<br> ![02](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/29540787-e2bb-42e5-a734-cc14f8f4f49c)
4. The **"New Virtual Machine Wizard"** starts
5. Click "Next"
6. **"Specify Name and Location"**. Enter a name and a location to store the VM in. In this example, I chose "macOS" as name and `C:\VMs\` as location:<br> ![03](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/042cf9fd-a888-4338-8bb8-ca7a5e9cd2c4)
  💡 Tick "Store the virtual machine in a different location" (&rarr;creates sub-folders for *each* VM for better organization)
7. Click "Next"
8. **Specify Generation**: select `Generation 2` (= UEFI, 64-bit only) and click **"Next"**: <br> ![04](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/497e5467-3968-4ca3-a506-ed288f252236)
9. **Assign Memory**:<br> ![05](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/67cbe54e-4eff-4be3-9293-e0a54a697745)
  - **Startup memory**: 8192 MB (Minimum for current macOS)
  - 💡Untick "Use Dynamic memory for the virtual machine" if you run into RAM-related issues.
10. Click "Next" 
11. **Configure Networking**: select **"Default Switch"** and click **"Next"**.
12. **Connect Virtual Hard Disk**:<br> ![06](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/7e8987f0-fb1c-4d60-a772-2ef699b8004a)
  - 💡 "Name" and "Location" should already be present
  - 💡 "Size": adjust or leave as is (the virtual disk grows/shrinks dynamically). If this causes issues, you can change it to a fixed value in the VM's settings later.
13. Click **"Next"**
14. **Installation Options**: Select "Install an Operating System later" and click **"Next"**
15. **Summary**: Check if all settings are correct and click "Finish".<br>![07](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/396763f2-1c24-414a-8b9f-ccdadcccef54)
16. The Hyper-V Manager now contains the entry "macOS" under "Virtual Machines":<br>![08](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/ab467af3-3eee-4e6c-83b9-b95ef5ad5da3)

> [!TIP]
>
> Alternatively, you can create the macOS VM with PowerShell by running the `create-virtual-machine.ps1` script located in the `Downloads\OSX-Hyper-V-main\dist\Scripts` directory.

### 3.6 Adding the `EFI.vhdx` to the macOS VM

Next, we need to incorporate the `EFI.vhdx` into the macOS VM, so macOS boots off it

- Copy the `EFI.vhdx` from `~/Downloads/OSX-Hyper-V-main/dist` to the "Virtual Hard Disks" folder (in my case it's located at `C:\VMs\macOS\Virtual Hard Disks`):<br><img width="699" height="109" alt="macOS_hyper-V_05" src="https://github.com/user-attachments/assets/ba0debcb-b5b8-45ee-8e8a-78a2abd6c5a1" />
- Back in Hyper-V Manager, right-click the macOS VM and select "Settings…"
- Click on "Security" and disable Secure Boot:<br><img width="1083" height="1029" alt="Security" src="https://github.com/user-attachments/assets/30afdae0-feda-45f9-b64b-1155b5f72efe" />
- Next, select "SCSI-Controller"
- Select "Hard Drive and click add to "connect" an additional virtual disk:<br><img width="1083" height="1029" alt="Add_Disk" src="https://github.com/user-attachments/assets/56bfd324-477e-4d33-93b7-0cd3073bd721" />
- Select "Virtual hard disk", click "Browse", navigate to the `EFI.vhdx`, select it and click "Open" to add it:<br><img width="542" height="515" alt="image" src="https://github.com/user-attachments/assets/e1d58e62-8aa4-49a5-b687-a21abdadba8a" />
- Next, click on "Firmware" and move the `EFI.vhdx` to the top of the list, followed by the `macOS.vhdx`. Move the network adapter to the end of the list:<br><img width="542" height="515" alt="Settings_Bootorder" src="https://github.com/user-attachments/assets/e1f0444e-dbad-4676-adb3-776464d956bb" />
- Finally, adjust the following Settings:
  - **Processor**: Assign more than 1 virtual processors if possible (ideally 4 or more)
  - **Integration Services**: Enable "Guest Services"
  - **Checkpoints**: Unselect "Enable Checkpoints"
- Click "OK" to save the settings and close the window.

> [!IMPORTANT]
>
> Make sure to "Eject" the EFI disk prior to starting the macOS VM. Otherwise you get an error message because the disk is not accessible from within the VM!

---

## 4. Booting and installing macOS
Now that the VM is prepared, we can test it. Booting macOS Recovery is most likely not going to work out of the box, but as long as OpenCore is booting you are half way there.

- Back in Hyper-V, double-click on the `macOS` VM to connect to it
- This opens a new Window. Click **"Start"** to boot the VM. 
- In the OpenCore Boot Menu, select "EFI (dmg)" with the arrow keys and press <kbd>Enter</kbd> to start the macOS Recovery: <br> <img width="314" height="186" alt="Boot_01" src="https://github.com/user-attachments/assets/96bf3a1a-9823-463e-895c-bba6e0297fe2" />
- Depending on your system specs, it might take about 30 seconds to a minute to reach the installer GUI
- From the Recovery Menu, select "Disk Utility" and click "Continue":<br><img width="769" height="647" alt="Install_01_1" src="https://github.com/user-attachments/assets/30128a73-1f50-4d4d-ab2c-567ddb631c80" />
- Select "Msft Virtual Disk Media" and click on "Erase": <br><img width="769" height="647" alt="Format_02" src="https://github.com/user-attachments/assets/a43e37bb-f2b9-4279-be40-26fd14aa1b6a" />
- Adjust the following:
  - **Name**: up to you
  - **Format**: `APFS`
  - **Scheme**: `GUID Partition Map`  
- Click "Erase"
- Once the virtual disk is formatted, quit Disk Utility
- Back in the Recovery Menu, select "Reinstall macOS" and click "Continue" (2x)
- Agree to the SLA (click "Agree" 2x)
- Select the macOS Disk and click "Continue"
- This will start downloading macOS from Apple's Servers. Depending on your internet connection, this might take a while:<br><img width="769" height="647" alt="Install_04" src="https://github.com/user-attachments/assets/05d8493b-e04c-43a6-8d38-271f0ac28eb9" />


From now on, the VM will reboot a couple of times to finish the installation. Once it's done, you will be greeted by macOS' Setup-Assistant to create a local User Account, select your preferred language, etc.

> [!NOTE]
> 
> If booting macOS Recovery fails, you will have to adjust the OpenCore EFI and config to match your system's requirements (Settings, Kexts, Drivers, etc). In this case shutdown the VM, mount the virtual "EFI" disk to access the OC folder and config.plist. 
> 
> If you have an already working OC folder for your system, you probably "only" have to add the Hyper-V related SSDTs, Kexts and Settings to your existing configuration. Check Acidanthera's [**Mac Hyper-V Support**](https://github.com/acidanthera/MacHyperVSupport) repo for more details.
>
> For further troubleshooting, refer to the [OpenCore Post-Install guide](https://dortania.github.io/OpenCore-Post-Install/) or to [Qonfused's OSX-Hyper-V repo](https://github.com/Qonfused/OSX-Hyper-V), which the OpenCore EFI and scripts in this guide are based on.

---

## 5. Post-Install

The following steps need to be executed within the running macOS VM.

### 5.1 Disable Gatekeeper

&rarr; Follow these [Instructions](https://github.com/5T33Z0/OCLP4Hackintosh/blob/main/Guides/Disable_Gatekeeper.md) to disable Gatekeeper in macOS Sequoia and newer. This is necessary in order to run post-install scripts and tools like 3rd party apps.

### 5.2 Copying EFI content to the internal ESP
- Open Finder
- Select "EFI" disk from the sidebar
- Copy the following Folders to the Desktop:
  - EFI
  - Scripts
  - Tools
- Right-click the EFI disk and select "Eject 'EFI'"
- Next, download [OpenCore Auxiliary Tools](https://github.com/ic005k/OCAuxiliaryTools/releases) for macOS (DMG). We need it to mount the internal EFI System Partition (ESP)
- Double-click the `OCAT_Mac.dmg` file to mount it
- Drag the App to the Desktop
- Run it
- Click Edit &rarr; MountESP
- Select disk0s1 EFI and click "Mount"
- Enter your macOS Password (the one you set during install)
- In Finder, select the EFI Partition from the Internal Disk
- Drag and Drop the EFI, Script and Tools folder into it.
- Shutdown macOS
- In the VM Window, Select "File"  &rarr; "Settings"
- Under "SCSI Controller", select the "EFI" Hard Drive and click the "Remove" button, since we no longer need it.
- Click "Apply"

You can now boot macOS without the `EFI.vhdx` disk.

### 5.3 Applying Post-Install Script
This script will install the `MacHyperVFramebuffer.kext` to "Library/Extensions" which provides enhanced graphics support (resolution switching and hardware cursor) for macOS. Additionally, it installs some files to `Library/ApplicationSupport/MacHyperVSupport` and `LibraryLaunchDaemons`.

- Start the macOS VM 
- Run OCAuxiliary Tools
- Mount the EFI
- Open Terminal (located in: Application/Utilities)
- Run the post-Install Script. Enter:
	```bash
	sudo sh /volumes/EFI/Scripts/post-install.sh
	```
- During install, you will receive a pop-up to allow the new extension to load.
- Once the installation is completed, reboot the macOS VM

The VM should feel a bit more responsive after rebooting.

---

## 6. Limitations
- **iGPU/GPU Passthrough**: I couldn't get the graphics acceleration via Intel iGPU fully working, since iGPU and GPU passthrough isn't fully implemented into Hyper-V.
- **Audio**: I couldn't get Audio working although I added the AppleALC.kext and necessary DeviceProperties (PCI-Path and Layout-ID).

---

## Credits and additional resources
- Acidanthera for [MacHyperVSupport](https://github.com/acidanthera/MacHyperVSupport)
- Qonfused for [OSX-Hyper-V](https://github.com/Qonfused/OSX-Hyper-V) - OpenCore configuration and Scripts for running macOS on Windows Hyper-V. 
- LongQT-sea for [macOS ISO Builder](https://github.com/LongQT-sea/macos-iso-builder) - Pre-Built macOS ISOs
- dkroll IT for german guide for [Installing macOS in Hyper-V](https://dkroll.com/mac-os-vm-mittels-hyper-v/)
