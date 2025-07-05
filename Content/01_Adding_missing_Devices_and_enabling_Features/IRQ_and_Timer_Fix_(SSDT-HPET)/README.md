# Sound Card IRQ Patches (`SSDT-HPET`)

- [Description](#description)
- [Patching Principle](#patching-principle)
  - [Symptoms for Audio issues](#symptoms-for-audio-issues)
  - [Patching Methods](#patching-methods)
- [1. Semi-Automated patching (using SSDTTime)](#1-semi-automated-patching-using-ssdttime)
  - [Troubleshooting](#troubleshooting)
- [2. Manual patching methods](#2-manual-patching-methods)
  - [Method 2.1: Patching with ***SSDT-HPET\_RTC\_TIMR-fix***](#method-21-patching-with-ssdt-hpet_rtc_timr-fix)
    - [Disabling **`HPET`**](#disabling-hpet)
    - [Disabling **`RTC`**](#disabling-rtc)
    - [Disabling **`TIMR`**](#disabling-timr)
    - [Disabling **`PIC`**/ **`IPIC`** (optional)](#disabling-pic-ipic-optional)
  - [Method 2.2: Patching with ***SSDT-IRQ\_FIXES\_THINK*** if `HPAE/HPTE` does not exist](#method-22-patching-with-ssdt-irq_fixes_think-if-hpaehpte-does-not-exist)
    - [Explanation](#explanation)
    - [Pre-requisites](#pre-requisites)
    - [Instructions](#instructions)
  - [Method 2.3: Renaming `If ((\WNTF && !\WXPF))` to `If (_OSI ("Darwin"))`](#method-23-renaming-if-wntf--wxpf-to-if-_osi-darwin)
    - [Instructions](#instructions-1)
- [Notes](#notes)
- [Credits](#credits)

---

## Description
Sound cards of older systems (pre Kaby Lake) require High Precision Event Timer **HPET** (`PNP0103`) to provide interrupts `0` and `8`, otherwise the sound card won't work, even if `AppleALC.kext` is present and the correct layout-id is used. That's because `AppleHDA.kext` is not loaded (only `AppleHDAController.kext` is). 

`HPET` is a legacy device from earlier Intel platforms (1st to 6th Gen Intel Core) that is only kept in ACPI tables of newer systems (Kaby Lake or newer) for backward compatibility with Windows XP and older. When running Windows Vista or newer on a system with a 7th Gen or newer Intel CPU, **HPET** (High Precision Event Timer) is disabled by default – even if it's present in the `DSDT`.

In most cases, almost all machines have **HPET** without any interrupts. Usually, interrupts `0` & `8` are occupied by **RTC** (`PNP0B00`) or **TIMR** (`PNP0100`) respectively. To get audio working in macOS, we need to fix **HPET**, **RTC** and **TIMR** simultaneously with the SSDTs provided in this chapter. 

If the `HPET` device is controlled by the `_STA` method, it can be disabled easily by changing its `_STA` to `Zero` for macOS and then block `SSDT-HPET` from loading. But on older systems (pre Kaby Lake), the HPET feature might be controlled by other preset variables (or combinations thereof) instead, so disabling it is not that trivial.

> [!TIP]
> 
> If you are uncomfortable with working with ACPI tables, I recommend using **SSDTTime** to generate fixes. But if you are interested to fix audio issues without using any binary renames (which is he most non-invasive approach), then try manual patching. 

## Patching Principle

- Disable **HPET**, **RTC**, **TIMR** and **PIC/IPIC** (optional)
- Add fake **HPE0**, **RTC0**, **TIM0** and **PIC/IPIC** (optional) devices.
- Remove `IRQNoFlags (){8}` from **RTC0** and `IRQNoFlags (){0}` from **TIM0** and add them to **HPE0**.

### Symptoms for Audio issues
- `Lilu.kext` is loaded
- `AppleALC.kext` is loaded
- Layout-Id is present in `boot-args` or `DeviceProperties`
- In some cases: `SSDT-HPET` and binary renames generatd with SSDTTime are present

&rarr; **But**: NO Sound!

### Patching Methods

Two approaches for fixing **HPET** and **IRQs** are covered here:

1. **Semi-Automated patching** using the python script SSDTTime (simple, for novice users).</br>
**Advantage**: No ACPI skills required.</br>
**Disadvantage**: Requires binary renames – applied system-wide, so it's not as clean as using Method 2, which is completely ACPI-based.
2. **Manual patching**: Simple </br>
**Advantages**: Does not require binary renames, is fully ACPI-compliant and can be applied to macOS only.</br>
**Disadvantage**: Requires analysis of the DSDT and adjustments of the SSDT sample.

## 1. Semi-Automated patching (using SSDTTime)

Since the manual patching method described below is rather complicated, the semi-automated approach using **SSDTTime** which can generate `SSDT-HPET` is preferred in most cases.

**HOW TO:**

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Press <kbd>D</kbd>, drag in your system's DSDT and hit and hit <kbd>Enter</kbd>
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside the `SSDTTime-master` Folder along with `patches_OC.plist`.
5. Copy the generated SSDTs to `EFI/OC/ACPI`
6. Open `patches_OC.plist` and copy the included entries to the corresponding sections of your `config.plist`.
7. Save and Reboot.

Audio should work now (assuming Lilu and AppleALC kexts are present along with the correct layout-id for your on-board audio card).

> [!TIP]
>
> If you are using [**OpenCore Auxiliary Tools**](https://github.com/ic005k/QtOpenCoreConfig/releases) to edit your config.plist, you can drag files (.aml, .kext, .efi) into the respective section of the GUI to add them to the EFI/OC folder and config.plist. Alternatively, you can just copy SSDTs, Kexts, and Drives to the corresponding sections of EFI/OC and the changes will be reflected in the config.plist since OCAT monitors this folder.

### Troubleshooting
Some implementations of ACPI, e.g. on the Lenovo T530 (Ivy Bridge), can't handle the form the IRQ flags are notated in the **SSDT-HPET.aml** generated by SSDTTime, which looks like this:

```asl
...
{	
    IRQNoFlags ()
    {0,8,11}
...
```
So if you don't have sound after injecting **SSDT-HPET**, the required binary renames, kexts and ALC Layout-ID, change the formatting of the `IRQNoFlags` section to this:

```asl
...
{
    IRQNoFlags ()
        {0}
    IRQNoFlags ()
        {8}
    IRQNoFlags ()
        {11}
...
``` 
Save the file and reboot. Sound should work now. If it's not working, then the issue must be something else.

## 2. Manual patching methods
Below you will find a guide for fixing IRQ issues manually if you don't want to use SSDTTime.

- The sound card on machines prior to Kaby Lake require **HPET** (`PNP0103`) to provide interrupts `0` and `8` in order to work properly. In general, almost all machines have **HPET** without any interrupts provided. Usually, interrupts `0` and `8` are occupied by **RTC** (`PNP0B00`), **TIMR** (`PNP0100`) respectively.
- To solve this problem, **HPET**, **RTC** and **TIMR** have to be fixed simultaneously. This can be achieved by ***SSDT-HPET_RTC_TIMR-fix***.
- In cases where `HPET` can't be disabled easily (because a specific conditions has to be met first), try Method 2.2.

> [!IMPORTANT]
> 
> If you previously used SSDTTime to fix `HPET`, you need to revert these changes prior to using any of the manual patching methods. So disable `SSDT-HPET` and any binary renames associated with it!

> [!TIP]
> 
> ThinkPad users might want to try ***SSDT-IRQ_FIXES_THINK*** first to fix audio issues!

### Method 2.1: Patching with ***SSDT-HPET_RTC_TIMR-fix***

***SSDT-HPET_RTC_TIMR-fix*** does the following:

- It disables the original `HPET`, `RTC` and `TMR` devices if macOS is running
- Adds and enables `HPE0`, `RTC0` and `TIM0` if macOS is running.

#### Disabling **`HPET`**
Usually, `_STA` exists for `HPET`, so disabling it only requires changing the preset variable `HPAE` to `0` (or `HPTE`, depending on your `DSDT`):

```asl
External (HPAE, IntObj) /* or External (HPTE, IntObj) */
Scope (\)
    {
    	If (_OSI ("Darwin"))
    	{
    	HPAE =0 /* or HPTE =0 */
    	}
    }
```
> [!CAUTION]
> 
> - The `HPAE`/`HPTE` preset variable within `_STA` may vary from machine to machine.
> - If the `HPET` is controlled by more than on preset variable that formulate a specific condition that has to be met in order to disable `HPET`, try Method 2.2 or 2.3 instead!
> - If you have an older Lenovo ThinkPad, Method 2.2 will work!
  
#### Disabling **`RTC`**
Disable the Realtime Clock by changing its status (`_STA`) to zero if macOS is running:

```asl
Method (_STA, 0, NotSerialized)
{
    If (_OSI ("Darwin"))
    {
        Return (Zero)
    }
    Else
    {
        Return (0x0F)
    }
}
...
```
#### Disabling **`TIMR`**
(&rarr; Same principle as **Disabling `RTC`** applies)

#### Disabling **`PIC`**/ **`IPIC`** (optional)

The Programmable Interrupt Controller (`PIC` or `IPIC`) is responsible for managing interrupts. It receives interrupts from various devices and routes them to the CPU, allowing the CPU to efficiently handle multiple events simultaneously.

If the three-in-one patch alone does not fix audio, add ***SSDT-IPIC*** as well. It disables an existing `IPIC`/`PIC` device and adds a fake one instead (`IPI0`). It also contains `IRQNoFlags{2}` (must be uncommented to enable). Adjust the device name and path to mach the one used in your `DSDT`.

### Method 2.2: Patching with ***SSDT-IRQ_FIXES_THINK*** if `HPAE/HPTE` does not exist

I recently devloped this fix which doesn't require *any* binary renames. On a lot of Lenovo ThinkPads with Intel CPUs prior to Kaby Lake, the status of the `HPET` device is not controlled by the preset varible `HPAE/HPTE` but by **2 different variables at the same time** instead, namely: `WNTF` and `WXPF`, as shown below (found in Lenovo T430/T530 to T450/550 and T460s): 

```asl
Device (HPET)
{
    Name (_HID, EisaId ("PNP0103") 
    Method (_STA, 0, NotSerialized)  // _STA: Status
    {
        If ((\WNTF && !\WXPF))
        {
            Return (0x00)
 ...
```

#### Explanation

`WNTF` and `WXPF` are flags that help the ACPI system to determine the *compatibility* and *appropriateness* of using the HPET feature on the hardware based on the specific version of Windows installed. The condition `If ((\WNTF && !\WXPF))` is being checked to determine the action regarding `HPET` configuration, i.e. whether or not to enable or disable it based on the used Windows version. So disablibg `HPET` requiews the correct combination of values for *both* preset variables. 

- **`WNTF`** (Wake No Timer Flag): This flag is used to indicate whether `HPET` should be enabled for ***older*** versions of Windows (XP and older) or not. **If `WNTF` is set, it means that `HPET` should not be used or enabled for wake timer events**.
- **`WXPF`** (Wake X Power Flag): Similarly, `WXPF` is used for ***newer*** versions of Windows (Vista or newer) to determine whether `HPET` should be enabled for power events. **If `WXPF` is set, it means that `HPET` should not be used or enabled for wake on power events**. 

But the condition `If ((\WNTF && !\WXPF))` is a bit tricky to comprehend because it operates with a combination (`&&`) of a negation (`/`) and an opposition (`!`) which can twist a knot in one's brain. In this case, `\WNTF` being **false** or **unset** would imply that the **Wake No Timer Flag is not active**, whereas `!\WXPF` implies the **opposite of the Wake X Power Flag** is true (Wake X Power Flag is not active or false). 

In other words, `If (\WNTF && !\WXPF)` means: **"If the Wake No Timer Flag is active and the Wake X Power Flag is not active, then disable `HPET` (Return `0x00`)"**.

So, in order to disable `HPET`, you only have to change the values for for the preset variable `WNTF` and `WXPF`, which is super simple:

```asl
Scope (_SB.PCI0.LPC.HPET)
{
    If (_OSI ("Darwin"))
        {
            WNTF = One // Sets Wake no Timer to true in macOS 
            WXPF = Zero // Sets Wake X Power Flag to false in macOS
        }
}
...
```
This condition indicates that the Wake No Timer Flag is active (`WNTF` = **One**), which implies that the system should not use the timer to wake up. Meanwhile, the Wake X Power Flag is not active (`WXPF` = **Zero**), suggesting that `HPET` should not be used for power events. Therefore, in this scenario, `HPET` will be turned off in macOS.

This is exactly what ***SSDT-IRQ_FIXES_THINK*** does: it disable the original `HPET`, `RTC`, `TIMR` and `IPIC`/`PIC` devices and injects fake/corrected ones instead, if macOS is running.

#### Pre-requisites
Revert previous fixes:

- Disable/delete `SSDT-HPET` (or `SSDT-HRTF`) if present
- Disable binary renames associatted with `SSDT-HPET` (or `SSDT-HRTF`), such as: "CRS to XRCS rename", "IRQ…" or "HPET (\WNTF\!WXPF) to _OSI("Darwin"))"

#### Instructions

- Open ***SSDT-IRQ_FIXES_THINK.dsl*** and adjust LPC/LPCB paths according to the paths and device names used in your `DSDT`
- Export the SSDT as .aml
- Add it to `EFI/OC/ACPI` and your config.plist
- Save your config and reboot.

Sound should work afterwads. 

> [!NOTE]
> 
> If audio doesn't work after rebooting, you have to uncomment the `IRQNoFlags` code snippet for the `IPIC`/`PIC` device in the .dsl file, export it as .aml, replace `SSDT-IRQ_FIXES_THINK.aml` and reboot.

### Method 2.3: Renaming `If ((\WNTF && !\WXPF))` to `If (_OSI ("Darwin"))`

I stumbled over this method recently in a T460s config. I would consider this as a brute-force approach to fixing audio issues which I wouldn’t recommend. Because the original conditions that determine whether or not to use the HPET feature if Windows is running gets lost completely. So when running Windows XP or older, ACPI errors might occur since it's undefined what happens with HPET if macOS is not running.

Basically, this patch uses a binary rename to turn this part of the `DSDT`…

```asl
Device (HPET)
{
    Name (_HID, EisaId ("PNP0103") 
    Method (_STA, 0, NotSerialized)  // _STA: Status
    {
        If ((\WNTF && !\WXPF))
        {
            Return (0x00)
        ...
```   

into this:

```asl
Device (HPET)
{
    Name (_HID, EisaId ("PNP0103") 
    Method (_STA, 0, NotSerialized)  // _STA: Status
    {
        If (_OSI ("Darwin"))
        {
            Return (0x00)
        ...
```   

#### Instructions

- Add the following rename rule to your config.plist (under `ACPI/Patch`):
    ```
    Comment: Change HPET (\WNTF !WXPF) to _OSI("Darwin"))
    Find: A010905C574E5446925C57585046
    Replace: A00F5F4F53490D44617277696E00
    Table Signature: 44534454
    ```
- Add `SSDT-HPET_RTC_TIMR-fix.aml` to `EFI/OC/ACPI` and your config.plist
- Save your config and reboot.

> [!NOTE]
>
> Add `SSDT-IPIC.aml` if sound still doesn't work after rebooting. Adjust ACPI name and path accordingly.

## Notes
- The names and paths of the `LPC/LPCB` bus as well as `RTC`, `TMR`, `RTC` and `IPIC` devices used in the hotpatch must match the names and paths used in your system's DSDT `DSDT`.
- To find out which Layout-ID is used by your machine, look up your CODEC (sorted by manufacturer) on this repo: https://github.com/dreamwhite/ChonkyAppleALC-Build
- The IRQ and RTC fixes used here cannot be combined with other RTC fixes, such as:
  - ***SSDT-AWAC*** and ***SSDT-AWAC-ARTC***
  - ***SSDT-RTC0*** and ***SSDT-RTC0-NoFlags***

## Credits
- CorpNewt for SSDTTime
