# Modifying PS2 Keyboard mappings and brightness shortcut keys

## Description

Keyboard keys can be re-mapped for triggering different keys than the one that's actual pressed. Function keys like `F2` can be re-mapped to triggering `F10`, for example. But beware that *only* keys that can capture `PS2 Scan Code` under macOS can be re-mapped!

### **Update** [September 30, 2020]:

**`VoodooPS2Controller.kext`** now separates the brightness shortcut keys part from the standalone driver **`BrightnessKeys.kext`** and it provides the methods `Notify (GFX0, 0x86)` and `Notify (GFX0, 0x87)`. The legacy brightness shortcut patch is no longer needed. If the new driver is invalid please refer to this chapter to assign 2 keys mapped to `F14`, `F15` for the shortcut keys to adjust brightness.

  - **VoodooPS2Controller.kext**: [https://github.com/acidanthera/VoodooPS2](https://github.com/acidanthera/VoodooPS2)
  - **BrightnessKeys.kext**: [https://github.com/acidanthera/BrightnessKeys](https://github.com/acidanthera/BrightnessKeys)
  
**Note**: Some Dell and ASUS machines require `SSDT-OCWork-***` or an `OS Patch` to unblock `Notify (GFX0, 0x86)` and `Notify (GFX0,0x87)`, allowing BrightnessKeys kext to work properly. Please refer to "Dell Machine Special Patch" and "Asus Machine Special Patch" for more details.

## Requirements and Preparations

- Use **VoodooPS2Controller.kext** and its sub-drivers.
- Clear the key mapping contents of previous, other methods.
- Plist Editor

### About PS2 and ABD Scan Codes

A keystroke will generate 2 scan codes, **PS2 Scan Code** and **ABD Scan Code**. For example, the PS2 scan code for the `Z/z` key is `2c` but the ABD scan code is `6`. Because of the difference in scan codes, two mapping methods correspond to

- `PS2 Scan Code -> PS2 Scan Code`
- `PS2 Scan Code -> ADB Scan Code`

### Enabling keyboard scan codes

- Check the header file [ApplePS2ToADBMap.h](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller/blob/master/VoodooPS2Keyboard/ApplePS2ToADBMap.h), which lists the scan codes for most of the keys.
- Get the keyboard scan codes from the console (use either or). There are 2 methods for enabling them (use either or).

#### Method 1: Using Terminal. 
- Download `ioio` 
- Make it excutable (if it isn't). In terminal, enter `chmod +x`, drag in `ioio` and hit `Enter`
- Next, enter `ioio -s ApplePS2Keyboard LogScanCodes 1` to enable log scan codes (set to `0` to disable the logging again).
    
#### Method 2: Enabling Log Scan Codes in VoodooPS2Keyboard.kext
- Right-click on `VoodooPS2Controller.kext` and select "Show Package Contents"
- Next, browse Contents > Plugins 
- Right-click on `VoodooPS2Keyboard.kext` and select "Show Package Contents" 
- Browse to `Contents/Info.plist` and open it with a plist Editor
- Search for **`LogScanCodes`** and change it to `1` (once you're done with mapping, change it back to `0` again)
- Save the file
- Reboot
- Open the `Console` App and search for `ApplePS2Keyboard`. Check the output. In this examples, `A/a`and `Z/z` are pressed. 
	```text
	11:58:51.255023 +0800 kernel ApplePS2Keyboard: sending key 1e=0 down
	11:58:58.636955 +0800 kernel ApplePS2Keyboard: sending key 2c=6 down
 	```
	 **Meaning**:
	- The `1e=0` in the first line `1e`is the PS2 Scan Code for the `A/a` key, and the `0` is the ADB Scan Code.
	- The `2c=6` in the second line `2c`is the PS2 Scan Code for the `Z/z` key, and `6` is the ADB Scan Code.

### Mapping method

Keyboard mapping can be achieved by modifying the `VoodooPS2Keyboard.kext\info.plist` file and adding a third-party patch file. The recommended method is to use a third-party patch file.

Example: ***SSDT-RMCF-PS2Map-AtoZ***. `A/a` mapping `Z/z`.

- `A/a` PS2 scan code:`1e`
- `Z/z` PS2 scan code:`2c`
- `Z/z` ADB scan code:`06`

Choose either of the following two mapping methods

#### PS2 Scan Code -> PS2 Scan Code
```swift
    ...
      "Custom PS2 Map", Package()
      {
          Package(){},
          "1e=2c",
      },
    ...
```
#### PS2 Scan Code -> ADB Scan Code
```swift
    ...
    "Custom ADB Map", Package()
    {
        Package(){},
        "1e=06",
    }
    ...
```

### Caution
- The keyboard path in the example is `\_SB.PCI0.LPCB.PS2K`, you should make sure it is the same as the ACPI keyboard path. Most Thinkpad machines have a keyboard path of \_SB.PCI0.LPC.KBD` or \_SB.PCI0.LPCB.KBD`.
- The variable `RMCF` is used in the patch, if `RMCF` is also used in other **keyboard patches**, it must be merged and used. See ***SSDT-RMCF-PS2Map-dell***. `Note`: ***SSDT-RMCF-MouseAsTrackpad*** is used to force on the touchpad settings option.
- In VoodooPS2, the PS2 scan code corresponding to the <kbd>PrtSc</kbd> button is `e037`, the switch for the touchpad (and the little red dot on ThinkPad machines). You can map this key to `F13` and bind `F13` to the screenshot function in System Preferences:
	```swift
    ...
    "Custom ADB Map", Package()
    {
        Package(){},
        "e037=64", // PrtSc -> F13
    }
    ...
	```
	This result in F13 being used for Screenshots:
	![](https://i.loli.net/2020/04/01/gQqVC2YKFweSARZ.png)

## Credits and Resources
Rehabman for [ioio](https://github.com/RehabMan/OS-X-ioio) utility and [Custom Keyboard Mapping Guide](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller/wiki/How-to-Use-Custom-Keyboard-Mapping)
