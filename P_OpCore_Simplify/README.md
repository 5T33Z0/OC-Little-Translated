# Generating an OpenCore Config with OpCore Simplify

**INDEX**

- [About](#about)
- [Use Cases](#use-cases)
	- [Use case 1: creating an OpenCore EFI folder for your own system](#use-case-1-creating-an-opencore-efi-folder-for-your-own-system)
	- [Use case 2: creating an OpenCore EFI for other systems/users](#use-case-2-creating-an-opencore-efi-for-other-systemsusers)
		- [Instructions (for system owners)](#instructions-for-system-owners)
		- [Instructions (for assistants/helpers)](#instructions-for-assistantshelpers)
	- [Use case 3: 11th to 14th Gen Intel Core CPUs](#use-case-3-11th-to-14th-gen-intel-core-cpus)
- [Testing](#testing)
	- [If macOS is installed already](#if-macos-is-installed-already)
	- [If macOS is not installed](#if-macos-is-not-installed)
- [Reporting](#reporting)
- [Closing thoughts](#closing-thoughts)

---

## About

I recently stumbled over an interesting project on Github called [**OpCore Simplify**](https://github.com/lzhoang2801/OpCore-Simplify). It's designed to automate and streamline the creation of OpenCore EFI configurations for Hackintosh setups. It supports a wide range of hardware, including modern CPUs and GPUs, and macOS versions from High Sierra to Sequoia. 

In terms of building an OpenCore config semi-automatically, OpCore Simplify the first tool of its kind. Although you can run it under macOS, in my experience it best works under Microsoft Windows.

**How It Works:**

1. **Hardware Detection:** OpCore Simplify includes a Python-Script called **Hardware Sniffer** that gathers detailed hardware information from a Wintel system by applying:

   - **Data Collection via WMIC:** Hardware Sniffer utilizes the **Windows Management Instrumentation Command-line** utility (WMIC) to extract comprehensive details about system components, including the MAINBOARD, CPU, GPU, monitors, network adapters, audio devices, USB controllers, input devices, storage controllers, biometric sensors, Bluetooth devices, SD controllers, and system devices. 
   - **Advanced Detection Techniques:**
       - **Motherboard Chipset Identification:** The tool analyzes PCI device information to accurately identify Intel chipset models.
       - **CPU Codename Recognition:** It determines the CPU codename by evaluating the processor's family, model, and stepping values, eliminating the need to query external sources like Intel ARK or AMD websites.
       - **GPU Codename Recognition:** Hardware Sniffer identifies GPU codenames using device IDs, facilitating precise hardware identification.
       - **Input Device Connection Type:** The script detects the connection types of input devices (such as touchpads and touchscreens), distinguishing between interfaces like I2C, PS/2, SMBus, and USB.
   - **Output Generation:** After collecting and analyzing the hardware data, Hardware Sniffer can export the information in JSON format. This structured output is particularly useful for integration with tools like OpCore Simplify, which automate the creation of OpenCore EFI configurations for Hackintosh systems. 

   By automating the detection and reporting of hardware components, Hardware Sniffer streamlines the process of configuring macOS installations on non-Apple hardware, ensuring that all necessary drivers and settings are appropriately accounted for in the resulting OpenCore EFI. 

2. **ACPI Patches and Kexts:** Based on the detected hardware, the tool applies necessary ACPI patches and includes appropriate kernel extensions (kexts) to ensure compatibility and functionality. It integrates with SSDTTime for common patches and includes custom patches to prevent kernel panics and disable unsupported devices. 

3. **SMBIOS Configuration:** The tool generates a suitable System Management BIOS (SMBIOS) configuration tailored to your hardware, which is essential for macOS compatibility.

4. **EFI Folder Generation:** After gathering all necessary files and configurations, OpCore Simplify creates an OpenCore EFI folder customized for your system. This folder includes the bootloader, configuration files, ACPI patches, and kexts required for macOS installation.

5. **User Guidance:** The tool provides instructions on additional steps, such as USB mapping using USBToolBox and adding the generated USBMap.kext to your EFI, to ensure a fully functional Hackintosh setup.

## Use Cases

### Use case 1: creating an OpenCore EFI folder for your own system

I've tried OpCore Simplify on one my Ivy Bridge laptop which requires quite a complex configuration to boot macOS 13 and newer. Below, I've explained how I did, so you can check out for yourself if you want to try it.

> [!CAUTION]
>
> Don't use the settings shown in the screenshots for *your* system. It's just an example, **NOT** a config guide!

1. Run MS Windows
2. Download [**OpCore Simplify**](https://github.com/lzhoang2801/OpCore-Simplify) (click on `<> Code` and select "Download Zip")
3. Extract the zip file
4. Run the `OpCore-Simplify.bat` file (if Windows wants to block the script, click on "More info" so that the button to run the script appears!)
5. This will start a Terminal Window and download required files. Once that's done, you will be greeted by the following screen:<br>![01](https://github.com/user-attachments/assets/be90d44c-9698-4196-b4f0-58965607e451)
6. Select option <kbd>1</kbd> and hit <kbd>Enter</kbd>
7. This will start the hardware detection – Type <kbd>e</kbd> and press <kbd>Enter</kbd>:<br>![02](https://github.com/user-attachments/assets/feefc135-7ba9-481b-a8ac-11203161d91f)
8. Once the hardware detection is completed, a report is shown:<br>![03](https://github.com/user-attachments/assets/2021cd8b-48d2-44f9-b39f-8032000b67b0)
9. Press <kbd>Enter</kbd> to return to the main screen:<br>![04](https://github.com/user-attachments/assets/9976987f-96a3-4d0a-9805-9008c76bf77d)
10. Select option <kbd>2</kbd> and hit <kbd>Enter</kbd>
11. Select the macOS version you want to install by entering the corresponding number, here <kbd>24</kbd> for macOS Sequoia:<br>![05](https://github.com/user-attachments/assets/4c4f8d74-b1ec-4e7e-a8eb-eb96bfc0143f)
12. Back in the main screen, select Option <kbd>3</kbd> and press <kbd>Enter</kbd>:<br>![07](https://github.com/user-attachments/assets/59aa0e14-4aa2-455d-91d3-fba2580d3ff5)
13. This shows the available SSDT hotfixes available for your system:<br>![09](https://github.com/user-attachments/assets/a7eaedfc-b8e4-411d-855e-dbe47df52d4f)
14. Select/de-select the SSDTs you need for your system. Most required patches will be pre-enabled automatically. If you are uncertain which ones you need (or not), please refer to the [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/). Once your done reviewing the SSDTs, type <kbd>b</kbd> and press <kbd>Enter</kbd> to return to the main menu.
15. Back in the main screen, select Option <kbd>4</kbd> and press <kbd>Enter</kbd> to select/modify the kexts to add to your OpenCore EFI folder. If you are using a laptop, make sure to inspect the selected kexts for Wi-Fi/BT and Touchpad especially:<br>![11](https://github.com/user-attachments/assets/0d77f97f-8470-49d1-a891-335d8346a5ad)
16. Return to the main screen and select Option <kbd>5</kbd> and press enter to select an SMBIOS best matching your CPU, here it's `MacBookPro10,1`, since my Laptop has an i7 Ivy Bridge Mobile CPU:<br>![12](https://github.com/user-attachments/assets/25ee0af1-debe-40c1-9034-bc085f8d18ac)
17. Return to the main screen and select option <kbd>6</kbd> to start building the OpenCore EFI folder and `config.plist`. Once that's done you will be notified about the next steps to map USB ports:<br>![13](https://github.com/user-attachments/assets/359d41ac-9b3c-4cd8-8f43-9d93897b3999)
18. [**Map your USB ports**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/03_USB_Fixes) as explained and add the required kext(s) to the `EFI/OC/Kexts` folder located under:<br>![14](https://github.com/user-attachments/assets/97dbac6f-6f28-4d92-8cec-00e8142765ee)
19. Open your `config.plist` with [**ProperTree**](https://github.com/corpnewt/ProperTree) and create an OC Snapshot:<br>![15](https://github.com/user-attachments/assets/4922e670-de33-408c-b316-913a5a948d98)

### Use case 2: creating an OpenCore EFI for other systems/users

Since OpCore Simplify dumps the target system's ACPI tables and generates a hardware report (`Report.json`), these resources can be used by more experienced users to configure an OpenCore EFI folder for them. The user you want to assist must run OpCore Simplfiy in Windows, create a hardware report (Steps 1-12) and send it to you.

#### Instructions (for system owners)

1. Run MS Windows
2. Download [**OpCore Simplify**](https://github.com/lzhoang2801/OpCore-Simplify) (click on `<> Code` and select "Download Zip")
3. Extract the zip file
4. Run the `OpCore-Simplify.bat` file (if Windows wants to block the script, click on "More info" so that the button to run the script appears!)
5. This will start a Terminal Window and download required files. Once that's done, you will be greeted by the following screen:<br>![01](https://github.com/user-attachments/assets/be90d44c-9698-4196-b4f0-58965607e451)
6. Select option <kbd>1</kbd> and hit <kbd>Enter</kbd>
7. This will start the hardware detection – Type <kbd>e</kbd> and press <kbd>Enter</kbd>:<br>![02](https://github.com/user-attachments/assets/feefc135-7ba9-481b-a8ac-11203161d91f)
8. Once the hardware detection is completed, a report is shown:<br>![03](https://github.com/user-attachments/assets/2021cd8b-48d2-44f9-b39f-8032000b67b0)
9. Press <kbd>Enter</kbd> and <kbd>Q</kbd> to quit OpCore Simplify
10. In File Explorer, navigate to the `OpCore-Simplify-main` folder
11. Inside should now be a `SysReport` folder containing `ACPITables` and `Report.json`: ![report01](https://github.com/user-attachments/assets/f01b80d9-c349-4068-8429-1dfcbc8d5f3d)
12. Zip the `SysReport` folder and send it to the person who wants to assist you.

#### Instructions (for assistants/helpers)

1. Once you receive the `SysReport.zip`, unzip it
2. Run OpCore Simplify in Windows
3. Chose Option 1: "Select Hardware Report"
4. Drag and Drop the `Report.json` file into the Terminal Window:<br>![report02](https://github.com/user-attachments/assets/973cb472-fb1a-4fbb-aab5-060170e94431)
5. Press <kbd>Enter</kbd> to import the data. Once that's done, you will have something like this:<br>![report03](https://github.com/user-attachments/assets/06c4189f-b815-4825-bfc7-f2f9feb313e9)
6. Press <kbd>Enter</kbd> to continue
7. Drag and drop the `ACPITables` folder into the Terminal Window:<br>![report04](https://github.com/user-attachments/assets/af2f8ab6-0d88-4522-aa89-0e3e27687fd5)
8. Press Enter again to import the tables. Once that's done, you will be back in the main screen showing the results, including the compatible macOS version as well as the recommended SMBIOS:<br>![report05](https://github.com/user-attachments/assets/76c35384-727d-4225-b706-3537803ed4f5)
9. Continue to configure the EFI as explained in "Use case 1", build it, zip it up and send it the user you want to help for testing.

### Use case 3: 11th to 14th Gen Intel Core CPUs 

The official OpenCore installation guide only covers Intel CPUs up to 10th Gen "Comet Lake". However, while Apple has officially dropped support for newer Intel processors, it's still possible to run macOS on 11th Gen and later CPUs. There are two main considerations when using these newer processors:

1. The integrated GPU (iGPU) won't function since no framebuffer patches are available
2. The config needs adjustments to properly handle Performance (P) and Efficiency (E) cores (12th gen+)

Currently, OpenCore Simplify supports generation OpenCore EFIs up to 14th gen Intel Core.

## Testing

### If macOS is installed already 

- Put your newly generated EFI folder on a FAT32 formatted USB flash drive and try to boot macOS with it.
- If it works out of the box, congrats! You can mount your system's EFI partition and put the EFI folder on it to boot from an internal disk.
- If it doesn't work, consult the [**OpenCore Troubleshooting Guide**](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/troubleshooting.html). 

### If macOS is not installed

- If macOS is not installed already, [**create a USB Installer**](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/#making-the-installer) and put your EFI folder on it.
- Restart your system from the USB flash drive and [**install macOS**](https://dortania.github.io/OpenCore-Install-Guide/installation/installation-process.html#installation-process). Windows users can also use [**UnPlugged**](https://github.com/corpnewt/UnPlugged) to do so.
- For troubleshooting, consult the [**OpenCore Troubleshooting Guide**](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/troubleshooting.html).

## Reporting

The OpCore Simplify repo has a [discussion section](https://github.com/lzhoang2801/OpCore-Simplify/discussions/23) where you can share your experiences which might be helpful for the developer to improve the tool.

## Closing thoughts

In my test, this particular Ivy Bridge laptop didn't boot with the generated EFI and config. Since then, I've tested OpCore Simplify on two other systems (a laptop and a desktop pc) and both booted macOS out of the box without issues. That's pretty impressive, especially when considering the timesave this tool allows: setting up and building an OpenCore EFI folder this way takes around 5 to 10 minutes (mapping USB ports excluded).

For owners of legacy systems (1st to 6th Gen Intel Core), who already have an existing OpenCore EFI, I would recommend to use the corresponding guide in the [**OCLP Wintel section**](/14_OCLP_Wintel/README.md) instead to manually prepare their config, when trying to install macOS Monterey or newer on their machines. 

Overall, I think OpCore Simplify is the closest thing to a fully automated OpenCore configuration tool we have yet. It's a great starting point for new and inexperienced users who simply want to try OpenCore on relatively current hardware without spending *hours* trying to configure OpenCore manually using the OpenCore Configuration guide. I am very excited to see how this project will evolve in the future.
