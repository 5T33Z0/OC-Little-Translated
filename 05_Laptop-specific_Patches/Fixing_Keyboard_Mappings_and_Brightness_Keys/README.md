# Modifying PS2 Keyboard mappings and brightness shortcut keys

## Description
Keyboard keys can be re-mapped for triggering different keys than the one that's actual pressed. Function keys like `F2` can be re-mapped to triggering `F10`, for example. But beware that *only* keys that can capture **PS2 Scan Code** under macOS can be re-mapped!

### Update [September 30, 2020]:

**VoodooPS2Controller** now separates the brightness shortcut keys part from the standalone driver **BrightnessKeys** kext and it provides the methods `Notify (GFX0, 0x86)` and `Notify (GFX0, 0x87)`. So the previous brightness shortcut patches are no longer needed and should be disabled. 

If the BrightnessKeys kext does not work initially, please refer to the "[special cases](https://github.com/acidanthera/BrightnessKeys#special-cases)" section on the github repo's Readme. If that doesn't fix it assign 2 keys mapped to `F14`, `F15` for the shortcut keys to adjust brightness. Required kexts:

  - [**VoodooPS2Controller.kext**](https://github.com/acidanthera/VoodooPS2)
  - [**BrightnessKeys.kext**](https://github.com/acidanthera/BrightnessKeys)
  
>[!NOTE]
>
>Some ASUS and Dell machines require `SSDT-OCWork-xxx` to unblock `Notify (GFX0, 0x86)` and `Notify (GFX0,0x87)`, allowing the BrightnessKeys kext to work properly. 
>
>Please refer to the [ASUS Machine Special Patch](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05_Laptop-specific_Patches/Brand-specific_Patches/ASUS_Special_Patch) and [Dell Machine Special Patch](https://github.com/5T33Z0/OC-Little-Translated/blob/main/05_Laptop-specific_Patches/Brand-specific_Patches/Dell_Special_Patch) for more details.

## Requirements and Preparations

- Use **VoodooPS2Controller.kext** and its sub-drivers.
- Clear the key mapping contents of previous, other methods.
- Plist Editor

### About PS2 and ABD Scan Codes

A keystroke will generate 2 scan codes, **PS2 Scan Code** and **ABD Scan Code**. For example, the PS2 scan code for the `Z/z` key is `2c` but the ABD scan code is `6`. Because of the difference in scan codes, two mapping methods correspond to

- `PS2 Scan Code` &rarr; `PS2 Scan Code`
- `PS2 Scan Code` &rarr; `ADB Scan Code`

### Enabling keyboard scan codes

- Check the header file [**ApplePS2ToADBMap.h**](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller/blob/master/VoodooPS2Keyboard/ApplePS2ToADBMap.h), which lists the scan codes for most of the keys.
- Get the keyboard scan codes from the console (use either or). There are 2 methods for enabling them (use either or).

#### Method 1: Using Terminal
- Download `ioio` 
- Make it excutable (if it isn't already). In Terminal, enter `chmod +x`, drag in `ioio` and hit <kbd>Enter</kbd>
- Next, enter `ioio -s ApplePS2Keyboard LogScanCodes 1` to enable log scan codes (set to `0` to disable the logging again).
    
#### Method 2: Enabling Log Scan Codes in `VoodooPS2Keyboard.kext` (recommended)
- Right-click on `VoodooPS2Controller.kext` and select "Show Package Contents"
- Next, browse to Contents/Plugins 
- Right-click on `VoodooPS2Keyboard.kext` and select "Show Package Contents"
- Browse `Contents` and open `Info.plist` with a plist Editor
- Search for **`LogScanCodes`** and change it to **`1`** (once you're done, change it back to **`0`** again!)
- Save the file
- Reboot
- Open the **Console App** and search for `ApplePS2Keyboard`. Check the output. In this examples, `A/a`and `Z/z` are pressed:
	```text
	11:58:51.255023 +0800 kernel ApplePS2Keyboard: sending key 1e=0 down
	11:58:58.636955 +0800 kernel ApplePS2Keyboard: sending key 2c=6 down
 	```
	 **Meaning**:
	- `1e=0`: `1e`is the PS2 Scan Code for the `A/a` key, whereas `0` is the ADB Scan Code.
	- `2c=6`: `2c`is the PS2 Scan Code for the `Z/z` key, whereas `6` is the ADB Scan Code.

## Key mapping principle

Keyboard (re-)mappings can be realized by modifying the `info.plist` file inside of  VoodooPS2Keyboard kext or by adding a custom SSDT Hotpatch instead. The latter is prefered so you don't loose the mapping if you update `VoodooPS2Controller.kext`!

**Example**: Remapping `A/a` to trigger `Z/z` via ***SSDT-RMCF-PS2Map-AtoZ.dsl***. 

- `A/a` PS2 scan code:`1e`
- `Z/z` PS2 scan code:`2c`
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
