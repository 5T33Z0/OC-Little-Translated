# ACPI Source Language (ASL) Basics
> This guide is quoted from a post on [PCBeta](<http://bbs.pcbeta.com/forum.php?mod=viewthread&tid=944566&archive=2&extra=page%3D1&page=1>) by suhetao. Published 2011-11-21.</br>
> Markdowned and proofreading by Bat.bat (williambj1) on 2020-2-14.

**TABLE of CONTENTS**

- [About ASL](#about-asl)
- [ASL Guidelines](#asl-guidelines)
  - [`DefinitonBlock`](#definitonblock)
  - [`External` References](#external-references)
  - [ACPI Preset Functions](#acpi-preset-functions)
    - [`_OSI` (Operating System Interfaces)](#_osi-operating-system-interfaces)
    - [`_STA` (Status)](#_sta-status)
    - [`_CRS` (Current Resource Settings)](#_crs-current-resource-settings)
  - [Common ASL Data Types](#common-asl-data-types)
  - [ASL Variables Definition](#asl-variables-definition)
  - [ASL Assignment](#asl-assignment)
  - [ASL Calculation](#asl-calculation)
  - [ASL Logic](#asl-logic)
  - [Defining Methods in ASL](#defining-methods-in-asl)
- [ASL flow Control](#asl-flow-control)
  - [Branch control `If` & `Switch`](#branch-control-if--switch)
    - [`If`](#if)
    - [`ElseIf`, `Else`](#elseif-else)
    - [`Switch`, `Case`, `Default`, `BreakPoint`](#switch-case-default-breakpoint)
  - [Loop control](#loop-control)
    - [`While` & `Stall`](#while--stall)
    - [`For`](#for)
  - [ASL CondRefOf](#asl-condrefof)
- [SSDT Loading Sequence](#ssdt-loading-sequence)
  - [Examples](#examples)
- [CREDITS and RESOURCES](#credits-and-resources)

## About ASL
The following information is based on the documentation of the [ACPI Specifications](https://uefi.org/specs/ACPI/6.4/) provided by the Unified Extensible Firmware Interface Forum (UEFI.org). Since I am not a developer, it is possible that there could be mistakes in the provided ASL examples.

A notable feature of `ACPI` is a specific proprietary language to compile ACPI tables. This language is called `ASL` (ACPI Source Language), which is at the center of this article. After an ASL is compiled, it becomes AML (ACPI Machine Language), which can be executed by the operating system. Since ASL is a language, it has its own rules and guidelines.

## ASL Guidelines
### `DefinitonBlock`

1. The variable defined in the `DefinitionBlock` must not exceed 4 characters, and not begin with digits. Just check any DSDT/SSDT – no exceptions.
2. `Scope` is similar to `{}`. There is one and there is only one `Scope`. Therefore, DSDT begins with:

   ```asl
   DefinitionBlock ("xxxx", "DSDT", 0x02, "xxxx", "xxxx", xxxx)
   {
   ```
   and is ended by

   ```asl
   }
   ```
   This is called the `Root Scope`.

The `xxxx` parameters refer to the `File Name`, `OEMID`, `Table ID` and `OEM Version`. The third parameter is based on the second parameter. As shown above, if the second parameter is **`DSDT`**, the third parameter must be `0x02`. Other parameters are free to fill in.

1. Methods and variables beginning with an underscore `_` are reserved for operating systems. That's why some ASL tables contain `_T_X` trigger warnings after decompiling.
2. A `Method` always contains either a `Device` or a `Scope`. As such, a `Method` _cannot_ be defined without a `Scope`. Therefore, the example below is **invalid** because the Method is followed by a `DefinitionBlock`:

   ```asl
   Method (xxxx, 0, NotSerialized)
   		{
       	...
   		}
   DefinitionBlock ("xxxx", "DSDT", 0x02, "xxxx", "xxxx", xxxx)
   {
       ...
   }
   ```
3. `\_GPE`,`\_PR`,`\_SB`,`\_SI`,`\_TZ` belong to root scope `\`.

   - `\_GPE` &rarr; ACPI Event handlers
   - `\_PR` &rarr; CPU
   - `\_SB` &rarr; Devices and Busses
   - `\_SI` &rarr; System indicator
   - `\_TZ` &rarr; Thermal zone

	Components with different attributes are placed below/inside the corresponding Scope. For example:
   - `Device (PCI0)` is placed inside `Scope (\_SB)`

     ```asl
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

     > CPUs can have various scopes, for instance `_PR`, `_SB`, `_SCK0`

     ```asl
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

      ```asl
      Scope (_GPE)
      {
          Method (_L0D, 0, NotSerialized)
          {
              ...
          }
          ...
      }
      ```
      Yes, methods can be placed here. Caution, methods beginning with **`_`** are reserved for operating systems.
5. `Device (xxxx)` also can be recognized as a scope, it contains various descriptions to devices, e.g. `_ADR`,`_CID`,`_UID`,`_DSM`,`_STA`.
6. Symbol `\` quotes the root scope; `^` quotes the superior scope. Similarly, `^` is superior to `^^`.
7. Symbol `_` is meaningless, it only completes the 4 characters, e.g. `_OSI`.
8. For better understanding, ACPI releases `ASL+(ASL2.0)`, it introduces C language's `+-*/=`, `<<`, `>>` and logical judgment `==`, `!=` etc.
9. Methods in ASL can accept up to 7 arguments; they are represented by `Arg0` to `Arg6` and cannot be customized.
10. Local variables in ASL can accept up to 8 arguments represented by `Local0`~`Local7`. Definitions are not necessary, but should be initialized, in other words, assignment is needed.

### `External` References

|  Quote Types   | External Reference | Addressed paramter
| :------------: | :----------------- | :----------------------- 
|   UnknownObj   | `External (\_SB.EROR, UnknownObj`             | (avoid to use)                                                          
|     IntObj     | `External (TEST, IntObj`                      | `Name (TEST, 0)`                                                        
|     StrObj     | `External (\_PR.MSTR, StrObj`                 | `Name (MSTR,"ASL")`                                                     
|    BuffObj     | `External (\_SB.PCI0.I2C0.TPD0.SBFB, BuffObj` | `Name (SBFB, ResourceTemplate ()`<br/>`Name (BUF0, Buffer() {"abcde"})` |
|     PkgObj     | `External (_SB.PCI0.RP01._PRW, PkgObj`        | `Name (_PRW, Package (0x02) { 0x0D, 0x03 })`
|  FieldUnitObj  | `External (OSYS, FieldUnitObj`                | `OSYS,   16,`                                                           
|   DeviceObj    | `External (\_SB.PCI0.I2C1.ETPD, DeviceObj`    | `Device (ETPD)`                                                         
|    EventObj    | `External (XXXX, EventObj`                    | `Event (XXXX)`                                                          
|   MethodObj    | `External (\_SB.PCI0.GPI0._STA, MethodObj`    | `Method (_STA, 0, NotSerialized)`                                       |
|    MutexObj    | `External (_SB.PCI0.LPCB.EC0.BATM, MutexObj`  | `Mutex (BATM, 0x07)`                                                    
|  OpRegionObj   | `External (GNVS, OpRegionObj`                 | `OperationRegion (GNVS, SystemMemory, 0x7A4E7000, 0x0866)`              |
|  PowerResObj   | `External (\_SB.PCI0.XDCI, PowerResObj`       | `PowerResource (USBC, 0, 0)`                                            |
|  ProcessorObj  | `External (\_SB.PR00, ProcessorObj`           | `Processor (PR00, 0x01, 0x00001810, 0x06)`                              |
| ThermalZoneObj | `External (\_TZ.THRM, ThermalZoneObj`         | `ThermalZone (THRM)`                                                    
|  BuffFieldObj  | `External (\_SB.PCI0._CRS.BBBB, BuffFieldObj` | `CreateField (AAAA, Zero, BBBB)`                                        |

### ACPI Preset Functions

#### `_OSI` (Operating System Interfaces)

It is easy to acquire the current operating system's name and version when applying the `_OSI` method. For example, we could apply a patch that is specific to Windows or macOS.

`_OSI` requires a string which must be picked from the table below.

|   OS                         |      String     |
| :-------------------------- | :------------- |
| macOS                        | `"Darwin"`      |
| Linux (and Linux-based OS) | `"Linux"`       |
| FreeBSD                      | `"FreeBSD"`     |
| Windows                      | `"Windows 20XX"`|

> Notably, different Windows versions require a unique string, read:  
> <https://docs.microsoft.com/en-us/windows-hardware/drivers/acpi/winacpi-osi>

When `_OSI`'s string matches the current system, it returns `1` since the `If` condition is valid.

```asl
If (_OSI ("Darwin")) /* judge if the current system is macOS */
```

#### `_STA` (Status)
**⚠️ CAUTION: Two types of `_STA` exist! Do not confuse it with `_STA` from `PowerResource`!**

5 types of bit can be return from `_STA` method, explanations are listed below:

Bit     | Explanation                          
:-----: | :----------------------------------- 
Bit [0] | Set if the device is present.
Bit [1] | Set if the device is enabled and decoding its resources.
Bit [2] | Set if the device should be shown in the UI.
Bit [3] | Set if the device is functioning properly (cleared if device failed its diagnostics).
Bit [4] | Set if the battery is present.

We need to transfer these bits from hexadecimal to binary. `0x0F` transferred to `1111`, meaning enable it(the first four bits); while `Zero` means disable. 

We also encounter `0x0B`,`0x1F`. `1011` is a binary form of `0x0B`, meaning the device is enabled and not is not allowed to decode its resources. `0X0B` often utilized in ***`SSDT-PNLF`***. `0x1F` (`11111`)only appears to describe battery device from laptop, the last bit is utilized to inform Control Method Battery Device `PNP0C0A` that the battery is present.

> In terms of `_STA` from `PowerResource`
>
> `_STA` from `PowerResource` only returns `One` or `Zero`. Please read `ACPI Specification` for detail.

#### `_CRS` (Current Resource Settings)
`_CRS` returns a `Buffer`, it is often utilized to acquire touchable devices' `GPIO Pin`,`APIC Pin` for controlling the interrupt mode.

### Common ASL Data Types

|    ASL    |
| :-------: |
| `Integer` |
| `String`  |
|  `Event`  |
| `Buffer`  |
| `Package` |

### ASL Variables Definition

- Define Integer:

  ```asl
  Name (TEST, 0)
  ```

- Define String:
  
  ```asl
  Name (MSTR,"ASL")
  ```

- Define Package:

  ```asl
  Name (_PRW, Package (0x02)
  {
      0x0D,
      0x03
  })
  ```

- Define Buffer Field (6 available types in total):</br>
	
	| Create statement |   size    | Syntax                           |
	| :--------------: | :-------: |----------------------------------|
	| CreateBitField   |  1-Bit    | CreateBitField (AAAA, Zero, CCCC)
	| CreateByteField  |  8-Bit    | CreateByteField (DDDD, 0x01, EEEE)
	| CreateWordField  |  16-Bit   | CreateWordField (FFFF, 0x05, GGGG)
	| CreateDWordField |  32-Bit   | CreateDWordField (HHHH, 0x06, IIII)
	| CreateQWordField |  64-Bit   | CreateQWordField (JJJJ, 0x14, KKKK)
	| CreateField      | any size. | CreateField (LLLL, Local0, 0x38, MMMM)

	It is not necessary to announce its type when defining a variable.

### ASL Assignment

```asl
Store (a,b) /* legacy ASL */
b = a      /*   ASL+  */
```
**Examples**:

```asl
Store (0, Local0)
Local0 = 0

Store (Local0, Local1)
Local1 = Local0
```

### ASL Calculation

|  ASL+  |  Legacy ASL|  Examples        
| :----: | :--------: |:------------------------------------------------------- |
|   +    |    Add     | `Local0 = 1 + 2`<br/>`Add (1, 2, Local0)`                                 |   -    |  Subtract  | `Local0 = 2 - 1`<br/>`Subtract (2, 1, Local0)`                            
|   *    |  Multiply  | `Local0 = 1 * 2`<br/>`Multiply (1, 2, Local0)`                            
|   /    |   Divide   | `Local0 = 10 / 9`<br/>`Divide (10, 9, Local1(remainder), Local0(result))` 
|   %    |    Mod     | `Local0 = 10 % 9`<br/>`Mod (10, 9, Local0)`                               
|   <<   | ShiftLeft  | `Local0 = 1 << 20`<br/>`ShiftLeft (1, 20, Local0)`                        
|   >>   | ShiftRight | `Local0 = 0x10000 >> 4`<br/>`ShiftRight (0x10000, 4, Local0)`             
|   --   | Decrement  | `Local0--`<br/>`Decrement (Local0)`                                       
|   ++   | Increment  | `Local0++`<br/>`Increment (Local0)`                                       
|   &    |    And     | `Local0 = 0x11 & 0x22`<br/>`And (0x11, 0x22, Local0)`                     
| &#124; |     Or     | `Local0 = 0x01`&#124;`0x02`<br/>`Or (0x01, 0x02, Local0)`                 
|   ~    |    Not     | `Local0 = ~(0x00)`<br/>`Not (0x00,Local0)`                                
|        |    Nor     | `Nor (0x11, 0x22, Local0)`                                                

Read `ACPI Specification` for more details

### ASL Logic

|  ASL+  |   Legacy ASL  | Examples                                                         
| :----: | :-----------:| :----------------------------------------------------|
|   &&   |     LAnd      |  `If (BOL1 && BOL2)`<br/>`If (LAnd(BOL1, BOL2))`                 
|   !    |     LNot      |  `Local0 = !0`<br/>`Store (LNot(0), Local0)`                     
| &#124; |      LOr      |  `Local0 = (0`&#124;`1)`<br/>`Store (LOR(0, 1), Local0)`         
|   <    |     LLess     |  `Local0 = (1 < 2)`<br/>`Store (LLess(1, 2), Local0)`            
|   <=   |  LLessEqual   |  `Local0 = (1 <= 2)`<br/>`Store (LLessEqual(1, 2), Local0)`      
|   >    |   LGreater    |  `Local0 = (1 > 2)`<br/>`Store (LGreater(1, 2), Local0)`         
|   >=   | LGreaterEqual |  `Local0 = (1 >= 2)`<br/>`Store (LGreaterEqual(1, 2), Local0)`   
|   ==   |    LEqual     |  `Local0 = (Local0 == Local1)`<br/>`If (LEqual(Local0, Local1))` 
|   !=   |   LNotEqual   |  `Local0 = (0 != 1)`<br/>`Store (LNotEqual(0, 1), Local0)`       

Only two results from logical calculation - `0` or `1`

### Defining Methods in ASL

1. Define a Method:

   ```asl
   Method (TEST)
   {
       ...
   }
   ```

2. Defines a method containing 2 parameters and applies local variables `Local0`~`Local7`

   Numbers of parameters are defaulted to `0`

   ```asl
   Method (MADD, 2)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local7
   }
   ```

3. Define a method contains a return value:
  
   ```asl
   Method (MADD, 2)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1
  
       Return (Local0) /* return here */
   }
   ```

   ```asl
   Local0 = 1 + 2            /* ASL+ */
   Store (MADD (1, 2), Local0)  /* Legacy ASL */
   ```

4. Define serialized method:

   If not define `Serialized` or `NotSerialized`, default as `NotSerialized`

   ```asl
   Method (MADD, 2, Serialized)
   {
       Local0 = Arg0
       Local1 = Arg1
       Local0 += Local1
       Return (Local0)
   }
   ```

   It looks like `multi-thread synchronization`. In other words, only one instance can exist in the memory when the method is stated as `Serialized`. Normally the application creates one object, for example:

   ```asl
   Method (TEST, Serialized)
   {
       Name (MSTR,"I will succeed")
   }
   ```

   If we state `TEST` as shown above and call it from two different methods:

   ```asl
   Device (Dev1)
   {
        TEST ()
   }
   Device (Dev2)
   {
        TEST ()
   }
   ```
   If we execute `TEST` in `Dev1`, then `TEST` in `Dev2` will wait until the first one finalized. If we state:

   ```asl
   Method (TEST, NotSerialized)
   {
       Name (MSTR, "I will succeed")
   }
   ```

   when one of `TEST` called from `Devx`, another `TEST` will be failed to create `MSTR`.

## ASL flow Control

ASL also has methods to control flow.

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

   ```asl
   If (_OSI ("Darwin"))
   {
       OSYS = 0x2710
   }
   ```

#### `ElseIf`, `Else`

   The following codes check if the system is `Darwin`, and if the system is not `Linux`, if yes then `OSYS = 0x07D0`

   ```asl
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

   ```asl
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

```asl
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

```asl
for (local0 = 0, local0 < 8, local0++)
{
    ...
}
```

`For` shown above and `While` shown below are equivalent

```asl
Local0 = 0
While (Local0 < 8)
{
    Local0++
}
```

### ASL CondRefOf

`CondRefOf` is useful to check the object is existed or not.

```asl
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

The codes are quoted from **`SSDT-I2CxConf`**. When system is not MacOS, and `XSCN` exists under `I2C0`, it returns the original value.

## SSDT Loading Sequence

Typically, SSDT patches are targeted at the machine's ACPI (either the DSDT or other SSDTs). Since the original ACPI is loaded prior to SSDT patches, there is no need for SSDTs in the `Add` list to be loaded in a specific order. But there are exceptions to this rule. For example, if you have 2 SSDTs (SSDT-X and SSDT-Y), where SSDT-X defines a `device` which SSDT-Y is "cross-referencing" via a `Scope`, then these the two patches have to be loaded in the correct order/sequence for the whole patch to work. Generally speaking, SSDTs being "scoped" into have to be loaded prior to the ones "scoping".

### Examples

- **Patch 1**：***SSDT-XXXX-1.aml***
  
  ```asl
  External (_SB.PCI0.LPCB, DeviceObj)
  Scope (_SB.PCI0.LPCB)
  {
      Device (XXXX)
      {
          Name (_HID, EisaId ("ABC1111"))
      }
  }
  ```
- **Patch 2**：***SSDT-XXXX-2.aml***

  ```asl
  External (_SB.PCI0.LPCB.XXXX, DeviceObj)
  Scope (_SB.PCI0.LPCB.XXXX)
  {
        Method (YYYY, 0, NotSerialized)
       {
           /* do nothing */
       }
    }
  ```
- SSDT Loading Sequence in `config.plist` under `ACPI/Add`: 

  ```XML
  Item 1
            path    <SSDT-XXXX-1.aml>
  Item 2
            path    <SSDT-XXXX-2.aml>
  ```

## CREDITS and RESOURCES
- Original [**ASL Guide**](https://bbs.pcbeta.com/forum.php?mod=viewthread&tid=944566&archive=2&extra=page%3D1&page=1) by suhetao
- ACPI [**Specifications**](https://uefi.org/htmlspecs/ACPI_Spec_6_4_html/) by uefi.org
- ASL Tutorial by acpica.org ([**PDF**](https://acpica.org/sites/acpica/files/asl_tutorial_v20190625.pdf)). Good starting point if you want to get into fixing your `DSDT` with `SSDT` hotpatches.
