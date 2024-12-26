# Modifying PS/2 Keyboard mappings and brightness shortcut keys

- [Description](#description)
  - [Update \[September 30, 2020\]:](#update-september-30-2020)
- [Requirements and Preparations](#requirements-and-preparations)
  - [About PS/2 and ABD Scan Codes](#about-ps2-and-abd-scan-codes)
  - [Enabling keyboard scan codes](#enabling-keyboard-scan-codes)
    - [Method 1: Using Terminal](#method-1-using-terminal)
    - [Method 2: Enabling Log Scan Codes in `VoodooPS2Keyboard.kext` (recommended)](#method-2-enabling-log-scan-codes-in-voodoops2keyboardkext-recommended)
- [Key mapping principle](#key-mapping-principle)
    - [PS2 Scan Code to PS2 Scan Code](#ps2-scan-code-to-ps2-scan-code)
    - [PS2 Scan Code to ADB Scan Code](#ps2-scan-code-to-adb-scan-code)
  - [NOTES](#notes)
- [Credits and Resources](#credits-and-resources)

## Description
Keyboard keys can be re-mapped for triggering different keys than the ones that are actually pressed. Function keys like `F2` can be re-mapped to triggering `F10`, for example. But beware that *only* keys that can capture **PS2 Scan Code** under macOS can be re-mapped! An in-depth example from a Lenovo ThinkPad utilizing this technique and [ACPI Debugging](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00_ACPI/ACPI_Debugging) can be found [here](https://github.com/5T33Z0/OC-Little-Translated/blob/main/05_Laptop-specific_Patches/Fixing_Keyboard_Mappings_and_Brightness_Keys/Customizing_ThinkPad_Keyboard_Shortcuts.md).

> [!CAUTION]
> 
> Logging Keyboard Scan Codes does no longer work on macOS Big Sur and newer. There have been reports [here](https://github.com/acidanthera/bugtracker/issues/872), [here](https://github.com/daliansky/OC-little/issues/46) and [here](https://github.com/5T33Z0/OC-Little-Translated/issues/92#issuecomment-1848874053). Solution: unknown.

### Update [September 30, 2020]:

- **VoodooPS2Controller** now separates the brightness shortcut keys part from the standalone driver **BrightnessKeys** kext
- It provides the methods `Notify (GFX0, 0x86)` and `Notify (GFX0, 0x87)`. So the previous brightness shortcut patches are no longer needed and should be disabled. 

If the **BrightnessKeys** kext does not work initially, please refer to the "[special cases](https://github.com/acidanthera/BrightnessKeys#special-cases)" section. If that doesn't fix it assign 2 keys mapped to `F14`, `F15` for the shortcut keys to adjust brightness. Required kexts:

  - [**VoodooPS2Controller.kext**](https://github.com/acidanthera/VoodooPS2)
  - [**BrightnessKeys.kext**](https://github.com/acidanthera/BrightnessKeys)
  
>[!NOTE]
>
> Some ASUS and Dell Laptops require `SSDT-OCWork-xxx` to enable `Notify (GFX0, 0x86)` and `Notify (GFX0,0x87)`, so that the Brightness shorcut keys work. Please refer to the [ASUS Machine Special Patch](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05_Laptop-specific_Patches/Brand-specific_Patches/ASUS_Special_Patch) and [Dell Machine Special Patch](https://github.com/5T33Z0/OC-Little-Translated/blob/main/05_Laptop-specific_Patches/Brand-specific_Patches/Dell_Special_Patch) for instructions.

## Requirements and Preparations

- macOS 10.15 or older
- Use **VoodooPS2Controller.kext** and its sub-drivers.
- Clear the key mapping contents of previous, other methods.
- Plist Editor

> [!CAUTION]
>
> If the keys you want to map are not routed via the PS/2 Controller but via the EC instead, you cannot use this method. In this case, try ACPI Debugging instead (&rarr; [**Example**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/05_Laptop-specific_Patches/Fixing_Keyboard_Mappings_and_Brightness_Keys/Customizing_ThinkPad_Keyboard_Shortcuts.md): In-depth guide for Mapping `Fn` Shortcut Keys on Lenovo ThinkPads)

### About PS/2 and ABD Scan Codes

A keystroke will generate 2 scan codes, **PS/2 Scan Code** and **ABD Scan Code**. For example, the PS/2 scan code for the `Z/z` key is `2c` but the ABD scan code is `6`. Because of the difference in scan codes, two mapping methods correspond to

- `PS/2 Scan Code` &rarr; `PS/2 Scan Code`
- `PS/2 Scan Code` &rarr; `ADB Scan Code`

### Enabling keyboard scan codes

- Check the header file [**ApplePS2ToADBMap.h**](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller/blob/master/VoodooPS2Keyboard/ApplePS2ToADBMap.h), which lists the scan codes for most of the keys.
- Get the keyboard scan codes from the console (use either or). There are 2 methods for enabling them (use either or).

#### Method 1: Using Terminal
- Download `ioio` 
- Make it excutable (if it isn't already). In Terminal, enter `chmod +x`, drag in `ioio` and hit <kbd>Enter</kbd>
- Next, enter `ioio -s ApplePS2Keyboard LogScanCodes 1` to enable log scan codes (set to `0` to disable the logging again).
    
#### Method 2: Enabling Log Scan Codes in `VoodooPS2Keyboard.kext` (recommended)
- Moun your EFI
- In Finder press <kbd>CMD</kbd>+<kbd>G</kbd> (or select "Go to folder…" from the menu bar)
- Enter `/Volumes/EFI/EFI/OC/Kexts/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Keyboard.kext/Contents/Info.plist`
- Open the `Info.plist` with a plist Editor
- Navigate tp `IOKitPersonalities\Platform Profile\Default`
- Change `LogScanCodes` from `0`to **`1`** (once you're done, change it back to **`0`** again!)
- Save the the file
- Reboot
- Open the **Console App** and search for `ApplePS2Keyboard`. Check the output. In this examples, `A/a`and `Z/z` are pressed:
	```text
	11:58:51.255023 +0800 kernel ApplePS2Keyboard: sending key 1e=0 down
	11:58:58.636955 +0800 kernel ApplePS2Keyboard: sending key 2c=6 down
 	```
	 **Meaning**:
	- `1e=0`: `1e`is the PS/2 Scan Code for the `A/a` key, whereas `0` is the ADB Scan Code.
	- `2c=6`: `2c`is the PS/2 Scan Code for the `Z/z` key, whereas `6` is the ADB Scan Code.

## Key mapping principle

Keyboard (re-)mappings can be realized by modifying the `info.plist` file inside of  VoodooPS2Keyboard kext or by adding a custom SSDT Hotpatch instead. The latter is prefered so you don't loose the mapping if you update `VoodooPS2Controller.kext`!

**Example**: Remapping `A/a` to trigger `Z/z` via ***SSDT-RMCF-PS2Map-AtoZ.dsl***. 

- `A/a` PS/2 scan code:`1e`
- `Z/z` PS/2 scan code:`2c`
- `Z/z` ADB scan code:`06`

You can use either of the following mapping methods:

#### PS2 Scan Code to PS2 Scan Code
```asl
    ...
      "Custom PS2 Map", Package()
      {
          Package(){},
          "1e=2c",
      },
    ...
```
#### PS2 Scan Code to ADB Scan Code
```asl
    ...
    "Custom ADB Map", Package()
    {
        Package(){},
        "1e=06",
    }
    ...
```

### NOTES
- The PCI path of the Keyboard used in the example SSDT is `_SB.PCI0.LPCB.PS2K`. Make sure the path(s) used in the SSDT match the ones used in your `DSDT`.
- Most ThinkPads use either `_SB.PCI0.LPC.KBD` or `_SB.PCI0.LPCB.KBD`.
- The variable `RMCF` is used in the patch. If `RMCF` is also used for other **keyboard patches**, both must be merged. See ***SSDT-RMCF-PS2Map-dell***. 
- ***SSDT-RMCF-MouseAsTrackpad*** is used to force-enable the touchpad settings option.
- In **VoodooPS2Controller**, the PS2 Scan Code corresponding to the `<kbd>PrtSc</kbd>` button is `e037`. You could map this key to `F13` and bind `F13` to the screenshot function in System Preferences:
	```asl
    ...
    "Custom ADB Map", Package()
    {
        Package(){},
        "e037=64", // PrtSc -> F13
    }
    ...
	```
	This results in `F13` being used for Screenshots:
	![f13](https://user-images.githubusercontent.com/76865553/147818301-4e4be0ee-dda3-46cb-9c2f-e06d9b041523.jpg)

## Credits and Resources
- Rehabman for [ioio](https://github.com/RehabMan/OS-X-ioio) utility and [Custom Keyboard Mapping Guide](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller/wiki/How-to-Use-Custom-Keyboard-Mapping)
- If you want to create custom keyboard shortcuts, you can try [Karabiner Elements](https://github.com/pqrs-org/Karabiner-Elements) 
