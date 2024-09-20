# Virtualization
This section covers running macOS in a virtual machine in different fashions.

## Virtualizing macOS in Proxmox Virtual Environment

:construction: Work in progress

### Links
- [**Script**](https://github.com/luchina-gabriel/OSX-PROXMOX)
- [**Installing macOS 13 on Proxmox**](https://www.nicksherlock.com/2022/10/installing-macos-13-ventura-on-proxmox/)
- [**Reddit Discussion**](https://www.reddit.com/r/Proxmox/comments/13hqc3c/anyone_setup_a_macos_vm/)

## Virtualizing macOS in Windows with Hyper-V

### System Requirements
- **CPU**: 64-bit Intel CPU with support for [virtualization technology](https://www.intel.com/content/www/us/en/support/articles/000005486/processors.html)
- **Mainboard** with UEFI support
- **RAM**: At least 16 GB or more (minimum requirement for current macOS versions is 8 GB; plus whatever is needed for running Windows, the Hypervisor and Hyper-V)
- **Windows Requirements**: 
  - **Client**: Windows 10 *Professional* v1809 or newer (non-pro versions don't support Hyper-V) 
  - **Server**: Windows Server 2019 or newer (OpenRuntime.efi doesn't work properly on previous versions)
- Hard Disk (preferably SSD) with enough space!

> [!NOTE]
> 
> Virtualizing macOS with AMD systems is currently not supported [more details](https://github.com/balopez83/macOS_On_Hyper-V#what-doesnt-work)

### Enabling Hyper-V
- In UEFI, enable Virtualization (VT-D or whatever your mainboard supports)
- Under Windows, type "features" into Cortana search and select "Turn Windows Features on or off" (alternatively, type `appwiz.cpl` and hit <kbd>Enter</kbd> to open "Programs and Features")
- Scroll down to `Hyper`-V and enable it: <br> ![01](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/32321e28-d890-408c-b566-435ec5dde640)
- Click "OK"
- The system has to reboot to install and enable the Hyper-Visor layer

### Creating a Virtual Machine (VM) for macOS
- Once Windows has rebooted, Launch "Hyper-V Manager" via Cortana Search.
- Under **Action** &rarr; Select "New…" &rarr; "Virtual Machine…":<br> ![02](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/29540787-e2bb-42e5-a734-cc14f8f4f49c)
- The **"New Virtual Machine Wizard"** starts
- Click "Next"
- **"Specify Name and Location"**. Enter a name and a location to store the VM in. In this example, I chose "macOS" as name and `C:\VMs\` as location:<br> ![03](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/042cf9fd-a888-4338-8bb8-ca7a5e9cd2c4)
  💡 Tick "Store the virtual machine in a different location" (&rarr;creates sub-folders for *each* VM for better organization)
- Click "Next"
- **Specify Generation**: select `Generation 2` (= UEFI, 64-bit only) and click "Next": <br> ![04](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/497e5467-3968-4ca3-a506-ed288f252236)
- **Assign Memory**:<br> ![05](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/67cbe54e-4eff-4be3-9293-e0a54a697745)
  - **Startup memory**: 8192 MB (Minimum for current macOS)
  - 💡Untick "Use Dynamic memory for the virtual machine" if you run into RAM-related issues.
- Click "Next" 
- **Configure Networking**: select "Default Switch" and click "Next"
- **Connect Virtual Hard Disk**:<br> ![06](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/7e8987f0-fb1c-4d60-a772-2ef699b8004a)
  - 💡 "Name" and "Location" should already be present
  - 💡 "Size": adjust or leave as is (the virtual disk grows/shrinks dynamically). If this causes issues, you can change it to a fixed value in the VM's settings later.
- Click "Next"
- **Installation Options**: Select "Install an Operating System later" and click "Next"
- **Summary**: Check if all settings are correct and click "Finish".<br>![07](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/396763f2-1c24-414a-8b9f-ccdadcccef54)
- The Hyper-V Manager now contains the entry "macOS" under "Virtual Machines":<br>![08](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/ab467af3-3eee-4e6c-83b9-b95ef5ad5da3)

### Preparing the macOS VM
Next, we need to add another virtual hard disk containing the EFI partition with OpenCore to boot macOS as well as the Recovery Partition to download and install macOS. Finally, we have to adjust some settings in the VM to make it all work together.

- Next, download the latest release of [**UEFI_OC**](https://github.com/balopez83/macOS_On_Hyper-V/releases). It's a 1GB virtual hard disk image. It contains a pre-configured OpenCore EFI folder with the necessary config and files to boot the macOS VM under Hyper-V.
- Unpack the .7z file and copy the `UEFI.vhdx` file to the "Virtual Hard Disks" folder (in my case it's located at `C:\VMs\macOS\Virtual Hard Disks`):<br>![Screenshot 2023-12-18 041516](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/ef0e6576-34b9-4357-a474-c563e1274ae5)
- Next, download a macOS Recovery for the macOS version you want to install.
- Double-click the virtual "UEFI" hard disk to mount it  
- Copy the `com.apple.recovery.boot` folder containing the `BaseSystem.chunklist` and `BaseSystem.dmg` onto the virtual UEFI disk:<br>![Screenshot 2023-12-18 043718](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/036152a8-4fc3-4fad-baed-d206cf0778b6)
- Right-click the "UEFI" disk in Windows Explorer and select "Eject" to unmout it.
- Back in Hyper-V Manger, right-click the macOS VM and select "Settings…":<br> ![Screenshot 2023-12-18 045351](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/d347cee7-0cd6-45ec-8c99-6d3f7d2207c0)
- Adjust the following Settings:
	- **Add Hardware**:
		- Select "SCSI Controller" and click "Add"
		- Select "Hard Drive"
    	- Tick "Virtual Hard Drive" and click "Browse…"
    	- Navigate to the folder containing the `UEFI.vhdx` (in this example `C:\VMs\macOS\Virtual Hard Disks`), select it and click "Open"
    	- Click "Apply" (important!)
    - **Firmware**: Boot order
    	- Move the "UEFI" Hard Disk to the top of the list – it contains the OpenCore Boot Loader and the macOS Recovery.
    	- Followed by the "macOS" Hard Disk
    	- Move the "Network Adapter" to the bottom
    	- Click "Apply"
    - **Security**: Unselect "Secure Boot"
  	- **Processor**: Assign more than 1 virtual processors if possible (ideally 4 or more)
  	- **Integration Services**: Enable "Guest Services"
  	- **Checkpoints**: Unselect "Enable Checkpoints"
- Click "OK" to save the settings and close the window.

> [!IMPORTANT]
>
> Make sure to "Eject" the UEFI disk prior to starting the macOS VM. Otherwise you get an error message because the disk is not accessible from within the VM! 

### Testing the VM
Now that the VM is prepared, we can test it. Booting macOS Recovery is most likely not going to work out of the box, but as long as OpenCore is booting you are half way there.

- Back in Hyper-V, double-click on the `macOS` VM to connect to it
- This opens a new Window. Click "Start" to boot the VM
- In the OpenCore Boot Menu, select "UEFI (dmg)" with the arrow keys and press <kbd>Enter</kbd> to start the macOS Recovery: <br> 
![Screenshot 2023-12-18 052528](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/29642a3f-7a17-489b-b821-b0be7abe3c55)
- From the Recovery Menu, select "Disk Utility"
- Select "Msft Virtual Disk Media" and click on "Erase"
- **Format**: `APFS`
- **Scheme**: `GUID Partition Map` 
- Once it's done, quit Disk Utility
- Back in the Recovery Menu, select "Reinstall macOS" to start the installation

> [!NOTE]
> 
> If booting macOS Recovery fails, you will have to adjust the OpenCore EFI and config to match your system's requirements (Settings, Kexts, Drivers, etc). In this case shutdown the VM, mount the virtual "UEFI" disk to access the OC folder and config.plist. 
> 
> If you have an already working OC folder for your system, you probably "only" have to add the Hyper-V related SSDTs, Kexts and Settings to your existing configuration. Check Acidantera's [**Mac Hyper-V Support**](https://github.com/acidanthera/MacHyperVSupport) repo for more details.
