# OpenCore Config Tips and Tricks (by 5T33Z0)
This section contains a small collection of useful tips and tricks for working with OpenCore's `config.plist`. 

**Last Update**: September 14th, 2021

<details>
<summary><strong>Fixing Config Errors</strong></summary>

## I. Checking config.plist for errors

Currently there are two automated methods to check your config.plist for errors:

1. **Online**: ~~[OpenCore Sanity Checker](https://opencore.slowgeek.com/) is a useful site where you can check your config. Errors are highlighted in red and you can copy the link to the sanity check result and put it in a post to point out config problems. Unfortunately, the site hasn't been updated for a while and only fully supports OpenCore to version 0.6.6. The source code can be found here if someone is interested in implemnting it in a new and updated site: [OCSanity](https://github.com/rlerdorf/OCSanity)~~ Just too outdated o use now. Just stick to the offline method using OCValidate and/or OCConfigCompare for now.

2. **Offline**: The OpenCore package also contains the folder `Utilities`. In it you will find `ocvalidate`. Drag this into Terminal, leave a blank space, drag in your config.plist next and press [ENTER]. It will show errors in the config and where they are. With the help of [OCConfgCompare](https://github.com/corpnewt/OCConfigCompare), Sample.plist and [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/) you can correct all errors quite fast. 

While Sanity Checker focuses on correct settings for the selected system, OC Validate additionally checks the syntax for errors. Therefore it makes sense to check the config in two steps: first online and then offline.

**CAUTION**: Don't use OpenCore Configurator for editing your `config.pllist` when using nightly builds of OpenCore. Because it automatically adds entries to the config which may have been removed oder relocated in the config. This results in errors when rebooting.
</details>
<details>
<summary><strong>Fixing Boot Issues</strong></summary>

## II. Quick fixes for Boot Problems

If the system won't boot despite correct boot and kernel settings and hangs directly at the boot logo without a progress bar, you should change the following settings:

- **Misc > Security > SecureBootModel** = `Disabled`. If you have problems with booting using the`Default` value. For security concerns you should check if the chosen mac Model in `SystemProductName`supports Apple's Secure Boot feature, once your system is working. Refer to the Documentation.pdf for more details. 
- **Misc > Security > Vault** = `Optional` Disables File Vault. Can prevent system boot if it is set to "Secure" but File Vault encryption is not configured at all. Because it needs the generation of a key and a hash.

If your macOS Partion (APFS) is not displayed in Bootpicker, do the following (OpenCore 0.7.2 and newer):

- **UEFI > APFS**: Change `MinDate` and `MinVersion` to `-1`. This disables APFS driver verifictaion, so it loads no matter which version you are using (from macOS High Sierra onwards, because that's when APFS was introduced). 

**BACKGROUND**: If you use an OS older than Big Sur and both values are set to default (`0`) you won't see your macOS Partition, because the APFS driver won't load. This is a security feature which should ensure that your macOS boots using a varified APFS driver. To maximize compatibility with older macOS versions, I would disable it during Install.

**IMPORTANT**: For security reason you should change these values according to the version of macOS you are using. A list with the correct values for `MinDate` and `MinVersion`can be found here: https://github.com/acidanthera/OpenCorePkg/blob/master/Include/Acidanthera/Library/OcApfsLib.h

</details>
<details>
<summary><strong>Security Settings</strong></summary>

## III. Security Settings

### How to disable Single User Mode
You should deactivate the single user mode for security reasons, because it can be mis-used as a backdoor to bypass the password protection of the Admin account. To do this, enable the following option:

**Misc > Security > DisableSingleUser** = `Yes`

### How to disable System Integrity Protection (SIP)

1. To disable System Integrity Protection, add one of the following values to the config:

   **NVRAM > Add > 7C436110-AB2A-4BBB-A880-FE41995C9F82** > change `csr-active-config` from `00000000`(SIP enabled) to:

   `FF030000` (for High Sierra)
   `FF070000` (for Mojave/Catalina)
   `67080000` (for Big Sur*)

   ***NOTE**: The value `FF0F0000` provided in the Dortania Install Guide has been proven to not work correctly in Big Sur – it prevents you from getting offered system updates. In Big Sur, *authenticated root* has been added to the SIP, resulting in a different value of 0x867 for csr-active config. In OpenCore this corresponds to the hex-swapped value of `67080000`.

2. To avoid the need of resetting NVRAM every time after you've changed  the csr value, add the following parameter to the config:

   **NVRAM > Delete > 7C436110-AB2A-4BBB-A880-FE41995C9F82** > `csr-active-config`.

   This deletes the current csr value from the NVRAM on reboot and will be replaced by the value stored under "NVRAM > Add…". This is Very useful if you have different macOS installs which use different CSR values.

   To test if the settings were applied after reboot, type `csrutil status` into the terminal after reboot. The result should look something like this:

    	Configuration:
    	 Apple Internal: enabled
    	 Kext Signing: disabled
    	 Filesystem Protections: disabled
    	 Debugging Restrictions: disabled
    	 DTrace Restrictions: disabled
    	 NVRAM Protections: disabled
    	 BaseSystem Verification: disabled
   

</details>
<details>
<summary><strong>Adjusting Boot Picker Behavior</strong></summary>

## IV. Adjust Boot Picker Attributes, enable Mouse Support

With **PickerAttributes**, you can assign different properties and functions to the BootPicker. There are 5 parameters, each having it's own value/byte, which can be combined by simple adding them:

`1` = Custom Icons for Boot Entries </br>
`2` = Custom Titles for Boot Entries </br>
`4` = Predefined Label Images for Boot entries without custom entries </br>
`8` = Prefers Builtin icons for certain icon categories to match the theme style </br> `16` = Enable Mouse Cursor

**For Example:**

**PickerAttributes** = `17` –– Enables Custom Icons and Mouse Cursor (New default setting since OpenCore 0.6.7)</br>
**PickerAttributes** = `19`–– Enables Custom Icons, Custom Titles and Mouse Cursor.
</details>
<details>
<summary><strong>Customizing Boot Options</strong></summary>

## V. Customizing Boot Options

### Set default boot drive in BootPicker

To be able to set the boot drive in the BootPicker, enable the following options in the config:

**ShowPicker** = `Yes`</br>
**AllowSetDefault** = `Yes`

In the BootPicker: Select drive/partition, hold [CTRL] and press [ENTER]. After that this volume is always preselected.

### Enable Apple Hotkey functions

**PollAppleHotKeys** = `Yes`

Enables the key combinations known from Macs to use boot modes like Verbose, Safe and Single User Mode, etc. without having to set extra boot-args. For details see `Configuration.pdf` included in the OpenCore package.

### Accelerate boot (result will vary)

**ConnectDrivers** = `No`

If it takes a long time (8 seconds or longer) until the BootPicker appears after switching on the computer, this option can be used to shorten the waiting time - especially for notebooks. But then you have to live without the boot chime, because the audio driver AudioDxe.efi is not started in this case.

## Boot variants (Selection)

Change the following settings in the config to influence the boot process of OpenCore. There are certainly more options, but these seem to me to be the most common/useful.

#### **Manual selection of the OS without GUI (default)**

**PickerMode** = `Builtin`</br>
**ShowPicker** = `Yes`

#### **Manual selection of the OS with GUI (requires OpenCanopy and [Resources folder](https://github.com/acidanthera/OcBinaryData))**

Great for dual boot setups. Combine it with the`LauncherOption` `Full` or `Short`to protect you against Windows taking over your system.

**PickerMode** = `External`</br>
**ShowPicker** = `Yes`

#### Boot the OS automatically from volume defined as "Default" (no GUI)

**PickerMode** = `Default`</br> 
**ShowPicker** = `No`

#### **Start macOS automatically (no GUI, fast)**

The following settings will boot macOS from first APFS volume it finds. Combine it with the`LauncherOption` `Full` or `Short`to protect you against Windows taking over your system.

**PickerMode** = `BootApple`</br>
**ShowPicker** = `No`

This is a great option for Laptop users who run Windows and macOS from the same disk, but use macOS most of the time. It also prevents the pesky *WIndowsBootManager* from hi-jacking the top slot of the boot order which would give you a hard time trying to get back into macOS later on, if the BootPicker is disabled and you forgot to declare the macOS disk as the default boot volume – happens all the time…

If you want to boot Windows *properly*, you should boot it via the BIOS Boot Menu to bypass all the SSDTs being injected anyway. Because unlike Clover, OpenCore injects everything present and enabled in the ACPI Folder into any OS.
</details>
<details>
<summary><strong>Handling NVRAM Issues</strong></summary>

## VI. Resolving issues with NVRAM Reset

Certain BIOS variants can be badly affected by the integrated NVRAM reset tool of OpenCore. Symptoms: you can't get into the BIOS anymore or certain parameters in the NVRAM (like boot-args) are not applied or can't be deleted, etc. Older Lenovo Notebooks are affected by this a lot. Therefore, the OpenCore package also contains `CleanNvram.efi` under `Tools`, which should work better with such problematic BIOSes. So if you have problems with NVRAM reset, do the following:

* **AllowNvramReset** = `No` - Disables OpenCore's built-in NVRAM reset tool to avoid a duplicate entriy for CleanNVRAM
* Copy **CleanNvram.efi** to EFI > OC > Tools

Next, create a new snapshot of the config or add the tool manually to the config. If you want you can hide the entry in the BootPicker so that it only appears after pressing the space bar:

* **HideAuxiliary** = Yes</br>
* Under **Misc > Tools** find `CleanNvram` and set `Auxiliary` to **`Yes`**.

Otherwise, check if there might be a BIOS update available that fixes general problems. Especially ASUS boards with a Z79/Z99 chipset have problems with the NVRAM, which can only be fixed with a patched BIOS.
</details>
<details>
<summary><strong>Fixing falsely reported OpenCore version </strong></summary>

## VII. **Correct falsely reported OpenCore version**.

It can happen that the OpenCore version info stored in the NVRAM is not updated automatically and is therefore displayed incorrectly in Kext Updater and Hackintool. The problem was fixed in OC 0.6.7 by simply not writing the version info into NVRAM at all, but the wrong version will reside in NVRAM until you delete it.

To do this, create a new child element under **NVRAM > Delete > 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102**, call it `opencore-version` and save the config. After restarting, the correct OC version should be displayed again.
</details>
<details>
<summary><strong>Prohibit SMBIOS injection in other OSes</strong></summary>

## VIII. Prohibit SMBIOS injection in other OSes:

To avoid OpenCore from injecting SMBIOS Infos into Windows or other OSes causing issues with the registration, change the following settings:

**Kernel > Quirks > CustomSMBIOSGuid >** `True` (standard: `False`)</br>
**Platforminfo > UpdateSMBIOSMode >** `Custom` (standard: `Create`)

[SOURCE](https://github.com/dortania/OpenCore-Install-Guide/tree/master/clover-conversion#optional-avoiding-smbios-injection-into-other-oses)
</details>
<details>
<summary><strong>Sharing SMBIOS Infos between Clover and OpenCore</strong></summary>

## Sharing SMBIOS Infos between Clover and OpenCore

When switching between OpenCore and Clover, copying over your existing SMBIOS Infos from one Bootoader to the other can be a bit confusing because of naming differences as well as the number of fields available in both configs. 

So I had a look at my SMBIOS Infos using GenSMBIOS and found out which parameters belong to what in Clover and OpenCore.

Here's a table of the what is what in macSerial/GenSMBIOS, Clover and OpenCore

| MacSerial/GenSMBIOS | Clover Config       | OpenCore Config               |
|:--------------------|:--------------------|:------------------------------|
| Hardware UUID* | System Parameters > Custom UUID | N/A in PlatformInfo > Generic |
| Board ID | SMBIOS > Board-ID | N/A in PlatformInfo > Generic|
| Serial Number | SMBIOS > Serial Number | PlatformInfo > Generic > SystemSerialNumber|
| System ID | SMBIOS > Sm UUID | PlatformInfo > Generic > SystemUUID |
| ROM** 	  | Rt Variables > ROM | PlatformInfo > Generic > ROM |
|  MLB | SMBIOS > Board Serial Number | PlatformInfo > Generic > MLB |

**NOTE:**

 - *Hardware UUID: This is displayed under "About this Mac… > System report > Hardware" and should be identical to the information in GenSMBIOS if everything has been copied over correctly.
 -  **ROM: in Clover Configurator, select the option "from SMBIOS" and paste over your MAC Address

You know that the SMBIOS Infos are correct if you switch Bootloaders and the SMBIOS Infos listed in GenSMBIOS are still identical. Another indicator for successful transfer is that you don't have to re-enter the passwords of your E-Mail Accounts in the Mail App.

## 1-Click-Solution for Clover Users

If you've used GenSMBIOS prior to generate SMBIOS Infos and installed them into your system, you can select them in Clover Configurator to avoid SMBIOS Infos conflicts altogether. Under "Rt Variables" simply click on "from System" and you're good.
</details>
<details>
<summary><strong>Scan Policy Calculator</strong></summary>

## Online ScanPolicy Calculator
https://oc-scanpolicy.vercel.app/
</details>
