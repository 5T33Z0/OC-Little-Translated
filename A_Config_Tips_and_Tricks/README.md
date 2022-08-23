# OpenCore Config Tips and Tricks

This section contains a small collection of useful tips and tricks for working with OpenCore's `config.plist`. For updating OpenCore easy and reliably to the latest version, follow my [OpenCore Update Guide](https://github.com/5T33Z0/OC-Little-Translated/tree/main/D\_Updating\_OpenCore).

**TABLE of CONTENTS**

* [OpenCore Troubleshooting Workflow](https://user-images.githubusercontent.com/76865553/180989260-3cf42cd8-a5cb-4482-9a54-240db9429264.png)\

  * [MinDate / MinVersion settings explained](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#mindateminversion-settings-for-the-apfs-driver)\

* I. [Updating config.plist and fixing errors](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#i-updating-configplist-and-fixing-errors)\

  * [Automated method using OCAT](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#automated-config-upgrade-recommended)
  * [Manual method (old)](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#manual-upgrade-and-error-correction-old)
* II. [Fixing Boot Issues](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#ii-quick-fixes-for-boot-problems)\

* III. [Security Settings](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#iii-security-settings)\

  * [How to disable Single User Mode](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#how-to-disable-single-user-mode)
  * [How to disable System Integrity Protection](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#how-to-disable-system-integrity-protection-sip)
* IV. [Adjusting Boot Picker Attributes](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#iv-adjust-boot-picker-attributes-enable-mouse-support)
* V. [Customizing Boot Options](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#v-customizing-boot-options)
  * [Defining the default Volume in Boot Picker](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#set-default-boot-drive-in-bootpicker)
  * [Enabling Apple Hotkeys Support](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#enable-apple-hotkey-functions)
  * [Accelerate Boot](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#accelerate-boot-results-will-vary)
  * [Boot Variants](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#boot-variants-selection)
    * [GUI disabled, manual drive selection](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#manual-selection-of-the-os-without-gui-default)
    * [GUI enabled, manual drive selection](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#manual-selection-of-the-os-with-gui-requires-opencanopy-and-resources-folder)
    * [No GUI, automatic boot from default volume](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#boot-the-os-automatically-from-volume-defined-as-default-no-gui)
    * [Boot macOS automatically, no GUI](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#start-macos-automatically-no-gui-fast)
* VI. [Resolving NVRAM issues](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#vi-resolving-issues-with-nvram)
  * [Fixing falsely reported OpenCore Version](./#fixing-falsely-reported-opencore-version)
* VII. [Prohibit SMBIOS Injection into other Operating Systems](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#vii-prohibit-smbios-injection-in-other-oses)
* VIII. [Exchanging SMBIOS Data between OpenCore and Clover](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#viii-exchanging-smbios-data-between-opencore-and-clover)
  * [Manual method](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#manual-method)
  * [Automated method, using OCAT](https://github.com/5T33Z0/OC-Little-Translated/tree/main/A\_Config\_Tips\_and\_Tricks#smbios-data-importexport-with-ocat)

## OpenCore Troubleshooting Quick Tips

Besides checking the obvious (like Booter, Kernel and UEFI Quirks), check the following Settings:

* `ConnectDrivers` = true
* `SecureBootModel` = Disabled
* `Vault` = Optional
* `MinDate` = -1
* `MinVersion` = -1
* Compare the structure of `UEFI > Drivers` with sample.plist (format changed in OC 0.7.3)
* **OC Troubleshooting Workflow**: ![OpenCore Troubleshooting](https://user-images.githubusercontent.com/76865553/135234918-2d0ce665-9037-4dd6-b0f4-e2b54c081160.png)

### `MinDate`/`MinVersion` settings for the APFS driver

OpenCore introduced a new security feature in version 0.7.2 which prohibits the APFS driver from loading if it doesn't comply to a specific Date and Version (`MinDate` and `MinVersion`).

The new default values `0`and `0` is for macOS Big Sur. So if you're running an older version of macOS, you won't see your drives. To disable this feature, enter `-1` and the APFS driver will load for any macOS version.

**Here's a list of supported Values:**

| `MinDate` |   `MinVersion`   | Description                                  |
| :-------: | :--------------: | -------------------------------------------- |
|     0     |         0        | Auto. Allows APFS driver in macOS ≥ Big Sur) |
|     -1    |        -1        | Disabled. Allows any APFS driver             |
|  20210101 | 1600000000000000 | Default                                      |
|  20210508 | 1677120009000000 | req. macOS ≥ Big Sur (11)                    |
|  20200306 | 1412101001000000 | req. macOS ≥ Catalina (10.15)                |
|  20190820 | 9452750070000000 | req. macOS ≥ Mojave (10.14)                  |
|  20180621 | 7480770080000000 | req. macOS ≥ High Sierra (10.13)             |

**Source**: [Acidanthera](https://github.com/acidanthera/OpenCorePkg/blob/master/Include/Acidanthera/Library/OcApfsLib.h)

**IMPORTANT**: For security reasons, you should change these values according to the version of macOS you are using.

## I. Updating config.plist and fixing errors

### Automated config upgrade (recommended)

Since OpenCore Auxiliary Tools [**OCAT**](https://github.com/ic005k/QtOpenCoreConfig) were released, the process of maintaining and updating your OpenCore config and files has become much easier. It can automatically update/migrate any outdated config.plist to the latest structure and feature-set as well as update OpenCore, Drivers and Kexts and check the config for errors. Check my [OpenCore Update Guide](https://github.com/5T33Z0/OC-Little-Translated/tree/main/D\_Updating\_OpenCore) fore more details.

### Manual upgrade and error correction (old)

Prior to the advent of OCAT, I used to maintain and update my config with 4 additional tools to compare with the latest sample.plist and update files. These included: OCConfigCompare (to compare config differences), KextUpdater (for downloading Kexts, Drivers, etc.), ProperTree (for creating snapshots editing the config) and OCValidate (for checking the config). This was a really time consuming process and I am glad, I don't have to do this any more.

## II. Quick fixes for Boot Problems

If the system doesn't boot despite correct boot and kernel settings and hangs directly at the boot logo without a progress bar, you should change the following settings:

* **Misc/Security/SecureBootModel** = `Disabled`. If you have problems with booting using the`Default` value. For security concerns you should check if the chosen mac Model in `SystemProductName`supports Apple's Secure Boot feature, once your system is working. Refer to the Documentation.pdf for more details.
* **Misc/Security/Vault** = `Optional` Disables File Vault. Can prevent system boot if it is set to "Secure" but File Vault encryption is not configured at all. Because it needs the generation of a key and a hash.

If your macOS Partion (APFS) is not displayed in Bootpicker, do the following (OpenCore 0.7.2 and newer):

* **UEFI/APFS**: Change `MinDate` and `MinVersion` to `-1`. This disables APFS driver verification, so it loads no matter which version of macOS you are using (from macOS High Sierra onwards, because that's when APFS was introduced).

**BACKGROUND**: If you use an OS older than Big Sur and both values are set to default (`0`) you won't see your macOS Partition, because the APFS driver won't load. This is a security feature which should ensure that your macOS boots using a verified APFS driver. To maximize compatibility with older macOS versions, I would disable it during Install.

## III. Security Settings

### How to disable Single User Mode

You should deactivate the single user mode for security reasons, because it can be mis-used as a backdoor to bypass the password protection of the Admin account. To do this, enable the following option:

**Misc/Security/DisableSingleUser** = `Yes`

### How to disable System Integrity Protection (SIP)

1.  To disable System Integrity Protection, add one of the following values to the config:

    **NVRAM/Add/7C436110-AB2A-4BBB-A880-FE41995C9F82** → change `csr-active-config` from `00000000`(SIP enabled) to:

    * `FF030000` (for High Sierra)
    * `EF070000` (for Mojave/Catalina)
    * `67080000` (for Big Sur and newer)
    * `EF0F0000` (for Big Sur and newer. Disables even more security features.)

    **NOTES**

    * Using `FF0F0000` for Big Sur and as suggested by Dortania's OpenCore Install Guide is not recommended since it prevents System Update notifications. In Big Sur, _authenticated root_ has been added to SIP, resulting in a different value of `0x867` for csr-active config. In OpenCore this translates to `67080000`.
    * Using `EF0F0000` does notify you about System Updates. If the seal of the volume is broken however, it will download the complete installer (about 12 GB) instead of performing an incremetal update.
    * If you want to know how `csr-active-config` is calculated or if you want to calculate your own, check the [OpenCore Calcs](https://github.com/5T33Z0/OC-Little-Translated/tree/main/B\_OC\_Calculators) section for details.
2.  To avoid the need of resetting NVRAM every time after you've changed the csr value, add the following parameter to the config:

    **NVRAM/Delete/7C436110-AB2A-4BBB-A880-FE41995C9F82** → `csr-active-config`.

    This deletes the current csr value from the NVRAM on reboot and replaces it with the value stored under "NVRAM > Add…". This is Very useful if you have different macOS installs which use different CSR values.

    To test if the correct settings were applied after reboot, type `csrutil status` into the terminal after reboot. The result should look something like this:

    ```
     Configuration:
      Apple Internal: enabled
      Kext Signing: disabled
      Filesystem Protections: disabled
      Debugging Restrictions: disabled
      DTrace Restrictions: disabled
      NVRAM Protections: disabled
      BaseSystem Verification: disabled
    ```

## IV. Adjust Boot Picker Attributes, enable Mouse Support

With **PickerAttributes**, you can assign different properties and functions to the BootPicker. There are 5 parameters, each having its own value/byte, which can be combined by simple adding them:

`1` = Custom Icons for Boot Entries\
`2` = Custom Titles for Boot Entries\
`4` = Predefined Label Images for Boot entries without custom entries\
`8` = Prefers Builtin icons for certain icon categories to match the theme style\
`16` = Enable Mouse Cursor

**For Example:**

**PickerAttributes** = `17` –– Enables Custom Icons and Mouse Cursor (New default setting since OpenCore 0.6.7)\
**PickerAttributes** = `19`–– Enables Custom Icons, Custom Titles and Mouse Cursor.

## V. Customizing Boot Options

### Set default boot drive in BootPicker

To be able to set the boot drive in the BootPicker, enable the following options in the config:

**ShowPicker** = `Yes`\
**AllowSetDefault** = `Yes`

In the BootPicker: Select drive/partition, hold \[CTRL] and press \[ENTER]. After that this volume is always preselected.

### Enable Apple Hotkey functions

**PollAppleHotKeys** = `Yes`

Enables keyboard shortcuts known from Macs to use different boot modes like Verbose, Safe or Single User Mode, etc. without having to set extra boot-args. For example, you can enter CMD+V before starting macOS and it will then boot in verbose mode. So no need to add `-v` to the boot-args.

For more details check the `Configuration.pdf` included in the OpenCore package.

### Accelerate boot (results will vary)

**ConnectDrivers** = `No`

If it takes a long time (8 seconds or longer) until the BootPicker appears after switching on the computer, this option can be used to shorten the waiting time - especially for notebooks. But then you have to live without the boot chime, because the audio driver AudioDxe.efi is not started in this case.

**CAUTION**: Before updating macOS via USB flash drive, `ConnectDrivers` needs to be enabled, otherwise you won't see the drive in the bootpicker.

### Boot variants (Selection)

Change the following settings in the config to influence the boot process of OpenCore. There are certainly more options, but these seem to me to be the most common/useful.

#### **Manual selection of the OS without GUI (default)**

**PickerMode** = `Builtin`\
**ShowPicker** = `Yes`

#### **Manual selection of the OS with GUI (requires OpenCanopy and** [**Resources folder**](https://github.com/acidanthera/OcBinaryData)**)**

Great for dual boot setups. Combine it with the`LauncherOption` `Full` or `Short`to protect you against Windows taking over your system.

**PickerMode** = `External`\
**ShowPicker** = `Yes`

#### Boot the OS automatically from volume defined as "Default" (no GUI)

**PickerMode** = `Default`\
**ShowPicker** = `No`

#### **Start macOS automatically (no GUI, fast)**

The following settings will boot macOS from first APFS volume it finds. Combine it with the`LauncherOption` `Full` or `Short`to protect you against Windows taking over the bootloader.

**Prerequisites**: enabled `PollAppleHotkeys`

**PickerMode** = `Apple`\
**ShowPicker** = `No`

**NOTE**: Hold `X` after turning on the system to directly boot into macOS

This is a great option for Laptop users who run Windows and macOS from the same disk, but use macOS most of the time. It also prevents the pesky _WIndowsBootManager_ from hi-jacking the top slot of the boot order which would give you a hard time trying to get back into macOS later on, if the BootPicker is disabled and you forgot to declare the macOS disk as the default boot volume – happens all the time…

If you want to boot Windows _properly_, you should boot it via the BIOS Boot Menu to bypass all the SSDTs being injected anyway. Because unlike Clover, OpenCore injects everything present and enabled in the ACPI Folder into any OS.

## VI. Resolving issues with NVRAM

Certain BIOS variants can be badly affected by the integrated NVRAM reset tool of OpenCore. Symptoms: you can't get into the BIOS anymore or certain parameters in the NVRAM (like boot-args) are not applied or can't be deleted, etc. Older Lenovo Notebooks are affected by this a lot. Therefore, the OpenCore package also contains `CleanNvram.efi` under `Tools`, which should work better with such problematic BIOSes. So if you have problems with NVRAM reset, do the following:

* **AllowNvramReset** = `No` - Disables OpenCore's built-in NVRAM reset tool to avoid a duplicate entry for CleanNVRAM
* Copy **CleanNvram.efi** to EFI > OC > Tools

Next, create a new snapshot of the config or add the tool manually to the config. If you want you can hide the entry in the BootPicker so that it only appears after pressing the space bar:

* **HideAuxiliary** = Yes\

* Under **Misc > Tools** find `CleanNvram` and set `Auxiliary` to **`Yes`**.

Otherwise, check if there might be a BIOS update available that fixes general problems. Especially ASUS boards with a Z79/Z99 chipset have problems with the NVRAM, which can only be fixed with a patched BIOS.

### Fixing falsely reported OpenCore version

It can happen that the OpenCore version info stored in the NVRAM is not updated automatically and is therefore displayed incorrectly in Kext Updater or Hackintool. The problem was fixed in OC 0.6.7 by simply not writing the version info into NVRAM at all, but the wrong version will reside in NVRAM until deletion. To fix it, do the following:

* Create a new child element under **NVRAM > Delete > 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102**
* call it `opencore-version`
* Save the config and reboot After restarting, the correct OC version should be displayed and you can delete the entry again.

Alternatively, you can use Terminal to delete the key (no restart required):

`sudo nvram -d 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version`

## VII. Prohibit SMBIOS injection in other OSes:

To avoid OpenCore from injecting SMBIOS Infos into Windows or other OSes causing issues with the registration, change the following settings:

**Kernel > Quirks > CustomSMBIOSGuid >** `True` (standard: `False`)\
**Platforminfo > UpdateSMBIOSMode >** `Custom` (standard: `Create`)

[SOURCE](https://github.com/dortania/OpenCore-Install-Guide/tree/master/clover-conversion#optional-avoiding-smbios-injection-into-other-oses)

## VIII. Exchanging SMBIOS Data between OpenCore and Clover

### Manual method

Exchanging existing SMBIOS data back and forth between an OpenCore and a Clover config can be a bit confusing since both use different names and locations for data fields.

Transferring the data correctly is important because otherwise you have to enter your AppleID and Password again which in return will register your computer as a new device in the Apple Account. On top of that you have to re-enter and 2-way-authenticate the system every single time you switch between OpenCore and Clover, which is incredibly annoying. So in order to prevent this, you have to do the following:

1. Copy the Data from the following fields to Clover Configurator's "SMBIOS" and "RtVariables" sections:

| PlatformInfo/Generic (OpenCore) | SMBIOS (Clover)                                                                                      |
| ------------------------------- | ---------------------------------------------------------------------------------------------------- |
| SystemProductName               | ProductName                                                                                          |
| SystemUUID                      | SmUUID                                                                                               |
| ROM                             | ROM (under `RtVariables`). Select "from SMBIOS" and paste the ROM address                            |
| N/A in "Generic"                | Board-ID                                                                                             |
| SystemSerialNumber              | Serial Number                                                                                        |
| MLB                             | <p>1. Board Serial Number (under <code>SMBIOS</code>)<br>2. MLB (under <code>RtVariables</code>)</p> |

1. Next, tick the "Update Firmware Only" box.
2. From the Dropdown Menu next to it to, select the Mac model you used for "ProductName". This updates other fields like BIOS and Firmware.
3. Save config and reboot with Clover.

You know that the SMBIOS data has bee transferred correctly, if you don't have to re-enter your Apple-ID and password.

#### Troubleshooting

If you have to re-enter your Apple ID Password after changing from OpenCore to Clover or vice versa, the used SMBIOS Data is not identical, so you have to figure out where the mismatch is. You can use Hackintool to do so:

* Mount the EFI
* Open the config for the currently used Boot Manager
* Run Hackintool. The "System" section shows the currently used SMBIOS Data:\
  ![SYSINFO](https://user-images.githubusercontent.com/76865553/166119425-8970d155-b546-4c91-8daf-ec308d16916f.png)
* Check if the framed parameters match the ones in your config.
* If they don't, correct them and use the ones from Hackintool.
* If they do mach the values used in your config, open the config from your other Boot Manager and compare the data from Hackintool again and adjust the data accordingly.
* Save the config and reboot.
* Change to the other Boot Manager and start macOS.
* If the data is correct you won't have to enter your Apple ID Password again (double-check in Hackintool to verify).

### SMBIOS Data Import/Export with OCAT

Besides manually copying over SMBIOS data from your OpenCore to your Clover config and vice versa, you could use [**OpenCore Auxiliary Tools**](https://github.com/ic005k/OCAuxiliaryTools/releases) instead, which has a built-in import/export function to import SMBIOS Data from Clover as well as exporting function SMBIOS data into a Clover config:

![ocat](https://user-images.githubusercontent.com/76865553/162971063-cbab15fa-4c83-4013-a732-5486d4f00e31.png)

**IMPORTANT**

* If you did everything correct, you won't have to enter your AppleID Password after switching Boot Managers and macOS will let you know, that "This AppleID is now used with this device" or something like that.
* But if macOS asks for your AppleID Password and Mail passwords etc., you did something wrong. In this case you should reboot into OpenCore instead and check again. Otherwise, you are registering your computer as a new/different Mac.

### 1-Click-Solution for Clover Users

If you've used the real MAC Address of your Ethernet Controller ("ROM") when generating your SMBIOS Data for your OpenCore config, you can avoid possible SMBIOS conflicts altogether. In the "Rt Variables" section, click on "from System" and you should be fine!
