# ACPI Source Language (ASL) Basics
> The provided esxplanatins in this Section are based on the following Post at PCBeta Forums by the User suhetao: "[DIY DSDT Turorial Series, Part 1: ASL (ACPI Source Language) Basics](http://bbs.pcbeta.com/forum.php?mod=viewthread&tid=944566&archive=2&extra=page%3D1&page=1)"
> 
> - Reformatted for Markdown by Bat.bat (williambj1) on 2020-2-14, with some additions and corrections.
> - Translated from chinese into english and edited by [5T33Z0](https://github.com/5T33Z0), 2021-03-24.

## Preface
The following information is based on the documentation of the [ACPI Specifications](https://uefi.org/specs/ACPI/6.4/) provided by the Unified Extensible Firmware Interface Forum (UEFI.org). Since I am not a BIOS developer, it is possible that there could be mistakes in the provided ASL examples.

## Explanation 
Did you ever wonder what a `DSDT` or `SSDT` is and what it does? Or how these rename patches that you have in your config.plist work? Well, after reading this, you will know for sure…

### ACPI
**`ACPI`** stands for `Advanced Configuration & Power Interface`. In ACPI, peripheral devices and system hardware features of the platform are described in the **`DSDT`** (Differentiated System Description Table), which is loaded at boot and in SSDTs (Secondary System Description Tables), which are loaded *dynamically* at run time. ACPI is literally just a set of tables of texts to provide operating systems with some basic information about the used hardware. **`DSDTs`** and **`SSDTs`** are just *two* of the many tables that make up an ACPI – but very important ones for us.

### Why to prefer SSDTs over a patched DSDT
A common problem with Hackintoshes is missing ACPI functionality when trying to run macOS on X86-based Intel and AMD PCs, such as: Networking not working, USB Ports not working, CPU Power Management not working correctly, screens not turning off when the lid is closed, Sleep and Wake not working, Brightness controls not working and so on.

These issues stems from DSDTs made with Windows support in mind on one hand and Apple not using standard ACPI for their hardware on the other. These issues can be addressed by dumping, patching and injecting the patched DSDT during boot, replacing the original. 

Since a DSDT can change when updating the BIOS, injecting an older DSDT on top of a newer one can cause conflicts and break macOS funktionalities. Therefore *dynamic patching* with SSDTs is highly recommended over using a patched DSDT. Plus the whole process is much more efficient, transpaent and elegant.

### ASL
A notable feature of `ACPI` is a specific proprietary language to compile ACPI tables. This language is calle `ASL` (ACPI Source Language), which is at the center of this article. After a ASL is compiled by a compiler, it becomes AML (ACPI Machine Language), which can be executed by the operating system. Since ASL is a language, it has its rules and guidelines. 

## ASL Guidelines

1. The variable defined in the `DefinitionBlock` must not exceed 4 characters, and not begin with digits. Just check any DSDT/SSDT – no exceptions.

1. `Scope` is similar to `{}`. There is one and there is only one `Scope`. Therefore, DSDT begins with:

   ```swift
   DefinitionBlock ("xxxx", "DSDT", 0x02, "xxxx", "xxxx", xxxx)
   {
   ```

   and is ended by

   ```swift
   }
   ```

   This is called the `root Scope`.

	`xxxx` parameters refer to the `File Name`、`OEMID`、`Table ID` and`OEM Version`. The third parameter is based on the second parameter. As shown above, if the second parameter is **`DSDT`**, in turn, the third parameter is`0x02`. Other parameters are free to fill in.

2. Methods and variables beginning with an underscore `_` are reserved for operating systems. That's why some ASL tables contain `_T_X` trigger warnings after decompilation.

   
3. `Method` can be defined followed by `Device` or `Scope`. As such, `Method` cannot be defined without `Scope`, and the instances listed below are **invalid**.

   ```swift
   Method (xxxx, 0, NotSerialized)
   {
       ...
   }
   DefinitionBlock ("xxxx", "DSDT", 0x02, "xxxx", "xxxx", xxxx)
   {
       ...
   }
   ```

4. `\_GPE`,`\_PR`,`\_SB`,`\_SI`,`\_TZ` belong to root scope `\`.

   - `\_GPE`--- ACPI Event handlers
   - `\_PR` --- CPU
   - `\_SB` --- Devices and Busses
   - `\_SI` --- System indicator
   - `\_TZ` --- Thermal zone

	Components with different atrributes are place below/inside the corresponding Scope. For example:

   - `Device (PCI0)` is placed inside `Scope (\_SB)`

     ```swift
     Scope (\_SB)
     {
         Device (PCI0)
         {
             ...
         }
         ...
     }
     ```

   - CPU related information is placed in Scope (_PR)

     > CPUs can have various scopes, for instance `_PR`,`_SB`,`SCK0`

     ```swift
     Scope (_PR)
     {
         Processor (CPU0, 0x00, 0x00000410, 0x06)
         {
             ...
         }
         ...
     }
     ```

   - `Scope (_GPE)` places event handlers

      ```swift
      Scope (_GPE)
      {
          Method (_L0D, 0, NotSerialized)
          {
              ...
          }
          ...
      }
      ```

      Yes, methods can be placed here. Caution, methods begin with **`_`** are reserved by operating systems.

5. `Device (xxxx)` also can be recognised as a scope, it cotains various descriptions to devices, e.g. `_ADR`,`_CID`,`_UID`,`_DSM`,`_STA`.

6. Symbol `\` quotes the root scope; `^` quotes the superior scope. Similarly,`^` is superior to `^^`.

7. Symbol `_` is meaningless, it only completes the 4 characters, e.g. `_OSI`.

8. For better understanding, ACPI releases `ASL+(ASL2.0)`, it introduces C language's `+-*/=`, `<<`, `>>` and logical judgment `==`, `!=` etc.

9. Methods in ASL can accept up to 7 arguments; they are represented by `Arg0` to `Arg6` and cannot be customised.

10. Local Variables in ASL can accept up to 8 arguments；they are represented by `Local0`~`Local7`. Definitions is not necessary, but should be initialised, in other words, assignment is needed.

## Common ASL Data Types

|    ASL    |  
| :-------: | 
| `Integer` | 
| `String`  |  
|  `Event`  |  
| `Buffer`  |  
| `Package` | 

## ASL Variables Definition

- Define Integer:

  ```swift
  Name (TEST, 0)
  ```

- Define String:
  
  ```swift
  Name (MSTR,"ASL")
  ```

- Define Package:

  ```swift
  Name (_PRW, Package (0x02)
  {
      0x0D,
      0x03
  })
  ```

- Define Buffer Field (6 available types in total):

|     Create statement     |   size   |
| :--------------: | :------: |
|  CreateBitField  |  1-Bit   |
| CreateByteField  |  8-Bit   |
| CreateWordField  |  16-Bit  |
| CreateDWordField |  32-Bit  |
| CreateQWordField |  64-Bit  |
|   CreateField    | any sizes |

  ```swift
  CreateBitField (AAAA, Zero, CCCC)
  CreateByteField (DDDD, 0x01, EEEE)
  CreateWordField (FFFF, 0x05, GGGG)
  CreateDWordField (HHHH, 0x06, IIII)
  CreateQWordField (JJJJ, 0x14, KKKK)
  CreateField (LLLL, Local0, 0x38, MMMM)
  ```

It is not necessary to announce its type when defining a variable.

## ASL Assignment

```swift
Store (a,b) /* legacy ASL */
b = a      /*   ASL+  */
```

**Examples**:

```swift
Store (0, Local0)
Local0 = 0

Store (Local0, Local1)
Local1 = Local0
```

## ASL Calculation

|  ASL+  |  Legacy ASL  |     Examples                                                         |
| :----: | :--------: | :----------------------------------------------------------- |
|   +    |    Add     |    `Local0 = 1 + 2`<br/>`Add (1, 2, Local0)`                    |
|   -    |  Subtract  |     `Local0 = 2 - 1`<br/>`Subtract (2, 1, Local0)`               |
|   *    |  Multiply  |     `Local0 = 1 * 2`<br/>`Multiply (1, 2, Local0)`               |
|   /    |   Divide   |    `Local0 = 10 / 9`<br/>`Divide (10, 9, Local1(remainder), Local0(result))` |
|   %    |    Mod     |     `Local0 = 10 % 9`<br/>`Mod (10, 9, Local0)`                  |
|   <<   | ShiftLeft  |      `Local0 = 1 << 20`<br/>`ShiftLeft (1, 20, Local0)`           |
|   >>   | ShiftRight |    `Local0 = 0x10000 >> 4`<br/>`ShiftRight (0x10000, 4, Local0)` |
|   --   | Decrement  |   `Local0--`<br/>`Decrement (Local0)`                          |
|   ++   | Increment  |   `Local0++`<br/>`Increment (Local0)`                          |
|   &    |    And     |      `Local0 = 0x11 & 0x22`<br/>`And (0x11, 0x22, Local0)`        |
| &#124; |     Or     |        `Local0 = 0x01`&#124;`0x02`<br/>`Or (0x01, 0x02, Local0)`  |
|   ~    |    Not     |   `Local0 = ~(0x00)`<br/>`Not (0x00,Local0)`                   |
|      |    Nor     |    `Nor (0x11, 0x22, Local0)`                                   |

Read `ACPI Specification` for more details

## ASL Logic

|  ASL+  |   Legacy ASL  | Examples             |
| :----: | :-----------: | :----------------------------------------------------------- |
|   &&   |     LAnd      |  `If (BOL1 && BOL2)`<br/>`If (LAnd(BOL1, BOL2))`              |
|   !    |     LNot      |  `Local0 = !0`<br/>`Store (LNot(0), Local0)`                  |
| &#124; |      LOr      |  `Local0 = (0`&#124;`1)`<br/>`Store (LOR(0, 1), Local0)`    |
|   <    |     LLess     |  `Local0 = (1 < 2)`<br/>`Store (LLess(1, 2), Local0)`         |
|   <=   |  LLessEqual   |  `Local0 = (1 <= 2)`<br/>`Store (LLessEqual(1, 2), Local0)`   |
|   >    |   LGreater    |  `Local0 = (1 > 2)`<br/>`Store (LGreater(1, 2), Local0)`      |
|   >=   | LGreaterEqual |  `Local0 = (1 >= 2)`<br/>`Store (LGreaterEqual(1, 2), Local0)` |
|   ==   |    LEqual     |  `Local0 = (Local0 == Local1)`<br/>`If (LEqual(Local0, Local1))` |
|   !=   |   LNotEqual   |  `Local0 = (0 != 1)`<br/>`Store (LNotEqual(0, 1), Local0)`    |

Only two results from logical calculation - `0` or `1`

## ASL Definition of Method

1. Define a Method:

   ```swift
   Method (TEST)
   {
       ...
   }
   ```

2. Define a method contains 2 parameters, and applies local variables `Local0`~`Local7`

   Numbers of parameters are defaulted to `0`

   ```swift
   Method (MADD, 2)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1
   }
   ```


3. Define a method contains a return value:
  
   ```swift
   Method (MADD, 2)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1

       Return (Local0) /* return here */
   }
   ```

   

   ```swift
   Local0 = 1 + 2            /* ASL+ */
   Store (MADD (1, 2), Local0)  /* Legacy ASL */
   ```

4. Define serialised method:

   If not define `Serialized` or `NotSerialized`, default as `NotSerialized`

   ```swift
   Method (MADD, 2, Serialized)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1
       Return (Local0)
   }
   ```

   It looks like `multi-thread synchronisation`. In other words, only one instance can be existed in the memory when the method is stated as `Serialized`. Normally the application create one object, for example:

   ```swift
   Method (TEST, Serialized)
   {
       Name (MSTR,"I will sucess")
   }
   ```

   If we state `TEST` shown above，and call it from two different methods:

   ```swift
   Device (Dev1)
   {
        TEST ()
   }
   Device (Dev2)
   {
        TEST ()
   }
   ```
If we execute `TEST` in `Dev1`, then `TEST` in `Dev2` will wait until the first one finalised. If we state:

   ```swift
   Method (TEST, NotSerialized)
   {
       Name (MSTR, "I will sucess")
   }
   ```

   when one of `TEST` called from `Devx`, another `TEST` will be failed to create `MSTR`.

## ACPI Preset Function

### `_OSI`  (Operating System Interfaces)

It is easy to acquire the current operating system's name and version when applying `_OSI`. For example, we could apply a patch that is specific to Windows or MacOS.

`_OSI` requires a string, the string must be picked from the table below.

|                 OS                  |      String      |
| :---------------------------------: | :--------------: |
|                   macOS                   |    `"Darwin"`    |
| Linux<br/>(Including OS based on Linux kernel) |    `"Linux"`     |
|                  FreeBSD                  |   `"FreeBSD"`    |
|                  Windows                  | `"Windows 20XX"` |

> Notably, different Windows versions requre a unique string, read:  
> <https://docs.microsoft.com/en-us/windows-hardware/drivers/acpi/winacpi-osi>

When `_OSI`'s string matchs the current system, it returns `1`, `If` condition is valid.

```swift
If (_OSI ("Darwin")) /* judge if the current system is macOS */
```

### `_STA` (Status)

**⚠️ CAUTION: two types of `_STA` exist，do not mix up `_STA` from `PowerResource`!**

5 types of bit can be return from `_STA` method, explanations are listed below:

| Bit   | Explanations                           |
| :-----: | :----------------------------- |
| Bit [0] | Set if the device is present.                   |
| Bit [1] | Set if the device is enabled and decoding its resources. |
| Bit [2] | Set if the device should be shown in the UI.         |
| Bit [3] | Set if the device is functioning properly (cleared if device failed its diagnostics).            |
| Bit [4] | Set if the battery is present.             |

We need to transfer these bits from hexadecimal to binary. `0x0F` transfered to `1111`, meaning enable it(the first four bits); while `Zero` means disable. 

We also encounter `0x0B`,`0x1F`. `1011` is a binary form of `0x0B`, meaning the device is enabled and not is not allowed to decode its resources. `0X0B` often utilised in **`SSDT-PNLF`**. `0x1F` (`11111`)only appears to describe battery device from laptop, the last bit is utilised to inform Control Method Battery Device `PNP0C0A` that the battery is present.

> In terms of `_STA` from `PowerResource`
>
> `_STA` from `PowerResource` only returns `One` or `Zero`. Please read `ACPI Specification` for detail.

### `_CRS` (Current Resource Settings)
`_CRS` returns a `Buffer`, it is often utilised to acquire touchable devices' `GPIO Pin`,`APIC Pin` for controlling the interrupt mode.


## ASL flow Control

ASL also has its method to control flow.

- Switch
  - Case
  - Default
  - BreakPoint
- While
  - Break
  - Continue
- If
  - Else
  - ElseIf
- Stall

### Branch control `If` & `Switch`

#### `If`

   The following codes check if the system is `Darwin`, if yes then`OSYS = 0x2710`

   ```swift
   If (_OSI ("Darwin"))
   {
       OSYS = 0x2710
   }
   ```

#### `ElseIf`, `Else`

   The following codes check if the system is `Darwin`, and if the system is not `Linux`, if yes then `OSYS = 0x07D0`

   ```swift
   If (_OSI ("Darwin"))
   {
       OSYS = 0x2710
   }
   ElseIf (_OSI ("Linux"))
   {
       OSYS = 0x03E8
   }
   Else
   {
       OSYS = 0x07D0
   }
   ```

#### `Switch`, `Case`, `Default`, `BreakPoint`

   ```swift
   Switch (Arg2)
   {
       Case (1) /* Condition 1 */
       {
           If (Arg1 == 1)
           {
               Return (1)
           }
           BreakPoint /* Mismatch condition, exit */
       }
       Case (2) /* Condition 2 */
       {
           ...
           Return (2)
       }
       Default /* if condition is not match，then */
       {
           BreakPoint
       }
   }
   ```


### Loop control

#### `While` & `Stall`

```swift
Local0 = 10
While (Local0 >= 0x00)
{
    Local0--
    Stall (32)
}
```

`Local0` = `10`,if `Local0` ≠ `0` is false, `Local0`-`1`, stall `32μs`, the codes delay `10 * 32 = 320 μs`。

#### `For`

`For` from `ASL` is similar to `C`, `Java`

```swift
for (local0 = 0, local0 < 8, local0++)
{
    ...
}
```

`For` shown above and `While` shown below are equivalent

```swift
Local0 = 0
While (Local0 < 8)
{
    Local0++
}
```

## `External` Quote

|    Quote Types    | External SSDT Quote| Quoted    |
| :------------: | :------------ |  :------------------------------------ |
|   UnknownObj    | `External (\_SB.EROR, UnknownObj`             | (avoid to use)                          |
|     IntObj        | `External (TEST, IntObj`                      | `Name (TEST, 0)`                                                        |
|     StrObj        | `External (\_PR.MSTR, StrObj`                 | `Name (MSTR,"ASL")`                                                     |
|    BuffObj       | `External (\_SB.PCI0.I2C0.TPD0.SBFB, BuffObj` | `Name (SBFB, ResourceTemplate ()`<br/>`Name (BUF0, Buffer() {"abcde"})` |
|     PkgObj      | `External (_SB.PCI0.RP01._PRW, PkgObj`        | `Name (_PRW, Package (0x02) { 0x0D, 0x03 })`                            |
|  FieldUnitObj     | `External (OSYS, FieldUnitObj`                | `OSYS,   16,`                                                           |
|   DeviceObj       | `External (\_SB.PCI0.I2C1.ETPD, DeviceObj`    | `Device (ETPD)`                                                         |
|    EventObj       | `External (XXXX, EventObj`                    | `Event (XXXX)`                                                          |
|   MethodObj        | `External (\_SB.PCI0.GPI0._STA, MethodObj`    | `Method (_STA, 0, NotSerialized)`                                       |
|    MutexObj       | `External (_SB.PCI0.LPCB.EC0.BATM, MutexObj`  | `Mutex (BATM, 0x07)`                                                    |
|  OpRegionObj      | `External (GNVS, OpRegionObj`                 | `OperationRegion (GNVS, SystemMemory, 0x7A4E7000, 0x0866)`              |
|  PowerResObj     | `External (\_SB.PCI0.XDCI, PowerResObj`       | `PowerResource (USBC, 0, 0)`                                            |
|  ProcessorObj      | `External (\_SB.PR00, ProcessorObj`           | `Processor (PR00, 0x01, 0x00001810, 0x06)`                              |
| ThermalZoneObj    | `External (\_TZ.THRM, ThermalZoneObj`         | `ThermalZone (THRM)`                                                    |
|  BuffFieldObj      | `External (\_SB.PCI0._CRS.BBBB, BuffFieldObj` | `CreateField (AAAA, Zero, BBBB)`                                        |

> DDBHandleObj is rare, no discussion


## ASL CondRefOf

`CondRefOf` is useful to check the object is existed or not.

```swift
Method (SSCN, 0, NotSerialized)
{
    If (_OSI ("Darwin"))
    {
        ...
    }
    ElseIf (CondRefOf (\_SB.PCI0.I2C0.XSCN))
    {
        If (USTP)
        {
            Return (\_SB.PCI0.I2C0.XSCN ())
        }
    }

    Return (Zero)
}
```

The codes are quoted from **`SSDT-I2CxConf`**. When system is not MacOS, and `XSCN` exists under `I2C0`, it returns the orginal value.

## Conclusion
Hopefully this article assists you when editing DSDTs/SSDTs.
