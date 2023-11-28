# Sound Card IRQ Patches (`SSDT-HPET`)

## Description
Sound cards of older systems (mobile Ivy Bridge for example) require High Precision Event Timer **HPET** (`PNP0103`) to provide interrupts `0` and `8`, otherwise the sound card won't work, even if `AppleALC.kext` is present and the correct layout-id is used. That's because `AppleHDA.kext` is not loaded (only `AppleHDAController.kext` is). But the issue can occur on newer platforms as well. This is due to the fact that `HPET` is a legacy device from earlier Intel platforms (1st to 6th Gen Intel Core) that is only present in 7th gen an newer for backward compatibility with older versions of Windows. If you are using Windows 8.1 or newer with a 7th Gen Intel Core or newer CPU, **HPET** (High Precision Event Timer) is no no present in Device Manager (the driver is unloaded).

In most cases, almost all machines have **HPET** without any interrupts. Usually, interrupts `0` & `8` are occupied by **RTC** (`PNP0B00`) or **TIMR** (`PNP0100`) respectively. To solve this issue, we need to fix **HPET**, **RTC** and **TIMR** simultaneously.

For macOS 10.12 and newer, if the problem occurs on the 6th Gen, `HPET` can be blocked directly to solve the problem. Check the original DSDT's HPET `_STA` method for specific settings.

### Symptoms
- `Lilu.kext` is loaded
- `AppleALC.kext` is loaded
- Layout-Id is preseni in `boot-args` or `DeviceProperties`
- In some cases: `SSDT-HPET` and patches are also present
- &rarr; **But**: NO Sound!

## Patching Principle

- Disable **HPET**, **RTC**, **TIMR** and **PIC/IPIC** (optional)
- Create fake **HPE0**, **RTC0**, **TIM0**.
- Remove `IRQNoFlags (){8}` from **RTC0** and `IRQNoFlags (){0}` from **TIM0** and add them to **HPE0**.

### Patching Methods

Two methods for fixing **HPET** and **IRQs** exist:

1. **Semi-Automated patching** using the python script SSDTTime (simple, for novice users).</br>
**Advantage**: No ACPI skills required.</br>
**Disadvantage**: Requires binary renames, so it's not as clean as using method 2, which is completely ACPI-based.
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

> [!NOTE]
>
> If you are editing your config with [**OpenCore Auxiliary Tools**](https://github.com/ic005k/QtOpenCoreConfig/releases), you can either drag files (.aml, .kext, .efi) into the respective section of the GUI to add them to the EFI/OC folder and config.plist. Alternatively, you can just copy SSDTs, Kexts, and Drives to the corresponding sections of EFI/OC and the changes will be reflected in the config.plist since OCAT monitors this folder.

### Troubleshooting
Some implementations of ACPI, e.g. the Lenovo T530 (Ivy Bridge), can't handle the form the IRQ flags are injected by **SSDT-HPET.aml** generated with SSDTTime which looks like this:

```asl
...
{	
    IRQNoFlags ()
    {0,8,11}
...
```
So if you don't have sound after injecting **SSDT-HPET**, the required binary renames, kexts and ALC Layout-ID, change the formatting of the IRQNoFlags section to:

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

- The sound card on earlier machines require **HPET** (`PNP0103`) to provide interrupts `0` and `8`, otherwise the sound card will not work properly. In general, almost all machines have **HPET** without any interrupts provided. Usually, interrupts `0` and `8` are occupied by **RTC** (`PNP0B00`), **TIMR** (`PNP0100`) respectively.
- To solve this problem, we need to fix **HPET**, **RTC** and **TIMR** simultaneously. This can be achieved by ***SSDT-HPET_RTC_TIMR-fix***.
- In cases where `HPET` can't be disabled easily (because different conditions have to be met first=, binary renames and ***SSDT-HPET_RTC_TIMR_WNTF_WXPF*** are required.

> [!NOTE]
> 
> ThinkPad users might want to test ***SSDT-IRQ_FIXES_THINK*** first which doesn't require any binary renames.

### Method 2.1: Patching with ***SSDT-HPET_RTC_TIMR-fix***

***SSDT-HPET_RTC_TIMR-fix*** does the following:

- It disables the original `HPET`, `RTC` and `TMR` devices if macOS is running
- Adds and enables `HPE0`, `RTC0` and `TIM0` if macOS is running.

#### Disabling **`HPET`**
Usually, `_STA` exists for HPET, so disabling `HPET` requires changing the Preset Variable `HPAE`/`HPTE` to `0`:

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
> - The `HPAE`/`HPTE` variable within `_STA` may vary from machine to machine.
> - If the HPET device is not controlled via `HPAE` or `HPTE` use Method 2.2 or 2.3
> - If you have an older Lenovo ThinkPad, try Method 2.2 first!
  
#### Disabling **`RTC`**
Disable the Realtime Clock by changing it's status (`_STA`) to zero if macOS is running:

```asl
Method (_STA, 0, NotSerialized)
{
	If (_OSI ("Darwin"))
	{
		Return (ZERO)
	}
	Else
	{
		Return (0x0F)
	}
}
```
#### Disabling **`TIMR`**
(&rarr; Same principle as **Disabling `RTC`** applies)

#### Disabling **`PIC`**/ **`IPIC`** (optional)

The Programmable Interrupt Controller (`PIC` or `IPIC`) is responsible for managing interrupts. The PIC receives interrupts from various devices and routes them to the CPU, allowing the CPU to efficiently handle multiple events simultaneously.

If the three-in-one patch alone does not fix audio, add ***SSDT-IPIC*** as well. It disables an existing `IPIC`/`PIC` device and adds a fake one instead (`IPI0`). It also contains `IRQNoFlags{2}` (must be uncommented to enable). Adjust the device name and path to mach the one used in your `DSDT`.

### Method 2.2: Patching with ***SSDT-IRQ_FIXES_THINK*** if `HPAE/HPTE` does not exist

I recently found this fix which doesn't require any binary renames. On a lot of Lenovo ThinkPads with Intel CPUs prior to Kaby Lake, the status of the `HPET` device is not controlled by the `HPAE/HPTE` preset variable but rather by **2 different variables**, namely: `WNTF` and `WXPF`, as shown below (found in Lenovo T430/T530 to T450/550 and T460s): 

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
In order to disable `HPET`, you can disable it by changing the values for `WNTF` and `WXPF`:

```asl
Scope (_SB.PCI0.LPC.HPET)
{
	If (_OSI ("Darwin"))
	{
		WNTF = One
		WXPF = Zero
	}
}
...

```
This is exactly what ***SSDT-IRQ_FIXES_THINK*** does: it disable `HPET`, `RTC`, `TIMR` and `IPIC`/`PIC` and injects fake versions of them, if macOS is running. If the combination for `WNTF` and `WXPF` used in the SSDT does not work, try other combinations – there are 4 possible combination for disabling `HPET`:

1. **WNTF** = One and **WXPF** = One (unlikely to work)
2. **WNTF** = Zero and **WXPF** = Zero (didn't work for me)
3. **WNTF** = One and **WXPF** = Zero (worked for my Lenovo T530)
4. **WNTF** = Zero and **WXPF** = One

#### Instructions

- Open ***SSDT-IRQ_FIXES_THINK*** and adjust LPC/LPCB paths according to the paths and device names used in your `DSDT`
- Export the SSDT as .aml
- Add it to `EFI/OC/ACPI` and your config.plist
- Save your config and reboot.

Sound should work afterwads.

### Method 2.4: Renaming `If ((\WNTF && !\WXPF))` to `If (_OSI ("Darwin"))`

I stumbled over this method recently in a T460s config. I would consider this as a brute-force approach which I wouldn’t recommend. Basically, it uses a binary rename to turn this part of the `DSDT`…

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
    Comment: HPET (\WNTF\!WXPF) to _OSI("Darwin"))
    Find: A010905C574E5446925C57585046
    Replace: A00F5F4F53490D44617277696E00
    Table Signature: 44534454
    ```
- Add `SSDT-HPET_RTC_TIMR-fix.aml` to `EFI/OC/ACPI` and your config.plist
- **Optional**: add `SSDT-IPIC.aml` if sound still doesn't work after rebooting.
- Save your config and reboot.

## Notes
- The names and paths of the `LPC/LPCB` bus as well as `RTC`, `TMR`, `RTC` and `IPIC` devices used in the hotpatch must match the names and paths used in your system's DSDT `DSDT`.
- To find out which Layout-ID is used by your machine, look up your CODEC (sorted by manufacturer) on this repo: https://github.com/dreamwhite/ChonkyAppleALC-Build
- The IRQ and RTC fixes used here cannot be combined with other RTC fixes, such as:
  - ***SSDT-AWAC*** and ***SSDT-AWAC-ARTC***
  - ***SSDT-RTC0*** and ***SSDT-RTC0-NoFlags***

## Credits
- CorpNewt for SSDTTime
