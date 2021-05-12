# PS2 Keyboard mappings for brightness control

## Description

Keyboard Keys can be re-mapped for triggering different keys than the one that's actual pressed. For example, Function keys like `F2` can be re-mapped to triggering `F10`, etc.

### **Update** [September 30, 2020]:

**VoodooPS2Controller.kext** now separates the brightness shortcut part from the standalone driver **BrightnessKeys.kext** and it provides the methods `Notify (GFX0, 0x86)` and `Notify (GFX0, 0x87)`. The legacy brightness shortcut patch is no longer needed. If the new driver is invalid please refer to this chapter to assign 2 keys mapped to `F14`, `F15` for the shortcut keys to adjust brightness.

  - **VoodooPS2Controller.kext**: [https://github.com/acidanthera/VoodooPS2](https://github.com/acidanthera/VoodooPS2)
  - **BrightnessKeys.kext**: [https://github.com/acidanthera/BrightnessKeys](https://github.com/acidanthera/BrightnessKeys)
  
**Note**: Some Dell and ASUS machines require `SSDT-OCWork-***` or an `OS Patch` to unblock `Notify (GFX0, 0x86)` and `Notify (GFX0,0x87)`, allowing **BrightnessKeys.kext** to work properly. Please refer to "Dell Machine Special Patch" and "Asus Machine Special Patch" for more details.

**NOTE**: Not all keys can be re-mapped, *only* keys that can capture `PS2 Scan Code` under macOS system can be mapped.

## Requirements

- Use **VoodooPS2Controller.kext** and its sub-drivers.
- Clear the key mapping contents of previous, other methods.

### PS2 Scan Codes and ABD Scan Codes

A keystroke will generate 2 scan codes, **PS2 Scan Code** and **ABD Scan Code**. For example, the PS2 scan code for the `Z/z` key is `2c` and the ABD scan code is `6`. Because of the difference in scan codes, two mapping methods correspond to

- `PS2 Scan Code -> PS2 Scan Code`
- `PS2 Scan Code -> ADB Scan Code`

### Enabling keyboard scan code

- Check the header file `ApplePS2ToADBMap.h`, which lists the scan codes for most of the keys.
- Get the keyboard scan code from the console (choose either or)
  - Terminal installation: `ioio`

    		bash
    		ioio -s ApplePS2Keyboard LogScanCodes 1
    

  - Modify:`VoodooPS2Keyboard.kext\info\IOKitPersonalities\Platform Profile\Default\`**`LogScanCodes=1`**

	Open the Console and search for `ApplePS2Keyboard`. In this examples, `A/a`and `Z/z` are pressed.

  ```log
    11:58:51.255023 +0800 kernel ApplePS2Keyboard: sending key 1e=0 down
    11:58:58.636955 +0800 kernel ApplePS2Keyboard: sending key 2c=6 down
  ```

  **Meaning**:

  The `1e=0` in the first line `1e`is the PS2 Scan Code for the `A/a` key, and the `0` is the ADB Scan Code.  
  The `2c=6` in the second line `2c`is the PS2 Scan Code for the `Z/z` key, and `6` is the ADB Scan Code.

### Mapping method

Keyboard mapping can be achieved by modifying the `VoodooPS2Keyboard.kext\info.plist` file and adding a third-party patch file. The recommended method is to use a third-party patch file.

Example: ***SSDT-RMCF-PS2Map-AtoZ***. `A/a` mapping `Z/z`.

- `A/a` PS2 scan code:`1e`
- `Z/z` PS2 scan code:`2c`
- `Z/z` ADB scan code:`06`

Choose either of the following two mapping methods

#### PS2 Scan Code -> PS2 Scan Code

```Swift
    ...
      "Custom PS2 Map", Package()
      {
          Package(){},
          "1e=2c",
      },
    ...
```

#### PS2 Scan Code -> ADB Scan Code

```Swift
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

```Swift
    ...
    "Custom ADB Map", Package()
    {
        Package(){},
        "e037=64", // PrtSc -> F13
    }
    ...
```
![](https://i.loli.net/2020/04/01/gQqVC2YKFweSARZ.png)
