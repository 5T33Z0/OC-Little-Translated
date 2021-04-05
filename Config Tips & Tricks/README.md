# OpenCore Config Tipps and Tricks (by 5T33Z0)
A small collection of useful tipps and tricks for working with OpenCore's `config.plist`

## I. Checking config.plist for errors

Currently there are two automated methods to check your config.plist for errors:

1. **Online**: [OpenCore Sanity Checker](https://opencore.slowgeek.com/) is a useful site where you can check your config. Errors are highlighted in red and you can copy the link to the sanity check result and put it in a post to point out config problems. Unfortunately, the site hasn't been updated for a while and only fully supports OpenCore to version 0.6.6.

2. **Offline**: The OpenCore package also contains the folder `Utilities`. In it you will find `ocvalidate`. Drag this into Terminal, leave a blank space, drag in your config.plist next and press [ENTER]. It will show errors in the config and where they are. With the help of OCConfgCompare, Sample.plist and OpenCore Install Guide you can correct all errors quite fast. 

While Sanity Checker focuses on correct settings for the selected system, OC Validate additionally checks the syntax for errors. Therefore it makes sense to check the config in two steps: first online and then offline.

**CAUTION**: Don't use OpenCore Configurator for editing your `config.pllist` when using nightly builds of OpenCore. Because it automatically adds entries to the config which may have been removed oder relocated in the config. This results in errors when rebooting.

## II. Fixing Boot Problems

If the system won't boot despite correct boot and kernel settings and hangs directly at the boot logo without a progress bar, you should change the following settings:

**Misc > Security > SecureBootModel** = `Disabled`. I always had problems with this when this feature was set to `Default`. As soon as you need `Whatevergreen.kext` you can't use this feature. So disable it if you have problems booting.  

**Misc > Security > Vault** = `Optional` Disables File Vault. Can prevent system boot if it is set to "Secure" but File Vault encryption is not configured at all. Because it needs the generation of a key and a hash.

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

## IV. Adjust BootPicker Attributes, enable mouse support

With **PickerAttributes**, you can assign different properties and functions to the BootPicker. There are 5 parameters, each having it's own value/byte, which can be combined by simple adding them:

`1` = Custom Icons for Boot Entries </br>
`2` = Custom Titles for Boot Entries </br>
`4` = Predefined Label Images for Boot entries without custom entries </br>
`8` = Prefers Builtin icons for certain icon categories to match the theme style </br> `16` = Enable Mouse Cursor

**For Example:**

**PickerAttributes** = `17` –– Enables Custom Icons and Mouse Cursor (New default setting since OpenCore 0.6.7)
**PickerAttributes** = `19`–– Enables Custom Icons, Custom Titles and Mouse Cursor.

## V. Customizing Boot Options

### Set default boot drive in BootPicker

To be able to set the boot drive in the BootPicker, enable the following options in the config:

**ShowPicker** = `Yes`  
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

**PickerMode** = `Builtin`  
**ShowPicker** = `Yes`

#### **Manual selection of the OS with GUI (requires OpenCanopy and [Resources folder](https://github.com/acidanthera/OcBinaryData))**

Great for dual boot setups. Combine it with the`LauncherOption` `Full` or `Short`to protect you against Windows taking over your system.

**PickerMode** = `External`  
**ShowPicker** = `Yes`

#### Boot the OS automatically from volume defined as "Default" (no GUI)

**PickerMode** = `Default`  
**ShowPicker** = `No`

#### **Start macOS automatically (no GUI, fast)**

The following settings will boot macOS from first APFS volume it finds. Combine it with the`LauncherOption` `Full` or `Short`to protect you against Windows taking over your system.

**PickerMode** = `BootApple`  
**ShowPicker** = `No`

This is a great option for Laptop users who run Windows and macOS from the same disk, but use macOS most of the time. It also prevents the pesky *WIndowsBootManager* from hi-jacking the top slot of the boot order which would give you a hard time trying to get back into macOS later on, if the BootPicker is disabled and you forgot to declare the macOS disk as the default boot volume – happens all the time…

If you want to boot Windows *properly*, you should boot it via the BIOS Boot Menu to bypass all the SSDTs being injected anyway. Because unlike Clover, OpenCore injects everything present and enabled in the ACPI Folder into any OS.

## VI. Resolving issues with NVRAM Reset

Certain BIOS variants can be badly affected by the integrated NVRAM reset tool of OpenCore. Symptoms: you can't get into the BIOS anymore or certain parameters in the NVRAM (like boot-args) are not applied or can't be deleted, etc. Older Lenovo Notebooks are affected by this a lot. Therefore, the OpenCore package also contains `CleanNvram.efi` under `Tools`, which should work better with such problematic BIOSes. So if you have problems with NVRAM reset, do the following:

* **AllowNvramReset** = `No` - Disables OpenCore's built-in NVRAM reset tool to avoid a duplicate entriy for CleanNVRAM
* Copy **CleanNvram.efi** to EFI > OC > Tools

Next, create a new snapshot of the config or add the tool manually to the config. If you want you can hide the entry in the BootPicker so that it only appears after pressing the space bar:

* **HideAuxiliary** = Yes
* Under **Misc > Tools** find `CleanNvram` and set `Auxiliary` to **`Yes`**.

Otherwise, check if there might be a BIOS update available that fixes general problems. Especially ASUS boards with a Z79/Z99 chipset have problems with the NVRAM, which can only be fixed with a patched BIOS. 

## VII. **Correct falsely reported OpenCore version**.

It can happen that the OpenCore version info stored in the NVRAM is not updated automatically and is therefore displayed incorrectly in Kext Updater and Hackintool. The problem was fixed in OC 0.6.7 by simply not writing the version info into NVRAM at all, but the wrong version will reside in NVRAM until you delete it.

To do this, create a new child element under **NVRAM > Delete > 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102**, call it `opencore-version` and save the config. After restarting, the correct OC version should be displayed again.
