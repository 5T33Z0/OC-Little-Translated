# OpenCore Config Tips and Tricks
This section contains a small collection of useful configuration tips for OpenCore's `config.plist`.

<details>
<summary><b>TABLE of CONTENTS</b> (Click to reveal)</summary><br>
	
- [OpenCore Troubleshooting Quick Tips](#opencore-troubleshooting-quick-tips)
	- [Troubleshooting Workflow](#troubleshooting-workflow)
	- [`MinDate`/`MinVersion` settings for the APFS driver](#mindateminversion-settings-for-the-apfs-driver)
- [I. Updating config.plist and fixing errors](#i-updating-configplist-and-fixing-errors)
	- [Automated config upgrade (recommended)](#automated-config-upgrade-recommended)
	- [Manual upgrade and error correction (old)](#manual-upgrade-and-error-correction-old)
	- [A personal note on using Configurator Apps](#a-personal-note-on-using-configurator-apps)
- [II. Quick fixes for Boot Problems](#ii-quick-fixes-for-boot-problems)
- [III. Security Settings](#iii-security-settings)
	- [How to disable Single User Mode](#how-to-disable-single-user-mode)
	- [How to disable System Integrity Protection (SIP)](#how-to-disable-system-integrity-protection-sip)
- [IV. Adjust Boot Picker Attributes, enable Mouse Support](#iv-adjust-boot-picker-attributes-enable-mouse-support)
- [V. Customizing Boot Options](#v-customizing-boot-options)
	- [Set default boot drive in BootPicker](#set-default-boot-drive-in-bootpicker)
	- [Enable Apple Hotkey functions](#enable-apple-hotkey-functions)
	- [Accelerate boot (results will vary)](#accelerate-boot-results-will-vary)
	- [Boot variants (Selection)](#boot-variants-selection)
		- [Manual selection of the OS without GUI (default)](#manual-selection-of-the-os-without-gui-default)
		- [Manual selection of the OS with GUI (requires OpenCanopy and Resources folder)](#manual-selection-of-the-os-with-gui-requires-opencanopy-and-resources-folder)
		- [Boot the OS automatically from the "Default" volume (no GUI)](#boot-the-os-automatically-from-the-default-volume-no-gui)
		- [Skip the BootPicker to load macOS automatically](#skip-the-bootpicker-to-load-macos-automatically)
- [VI. Resolving issues with NVRAM](#vi-resolving-issues-with-nvram)
	- [Resetting NVRAM](#resetting-nvram)
		- [OC ≤ 0.8.3](#oc--083)
		- [OC ≥ 0.8.4](#oc--084)
		- [Keep Boot entries after NVRAM reset](#keep-boot-entries-after-nvram-reset)
	- [Fixing falsely reported OpenCore version](#fixing-falsely-reported-opencore-version)
- [VII. Prohibit SMBIOS injection into other OSes](#vii-prohibit-smbios-injection-into-other-oses)
- [VIII. Exchanging SMBIOS Data between OpenCore and Clover](#viii-exchanging-smbios-data-between-opencore-and-clover)
	- [Manual method](#manual-method)
		- [Troubleshooting](#troubleshooting)
	- [SMBIOS Data Import/Export with OCAT](#smbios-data-importexport-with-ocat)
	- [1-Click-Solution for Clover Users](#1-click-solution-for-clover-users)
- [Further Resources](#further-resources)

</details>

## OpenCore Troubleshooting Quick Tips

### Troubleshooting Workflow

The schematic below shows you how to approach troubleshooting your hhackintosh, if it does not boot.

![OpenCore Troubleshooting](https://user-images.githubusercontent.com/76865553/135234918-2d0ce665-9037-4dd6-b0f4-e2b54c081160.png)

Besides checking the obvious (like Booter, Kernel and UEFI Quirks), check the following settings:

- `UEFI/ConnectDrivers` = true
- `Misc/Security/SecureBootModel` = Disabled
- `Misc/security/Vault` = Optional
- `UEFI/APFS/MinDate` = -1
- `UEF/APFS/MinVersion` = -1
- Compare the structure of `UEFI/Drivers` with `sample.plist` from the OpenCore Package (format changed in OC 0.7.3).

For extensive troubleshooting please refer to Dortania's [Troubleshooting Guide](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/troubleshooting.html#table-of-contents).

### `MinDate`/`MinVersion` settings for the APFS driver
OpenCore introduced a new security feature in version 0.7.2 which prohibits the APFS driver from loading if it doesn't comply to a specific Date (`MinDate`) and Version and (`MinVersion`) in the  `UEFI/APFS` section.

The new default values `0`and `0` is for macOS Big Sur. So if you're running an older version of macOS, you won't see your drives. To disable this feature, enter `-1` and the APFS driver will load for any macOS version.

**Here's a list of supported Values:**

| `MinDate`| `MinVersion`     | Description                                  |
|:--------:|:----------------:|:---------------------------------------------|
| 0        | 0                | Default. Loads APFS driver for Big Sur+ only |
| -1       | -1               | Disabled. Allows any APFS driver             |
| 20210508 | 1677120009000000 | req. macOS ≥ Big Sur (11.4+)                 |
| 20200306 | 1412101001000000 | req. macOS ≥ Catalina (10.15.4+)             |
| 20190820 | 9452750070000000 | req. macOS ≥ Mojave (10.14.6)                |
| 20180621 | 7480770080000000 | req. macOS ≥ High Sierra (10.13.6)           |

**Source**: [Acidanthera](https://github.com/acidanthera/OpenCorePkg/blob/master/Include/Acidanthera/Library/OcApfsLib.h)

> [!IMPORTANT]
>
> For security concerns, you should change these values according to the version of macOS you are using.

## I. Updating config.plist and fixing errors

### Automated config upgrade (recommended)
Since OpenCore Auxiliary Tools [**OCAT**](https://github.com/ic005k/QtOpenCoreConfig) were released, the process of maintaining and updating your OpenCore config and files has become so much easier. It can automatically update/migrate any outdated config.plist to the latest structure and feature-set as well as update OpenCore, Drivers and Kexts and check the config for errors. Check my [OpenCore Update Guide](https://github.com/5T33Z0/OC-Little-Translated/tree/main/D_Updating_OpenCore) fore more details.

### Manual upgrade and error correction (old)
Prior to the advent of OCAT, I used to maintain and update my config with 4 additional tools to compare it with the latest sample.plist and update files. These included: 

- **OCConfigCompare** – To compare config differences between OpenCore's `sample.plist` and your `config.plist` 
- **KextUpdater** – For updating Kexts, Drivers, etc. 
- **ProperTree** – For editing the config and creating OC Snapshots 
- **OCValidate** – For checking the config for formal errors

Manually upgrading the config and files can be a really time consuming process. Since OCAT can do all of this with a few clicks now, I am glad I don't to do it any more – and you shouldn't either. 

### A personal note on using Configurator Apps
The recommendation "Don't use Configurators" has turned into a prejudice against all Configurator Apps which is wrong, imo. It stems from an era when the config.plist's structure underwent constant changes and developers of Configurator Apps had a hard time keeping up to implement the new features. This resulted in a lot of messed up configs and unbootable systems. So it was recommended to not use them.

Over time, this recommendation turned into a mindlessly repeated and blindly followed slogan without knowing what's going on in terms of development of these Apps. People quickly adopted the "*Don't*" part of the recommendation but forgot about the *Why* part even quicker. Since then, this recommendation has become a tabu – it's propagated by the most outspoken opinion leaders of the scene on places like forums, reddit and discord. On some discord servers you will even be discredited for even using screenshots of settings that show a Configurator App… this scene is great, isn't it?

While this recommendation remains true for Apps like OpenCore Configurator for example, OCAT is much more flexible when it comes to dealing with config changes. It can integrate new keys added to an existing section/array of the config automatically. No other Configurator App can do this as of yet! And since OCAT downloads the latest version of the sample.plist and OCValidate when updating, there's always a verification process in place that checks and ensures that the formal structure of the config is consistent. It also creates an automatic backup of your current config that you can always revert back to. 

So putting OCAT in the same category as other Configurator Apps doesn't do it justice and these so-called opinion leaders need to finally acknowledge it!

## II. Quick fixes for Boot Problems
If the system doesn't boot despite correct boot and kernel settings and hangs directly at the boot logo without a progress bar, you should change the following settings:

- **Misc/Security/SecureBootModel** = `Disabled`. If you have problems with booting using the`Default` value. For security concerns you should check if the chosen mac Model in `SystemProductName`supports Apple's Secure Boot feature, once your system is working. Refer to the Documentation.pdf for more details.
- **Misc/Security/Vault** = `Optional` Disables File Vault. Can prevent system boot if it is set to "Secure" but File Vault encryption is not configured at all. Because it needs the generation of a key and a hash.

If your macOS Partition (APFS) is not displayed in Bootpicker, do the following (OpenCore 0.7.2 and newer):

- **UEFI/APFS**: Change `MinDate` and `MinVersion` to `-1`. This disables APFS driver verification, so it loads no matter which version of macOS you are using (from macOS High Sierra onwards, because that's when APFS was introduced).

**BACKGROUND**: If you use an OS older than Big Sur and both values are set to default (`0`) you won't see your macOS Partition, because the APFS driver won't load. This is a security feature which should ensure that your macOS boots using a verified APFS driver. To maximize compatibility with older macOS versions, I would disable it during Install.

## III. Security Settings

### How to disable Single User Mode
You should deactivate the single user mode for security reasons, because it can be mis-used as a backdoor to bypass the password protection of the Admin account. To do this, enable the following option:

**Misc/Security/DisableSingleUser** = `Yes`

### How to disable System Integrity Protection (SIP)
1. To disable System Integrity Protection, add one of the following values to the config:

   **NVRAM/Add/7C436110-AB2A-4BBB-A880-FE41995C9F82** &rarr; change `csr-active-config` from `00000000`(SIP enabled) to:

   - `FF030000` (for High Sierra)
   - `EF070000` (for Mojave/Catalina)
   - `03080000` (for Big Sur and newer)
   - `EF0F0000` (for Big Sur and newer. Disables even more security features.)

   **NOTES**
   
   - Using `FF0F0000` for Big Sur (as suggested by Dortania's OpenCore Install Guide) is not recommended because it breaks System Update Notifications and incremental updates. For Big Sur and newer, use `67080000` instead.
   - Using `EF0F0000` does notify you about System Updates. But if the seal of the volume is broken however, it will download the complete installer (about 12 GB), instead of performing an incremental update which is not really desireable.
   - If you want to know how `csr-active-config` is calculated or if you want to calculate your own, check the [OpenCore Calcs](https://github.com/5T33Z0/OC-Little-Translated/tree/main/B_OC_Calculators) section for details.

2. To avoid the need of resetting NVRAM every time after you've changed  the csr value, add the following parameter to the config:

   **NVRAM/Delete/7C436110-AB2A-4BBB-A880-FE41995C9F82** &rarr; `csr-active-config`.

   This deletes the currently set `csr-active-config` value from NVRAM on reboot and replaces it with the value stored under "NVRAM > Add…". This is necessary to apply the new value if you have changed it. Otherwise you would have to use "Reset NVRAM". 

   To test if the correct settings were applied after reboot, type `csrutil status` into the terminal after reboot. The result should look something like this (for `03080000`):

	```
	Configuration:
	Apple Internal: disbaled
	Kext Signing: disabled
	Filesystem Protections: disabled
	Debugging Restrictions: enabled
	DTrace Restrictions: enabled
	NVRAM Protections: enabled
	BaseSystem Verification: enabled
	```
	**NOTE**: Check ["`csr-active-config` flags explained"](https://github.com/5T33Z0/OC-Little-Translated/blob/main/B_OC_Calculators/SIP_Flags_Explained.md) to figure out how this bitmask works.

## IV. Adjust Boot Picker Attributes, enable Mouse Support

With **PickerAttributes**, you can customize the look and feel of the BootPicker. There are currently 8 parameters which can be combined by simple adding their values:

`1` = Enables custom icon support for Boot entries </br>
`2` = Enables custom titles for Boot Entries </br>
`4` = Predefined Label Images for Boot entries without custom entries </br>
`8` = Prefers Builtin icons for certain icon categories to match the theme style </br> `16` = Enables mouse cursor</br>
`32` = Enables additional timing and debug information in Builtin picker (DEBUG and NOOPT builds only)</br>
`64` = Minimal GUI (no Shutdown and Restart buttons)</br>
`128` = Enables "Flavor Icons" which provide flexible boot entry content description (refer to `Documentation.pdf` for details)

**Examples:**

`17` &rarr; Enables custom icons and the mouse cursor (bew default since OpenCore 0.6.7)</br>
`19` &rarr; Enables custom icons, custom titles and the mouse cursor</br>
`147` &rarr; Enables custom icons, custom titles, the mouse cursor and Flavour Icons. Recommended setting when using custom themes.

## V. Customizing Boot Options

### Set default boot drive in BootPicker

To be able to set the boot drive in the BootPicker, enable the following options in the config:

- **ShowPicker** = `Yes`</br>
- **AllowSetDefault** = `Yes`

In **BootPicker**: 

- Select drive/partition
- Hold <kbd>Ctrl</kbd> and press <kbd>Enter</kbd> 

After that this volume is always preselected (until NVRAM is reset).

### Enable Apple Hotkey functions

**PollAppleHotKeys** = `Yes` &rarr; Enables keyboard shortcuts known from Macs to use different boot modes like Verbose, Safe or Single User Mode, etc. without having to set extra boot-args. 

**Examples**:

- Enter <kbd>CMD</kbd><kbd>V</kbd> before starting macOS boots macOS in Verbose mode. So no need to add `-v` to the boot-args.
- Holding Shift (<kbd>⇧</kbd>) will boot macOS in Safe Mode

For more details check the `Configuration.pdf` included in the OpenCore package.

### Accelerate boot (results will vary)

**ConnectDrivers** = `No`

If it takes a long time (8 seconds or longer) until the BootPicker appears after switching on the computer, this option can be used to shorten the waiting time - especially for notebooks. But then you have to live without the boot chime, because the audio driver `AudioDxe.efi` is not started in this case. 

> [!CAUTION]
> 
> Before installing macOS from USB flash drive, `ConnectDrivers` needs to be enabled, otherwise you won't see the drive in the bootpicker.

### Boot variants (Selection)

Change the following settings in the config to influence the boot process. There are certainly more options, but these seem to me to be the most common/useful.

#### Manual selection of the OS without GUI (default)

**PickerMode** = `Builtin`</br>
**ShowPicker** = `Yes`

#### Manual selection of the OS with GUI (requires OpenCanopy and [Resources folder](https://github.com/acidanthera/OcBinaryData))

Great for dual boot setups. Combine with `LauncherOption` `Full` or `Short`to protect you against Windows Boot Manager taking over the first slot of the bootmenu.

**PickerMode** = `External`</br>
**ShowPicker** = `Yes`

**NOTE**: If `PollAppleHotkeys` is enabled, holding `X` after turning on the system skips the bootpicker and automatically boots into the default volume.

#### Boot the OS automatically from the "Default" volume (no GUI)

**PickerMode** = `Default`</br> 
**ShowPicker** = `No`

> [!CAUTION]
> 
> This option can be problematic if have Windows installed. Beecaus if you perform an NVRAM reset and `LauncherPath` is not enabled, Windows might take over the first slot of boot order and then you cannot enter OC's BootPicker any more.

#### Skip the BootPicker to load macOS automatically

The following settings will boot macOS from first APFS volume it finds. Combine it with `LauncherOption` `Full` or `Short`to prohobit Windows Boot Manager from taking over the first slot of the bootmenu.

**Prerequisites**: enabled `PollAppleHotkeys` 

**PickerMode** = `Builtin`</br>
**ShowPicker** = `Yes`

> [!NOTE]
> 
> Hold `X` after turning on the system to directly boot into macOS – even if you get a black screen instead of the BootPicker.

This is a reliably workaround for this issue:

- Instead of the BootPicker, there's only a black screen (seems to be related to GOP Rendering)
- 5 secends later (default delay) the system boots into Windows becasue it inhibits the first Slot in the BootPicker

:bulb: If you want to bypass all the SSDTs injections into Windows, you either need to boot it via the BIOS Boot Menu or use [OpenCore_NO_ACPI](https://github.com/5T33Z0/OC-Little-Translated/tree/main/O_OC_NO_ACPI). Because unlike Clover, OpenCore injects everything present and enabled in the ACPI Folder into any OS.

## VI. Resolving issues with NVRAM

### Resetting NVRAM

Certain BIOS variants can be badly affected by the integrated NVRAM reset tool of OpenCore. Symptoms: you can't get into the BIOS anymore or certain parameters in the NVRAM (like boot-args) are not applied or can't be deleted, etc. Older Lenovo Notebooks are affected by this a lot. 

Therefore, the OpenCore package also contains an additional driver `ResetNvramEntry.efi` (since OC 0.8.4; was a tool called `CleanNvram.efi` previously) which works better with such problematic BIOSes. So if you have problems with NVRAM reset, do the following:

#### OC ≤ 0.8.3

* Set **Misc/Security/AllowNvramReset** to `No` &rarr; Disables OpenCore's built-in NVRAM reset tool to avoid a duplicate entry for "CleanNVRAM" in Boot Picker
* Copy **CleanNvram.efi** to `EFI/OC/Tools`
* Add it to the `Misc/Tools`section of the `config.plist` and enable it.
* Set **HideAuxiliary** = `Yes` (under `Misc/Boot`)
* Under **Misc/Tools**, find `CleanNvram` and change `Auxiliary` to `Yes`.
* Save and reboot.
* Press Space Bar in Boot Picker to show the "CleanNvram" entry.
* Highlight the icon and press enter to reset NVRAM.

> [!NOTE]
> 
> Since OC 0.8.4, the previous options for resetting NVRAM are deprecated. So delete: 
> 
> - `AllowNvranReset` key from `config.plist`
> - `CleanNvramReset.efi` from `config.plist` (Misc/Tools)
> - `CleanNvramReset.efi` from `EFI/OC/Tools` 

#### OC ≥ 0.8.4
To enable NVRAM Reset on OC 0.8.4 and newer, do the following:

* Add **ResetNvramEntry.efi** to `EFI/OC/Drivers`
* Add **ResetNvramEntry.efi** to `config.plist` (under `UEFI/Drivers`) and enable it.
* Save and reboot.
* Press Space Bar in Boot Picker to show the "ResetNvram" entry.
* Highlight the icon and press enter to reset NVRAM.

#### Keep Boot entries after NVRAM reset
If you reset NVRAM, usually the order of the BIOS boot menu entries resets and Windows Boot Manager takes over the first slot or the boot section. To prevent this, do the following:

- Go to `UEFI/Drivers/ResetNvramEntry.efi`
- Add `--preserve-boot` to the `Arguments` field

### Fixing falsely reported OpenCore version

It can happen that the OpenCore version info stored in the NVRAM is not updated automatically and is therefore displayed incorrectly in Kext Updater or Hackintool. The problem was fixed in OC 0.6.7 by simply not writing the version info into NVRAM at all, but the wrong version will reside in NVRAM until deletion. To fix it, do the following:

- Create a new child element under **NVRAM/Delete/4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102**
- call it `opencore-version` 
- Save the config and reboot
After restarting, the correct OC version should be displayed and you can delete the entry again.

Alternatively, you can use Terminal to delete the key (no restart required):

```terminal
sudo nvram -d 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version
```

## VII. Prohibit SMBIOS injection into other OSes

To avoid OpenCore from injecting SMBIOS Infos into Windows or other OSes causing issues with the registration, change the following settings:

**Kernel/Quirks/CustomSMBIOSGuid**: `True` (standard: `False`)</br>
**Platforminfo/UpdateSMBIOSMode**: `Custom` (standard: `Create`)

**SOURCE**: [Avoiding SMBIOS injection into other OSes](https://github.com/dortania/OpenCore-Install-Guide/tree/master/clover-conversion#optional-avoiding-smbios-injection-into-other-oses)

## VIII. Exchanging SMBIOS Data between OpenCore and Clover
### Manual method
Exchanging existing SMBIOS data back and forth between an OpenCore and a Clover config can be a bit confusing since both use different names and locations for data fields. 

Transferring the data correctly is important because otherwise you have to enter your AppleID and Password again which in return will register your computer as a new device in the Apple Account. As long as there is a mismatch betwenne the two SMBIOS datasets, you have to go through the 2-way-authenticatin process every single time you switch between OpenCore and Clover, which is incredibly annoying. So in order to prevent this, you have to do the following:

1. Copy the Data from the following fields to Clover Configurator's "SMBIOS" and "RtVariables" sections:
	PlatformInfo/Generic (OpenCore)| SMBIOS (Clover)      |
	|------------------------------|----------------------|
	| SystemProductName            | ProductName          |
	| SystemUUID                   | SmUUID               |
	| ROM                          | ROM (under `RtVariables`). Select "from SMBIOS" and paste the ROM address|
	| N/A in "Generic"             | Board-ID             |
	| SystemSerialNumber           | Serial Number        |
	| MLB                          | 1. Board Serial Number (under `SMBIOS`)</br>2. MLB (under `RtVariables`)|
	![OC](https://github.com/user-attachments/assets/8525a2a6-fc09-4447-9655-8d8f23f6736b) | ![Clover](https://github.com/user-attachments/assets/2fd0f0a2-72ac-42b6-b33a-bc14ca8352c8)
3. Next, tick the "Update Firmware Only" box.
4. From the Dropdown Menu next to it to, select the Mac model you used for "ProductName". This updates other fields like BIOS and Firmware.
5. Save config and reboot with Clover.

You know that the SMBIOS data has bee transferred correctly, if you don't have to re-enter your Apple-ID and password.

#### Troubleshooting
If you have to re-enter your Apple ID Password after changing from OpenCore to Clover or vice versa, the used SMBIOS Data is not identical, so you have to figure out where the mismatch is. You can use Hackintool to do so:

- Mount the EFI
- Open the config for the currently used Boot Manager
- Run Hackintool. The "System" section shows the currently used SMBIOS Data: </br> ![SYSINFO](https://user-images.githubusercontent.com/76865553/166119425-8970d155-b546-4c91-8daf-ec308d16916f.png)
- Check if the framed parameters match the ones in your config.
- If they don't, correct them and use the ones from Hackintool.
- If they do mach the values used in your config, open the config from your other Boot Manager and compare the data from Hackintool again and adjust the data accordingly.
- Save the config and reboot.
- Change to the other Boot Manager and start macOS.
- If the data is correct you won't have to enter your Apple ID Password again (double-check in Hackintool to verify).

### SMBIOS Data Import/Export with OCAT
Besides manually copying over SMBIOS data from your OpenCore to your Clover config and vice versa, you could use [**OpenCore Auxiliary Tools**](https://github.com/ic005k/OCAuxiliaryTools/releases) instead, which has a built-in import/export function to import SMBIOS Data from Clover as well as exporting function SMBIOS data into a Clover config:

![ocat](https://user-images.githubusercontent.com/76865553/162971063-cbab15fa-4c83-4013-a732-5486d4f00e31.png)

> [!IMPORTANT]
> 
> - If you did everything correct, you won't have to enter your AppleID Password after switching Boot Managers and macOS will let you know, that "This AppleID is now used with this device" or something like that.
> - But if macOS asks for your AppleID Password and Mail passwords etc., you did something wrong. In this case you should reboot into OpenCore instead and check again. Otherwise, you are registering your computer as a new/different Mac.

### 1-Click-Solution for Clover Users
If you've used the real MAC Address of your Ethernet Controller ("ROM") when generating your SMBIOS Data for your OpenCore config, you can avoid possible SMBIOS conflicts altogether. In the "Rt Variables" section, click on "from System" and you should be fine!

## Further Resources
- Check Dortania's excellent OpenCore [Post-Install Guide](https://github.com/dortania/OpenCore-Post-Install) for fixing all sorts of issues.
- The **Documentation.pdf** contained in the OpenCore Package also contains a Tips & Tricks chapter
