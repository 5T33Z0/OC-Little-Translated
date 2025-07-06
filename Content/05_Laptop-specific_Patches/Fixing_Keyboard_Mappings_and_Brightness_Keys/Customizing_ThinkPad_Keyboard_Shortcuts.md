# Customizing Lenovo Keyboard `Fn` Shortcuts

OC-Little contains an SSDT to remap brightness shortcut keys for ThinkPads, which essentially remaps Fn + F5 and Fn + F6 to F14 and F15 to control the brightness of the internal display in macOS. This approach can be used to map other funtions defined in your Embedded Controller so they work in macOS as well (if macOS supports them).

Let's look at the code:

```asl
DefinitionBlock("", "SSDT", 2, "OCLT", "BrightFN", 0)
{
    External(_SB.PCI0.LPCB.KBD, DeviceObj)
    External(_SB.PCI0.LPCB.EC, DeviceObj)
    External(_SB.PCI0.LPCB.EC.XQ14, MethodObj)
    External(_SB.PCI0.LPCB.EC.XQ15, MethodObj)

    Scope (_SB.PCI0.LPCB.EC)
    {
        Method (_Q14, 0, NotSerialized)//up
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x0406)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ14()
            }
        }

        Method (_Q15, 0, NotSerialized)//down
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x0405)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ15()
            }
        }
    }
}
```
Translated into human language, it says: 

- Define function `_Q14` for the device present in `_SB.PCI0.LPCB.EC`. 
- If the current OS is macOS (Darwin Kernel is loaded), send `0x0406` notification to the Keyboard device `_SB.PCI0.LPCB.KBD`; 
- Otherwise (if not macOS), execute the function `XQ14()`. 
- Same is true for `_Q15` (but `0x0405` is send instead).

It should be noted that the premise of using this brightness patch is to rename `_Q14` to `XQ14` in order to redefine the function when macOS is running. `0x0406` is actually the scan code for `F15`, which will be discussed later. 

What conclusions can we draw from this?

- Fn+F5 and Fn+F6 correspond to two functions defined in the Embedded Controller (`_SB.PCI0.LPCB.EC`), `Q15` and `Q14`.
- On macOS, changing the brightness is achieved by sending a string of hex code to the keyboard device.
- The hex sent by Q15 and Q14 is F14 and F15, so Fn + F5 and Fn + F6 are actually F14 and F15 in macOS

## Finding all "extra" shortcuts on your keyboard
If there are functions defined in `_SB.PCI0.LPCB.EC` that implement brightness shortcut keys, we have every reason to believe that there may be other functions under this bus that define other shortcut keys (results vary from model to model).

We can dump and analyze the system's `DSDT` and check for other shortcuts in the EC Bus. Open the `DSDT` with maciASL and search for `_SB.PCI0.LPCB.EC `(or `_SB.PCI0.LPC.EC`) to check if there are other functions defined. Sure enough, many function definitions for similar patterns can be found:

```asl
Scope (\_SB.PCI0.LPCB.EC)
{
    Method (_Q63, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
    {
        If (\_SB.PCI0.LPCB.EC.HKEY.MHKK (0x01, 0x00080000))
        {
            \_SB.PCI0.LPCB.EC.HKEY.MHKQ (0x1014)
        }

        \UCMS (0x0B)
    }
}
```

I already know that the definition of the keyboards of the whole ThinkPad is the same (because the brightness shortcut SSDT provided in OC-little is common to ThinkPads). I found other configs for ThinkPad models that contained shortcut key definitions in their SSDTs. For example, the `SSDT-KBD.aml` file of the ThinkPad X1 Carbon 6th gen has shortcut keys that contains the following functions: **Q14, Q15, Q16, Q43, Q60, Q61, Q62, Q64, Q65, Q66**.

The next question is, how to find the relationship between each button and the above functions?

## Use ACPIDebug to find out shortcut mappings

Rehabman provides a series of DSDT Patches for debugging ACPI functions. OC-little simplifies the DSDT patch into a general SSDT hotpatch, which can be used directly. ACPIDebug provides a set of ACPI functions that can output specified information to the Console, like printf or console.log. We only need to call the relevant function to output the information where we need to print the debugging information.

Enabling ACPI debugging is simple: grab `SSDT-RMDT.aml` (RehabMan Debugging Table) and `ACPIDebug.kext` from the [**ACPI Debuggig section**](/Content/00_ACPI/ACPI_Debugging) and add them to your EFI and config.plist. The (relatively) difficult part is writing an SSDT for debugging.

The sample [`SSDT-BKeyQxx-Debug.dsl`](/Content/00_ACPI/ACPI_Debugging/SSDT-BKeyQxx-Debug.dsl) in OC-little also provides an example for using the RMDT function that prints two arguments:

```asl
Scope (_SB.PCI0.LPCB.EC0)
{
    Method (_QXX, 0, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            //Debug...
            \RMDT.P2 ("ABCD-_PTS-Arg0=", \_SB.PCI9.TPTS)
            \RMDT.P2 ("ABCD-_WAK-Arg0=", \_SB.PCI9.TWAK)
            //Debug...end
        }
        Else
        {
            \_SB.PCI0.LPCB.EC0.XQXX()
        }
    }
}
```
Notice \RMDT.P2 ("ABCD-_WAK-Arg0=", \_SB.PCI9.TWAK)? In the `QXX` function, the call to the \RMDT.P2 function prints two arguments, the first is the `ABCD-_PTS-Arg0=` string and the second is the variable `\_SB.PCI9.TPTS`. Pressing the shortcut key for the `QXX` function executes the print function and you can see the values of the `ABCD-_PTS-Arg0=` and `\_SB.PCI9.TPTS` variables in the Console.app.

If you can understand some ACPI, the \RMDT.P2 function defined in SSDT-RMD needs to print two parameters, while the P1 function only prints one parameter. Following the example of the brightness shortcut key patch and SSDT-BKeyQxx-Debug.dsl given by OC-little, write the following SSDT:

```asl
DefinitionBlock("", "SSDT", 2, "OCLT", "ACPIDebug", 0) // Our table name is ACPIDebug
{
    External(_SB.PCI0.LPCB.KBD, DeviceObj)     // Reference to Device KBD (Keyboard), whichever is in DSDT on your machine
    External(_SB.PCI0.LPCB.EC, DeviceObj)      // EC, whichever is in the DSDT on your machine
    External(_SB.PCI0.LPCB.EC.XQ14, MethodObj) // Reference to XQ14 function
    External(RMDT.P1, MethodObj)               // Reference to an externally defined RMDT.P1 function

    Scope (_SB.PCI0.LPCB.EC)
    {
        Method (_Q14, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                \RMDT.P1 ("SUKKA_DEBUG_KEYBOARD-Q14") // Print parameter: String SUKKA_DEBUG_KEYBOARD-Q14
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQ14()
            }
        }
    }
}
```
Add more `External` references following the same principle as the `_Q14` to define the remaining shortcut keys. Of course, don't forget to add the corresponding ACPI renames to the config.plist, like rename `_Q14` to `XQ14`, etc. to avoid conflicts. The final SSDT looks like the image below:

![](https://img10.360buyimg.com/ddimg/jfs/t1/192837/32/23139/28717/6257a095E1192c695/ec36e588b503bbf4.png)

Reboot to load the above SSDT, then open the macOS console, enter SUKKA_DEBUG_KEYBOARD in the search box in the upper right corner and press Enter to filter out information that only contains the specified string.

Next, press Fn + F5 and see if the information is printed in the console:

![](https://img10.360buyimg.com/ddimg/jfs/t1/113668/4/23376/31485/6257a095E06b101a6/36278c5c25add7f9.png)

Print out SUKKA_DEBUG_KEYBOARD-Q14 , indicating that Fn + F5 is Q14. Continue to press other shortcut keys, and find out the corresponding function of each shortcut key according to the print information:

![](https://img10.360buyimg.com/ddimg/jfs/t1/205451/5/21260/50233/6257a096Ee2775c43/04410d6ed30327d2.png)

Here is a list of functions for the ThinkPad keyboard I found using the method above:

- `Fn` + `F1` = `Q43`
- `Fn` + `F5` = `Q15`
- `Fn` + `F6` = `Q14`
- `Fn` + `F7` = `Q16`
- `Fn` + `F8` = `Q64`
- `Fn` + `F9` = `Q66`
- `Fn` + `F10` = `Q60`
- `Fn` + `F11` = `Q61`
- `Fn` + `F12` = `Q62`
- `Fn` + `PrtScreen` = `Q65`

## Learn PS2 and ABD keycodes

In the "PS2 Keyboard Mapping" chapter in OC-little, it is pointed out that a key will generate two scan codes, namely PS2 and ADB scan code. The correspondence between the original ADB and PS2 scan codes can be found in the [ApplePS2ToADBMap.h](https://github.com/daliansky/OC-little/blob/0c973dbcde8bfef5d027de5b246736da5311bc18/07-PS2%E9%94%AE%E7%9B%98%E6%98%A0%E5%B0%84/ApplePS2ToADBMap.h) file.

If your keyboard is powered by VoodooPS2Controller, you can use the [ioio](https://github.com/RehabMan/OS-X-ioio) tool developed by Rehabman to get the keycode for each key. Download and unzip the ioio tool, and run the following command in the terminal to view the scan code of the key: `ioio -s ApplePS2Keyboard LogScanCodes 1`

Go back to the macOS console you just opened, delete all characters in the search box in the upper right corner, type PS2 and press Enter.

> [!TIP] 
> 
> If the console contains a lot of information, click on the “Clear” in the menu bar.

![](https://img10.360buyimg.com/ddimg/jfs/t1/147893/18/26008/46596/6257a096E56f47351/5a94c93bc1c8b2d8.png)

Press the F1 key, you can see the console print out the following scan code:

![](https://img10.360buyimg.com/ddimg/jfs/t1/104044/22/27370/47260/6257a096Ebf534f58/001641207c9fafef.png)

Let's look at 3b=7a, the 3b to the left of the equal sign is the PS2 scan code, and the 7a to the right of the equal sign is the ADB scan code. Remember the [ApplePS2ToADBMap.h](https://github.com/daliansky/OC-little/blob/0c973dbcde8bfef5d027de5b246736da5311bc18/07-PS2%E9%94%AE%E7%9B%98%E6%98%A0%E5%B0%84/ApplePS2ToADBMap.h) file mentioned earlier? See if we can find anything in it:

`0x7a, // 3b  F1`

In other words, `0x7a` corresponds to `3b`, the key is F1!

Remember the "0x0406 is the scan code of F15" mentioned earlier? Let's read the file:

```asl
// These ADB codes are for F14/F15 (works in 10.12)
#define BRIGHTNESS_DOWN         0x6b
#define BRIGHTNESS_UP           0x71


BRIGHTNESS_DOWN,    // e0 05 dell down
BRIGHTNESS_UP,      // e0 06 dell up
```
Aha! 0x71 is F15 is the scan key code of ADB, and corresponds to e0 06 at the same time. So 0x0406 corresponds to e0 06, 0x0405 corresponds to e0 05, and the last two bits are the same. Is this a coincidence? Certainly not.

Here I go straight to the conclusion. The 04 in 0x0406 refers to the e0 (that is, the extended key code) in the PS2 scan code, and 06 is the last two digits. In addition to 04, you can also take 0x03, which means that the PS2 scan code has only 2 digits. For example, the PS2 scan code 3b of F1 can be represented as 0x033b.

Let's go back and look at the brightness shortcut SSDT patch provided in OC-little:

```asl
Scope (_SB.PCI0.LPCB.EC)
{
    Method (_Q14, 0, NotSerialized)//up
    {
        If (_OSI ("Darwin"))
        {
            Notify(\_SB.PCI0.LPCB.KBD, 0x0406)
        }
        Else
        {
            \_SB.PCI0.LPCB.EC.XQ14()
        }
    }
}
```

So press Fn + F6, ACPI will execute the _Q14 function and send 0x0406 to the keyboard KBD, which translates to ADB scan code is e0 06, corresponding to 0x71 in the PS2 scan code, which is F15, which happens to be an increase in system preferences Display Brightness:

![](https://img10.360buyimg.com/ddimg/jfs/t1/178621/1/23119/29375/6257a096Ebe083972/a9e69773c9149b11.png)

## Write SSDT to define shortcut keys

Remember what the first sentence of the first chapter said?

> In OC-little, there is an existing brightness shortcut repair patch for ThinkPad, which essentially maps ThinkPad's Fn + F5 and Fn + F6 to F14 and F15, and F14 and F15 are the brightness adjustment in "System Preferences" in macOS default shortcut key.

Then, we can use the same method to map the Fn + Fx keys to F13, F14, F15 until F21 respectively. Then define actions for keys such as F13, F14, etc. in System Preferences or third-party shortcut software.

Raw Keys | Key Icons | ACPI Functions | Mapped Keys | PS2 Scan Code (Hex) | ADB Scan Code
:-------:|:---------:|:--------------:|:-----------:|:-------------------:|:------------:
Fn + F1 | Mute | Q43 | Mute | e020 (0x0420) | 4a
Fn + F4 | Microphone Switch | Q6A | F13 | 64 (0x0364) | d9
Fn + F5 | Brightness Minus | Q15 | F14 | e005 (0x0405) | 6b
Fn + F6 | Brightness Plus | Q14 | F15 | e006 (0x0406) | 71
Fn + F7 | Multiscreen | Q16 | F16 | 67 (0x0367) | 6a
Fn + F8 | WiFi Switch | Q64 | F17 | 68 (0x0368) | 40
Fn + F9 | Sun | Q66 | F18 | 69 (0x0369) | 4f
Fn + F10 | Bluetooth Switch | Q60 | F19 | 6a (0x036A) | 50
Fn + F11 | Keyboard | Q61 | F20 | 6b (0x036B) | 5a
Fn + F12 | Star | Q62 | F21 | 6c (0x036C) | DEADKEY
PrtScr | Screenshot | N/A | F22 | e037 (0x0437) | 64
Fn + PrtScr | ThinkPad Touchpad Switch | Q65 | N/A | e01e (0x041e) | N/A

Next, write SSDT according to the above table, mimicking the way of the brightness shortcut patch:

```asl
DefinitionBlock("", "SSDT", 2, "HACK", "Keyboard", 0)
{
    External(_SB.PCI0.LPCB.KBD, DeviceObj) // Ext. Reference to keyboard devices
    External(_SB.PCI0.LPCB.EC, DeviceObj) // Ext. References to Embedded Controller 
    External(_SB.PCI0.LPCB.EC.XQ43, MethodObj) // Ext. Reference to XQ43 Method
    
    Scope (_SB.PCI0.LPCB.EC)
    {
        Method (_Q43, 0, NotSerialized) // Q43
        {
            If (_OSI ("Darwin")) // If macOS is running
            {
                Notify(\_SB.PCI0.LPCB.KBD, 0x0420) // Send PS2 scan code e020
            }
            Else // If the OS is something else
            {
                \_SB.PCI0.LPCB.EC.XQ43() // Execute the XQ43 function (as defined in the DSDT)
            }
        }
    }
}
```
Next, add the external reference of the original function in turn, then add the Notify function in turn to send the PS2 keycode to the keyboard.

It should be noted that such as PrtScr is not an additional shortcut key, there is no corresponding ACPI function. We can use Custom PS2 Map or Custom ADB Map for mapping:

```
Name(_SB.PCI0.LPCB.KBD.RMCF, Package()
{
    "Keyboard", Package()
    {
        "Custom PS2 Map", Package()
        {
            Package(){},
            "e037=64", // PrtSc = F13
        },
        // "Custom ADB Map", Package()
        // {
        //    Package(){},
        //    "1e=06", // A = Z
        // },
    },
})
```
Here we need to understand the rules of Custom PS2/ADB Map. The button to the left of the equal sign is always the pressed button, and the right side of the equal sign is always the original definition.

Can't understand? Let's look at this example:

```asl
"Custom PS2 Map", Package()
{
    Package(){},
    "1e=2c",
    "2c=1e"
}
```
where 1e is the PS2 scan code of A and 2c is the PS2 scan code of Z. So 1e=2c means that pressing A will trigger 2c, and the original definition of 2c is Z, so the letter Z is output; similarly, after pressing Z, 2c is mapped to 1e, which is the original A, so the output is the letter A.

## Disabling the TrackpPad (and TrackPoint) using a shortcut key

Before using the above SSDT to map `e037` (PrtSc) to `6d` (F13), `e037` is actually a special key code used to switch the TrackPad (trackpad) device (on ThinkPad, the little red dot also belongs to the Trackpad device). Although few people use macOS (especially Hackintosh) laptops to play games, so there is no need to disable the trackpad, but technically, it's possible.

As mentioned above, we can map A to Z and also map Z to A; in the same way, we can also map a key to e037 to switch the touchpad, and then map PrtSc (e037) to other keys (eg F13).

But now, I want to map Fn + F11 (F11 draws a keyboard on the ThinkPad) to e037, and Fn + F11 is an extra shortcut key without PS2 scan code, what should I do? The answer is "no clue".

First we need to find a PS2 scan code that we don't have access to. Go back and look at [ApplePS2ToADBMap.h](https://github.com/daliansky/OC-little/blob/0c973dbcde8bfef5d027de5b246736da5311bc18/07-PS2%E9%94%AE%E7%9B%98%E6%98%A0%E5%B0%84/ApplePS2ToADBMap.h) to select a PS2 scan code that is not a DEADKEY and is not available on the keyboard. Here I choose e01e. I already know that the ACPI function corresponding to Fn + F11 is Q61, so trigger e01e in the Q61 function:

```asl
Method (_61, 0, NotSerialized)
{
    If (_OSI ("Darwin"))
    {
        Notify(\_SB.PCI0.LPCB.KBD, 0x041e) // e01e
    }
    Else
    {
        \_SB.PCI0.LPCB.EC.XQ61()
    }
}Method (_61, 0, NotSerialized)
{
    If (_OSI ("Darwin"))
    {
        Notify(\_SB.PCI0.LPCB.KBD, 0x041e) // e01e
    }
    Else
    {
        \_SB.PCI0.LPCB.EC.XQ61()
    }
}
```
Now, pressing Fn + F11 will send the PS2 scan code e01e. Next, we only need to define two mappings in Custom PS2 Map:

```asl
Name(_SB.PCI0.LPCB.KBD.RMCF, Package()
{
    "Keyboard", Package()
    {
        "Custom PS2 Map", Package()
        {
            Package(){},
            "e01e=e037", // Fn + F11 = PrtSc
            "e037=64", // PrtSc = F13
        },
    },
})
```
## Credits

https://blog.skk.moe/post/ssdt-map-fn-shortcuts/ (Translated from Chinese)
