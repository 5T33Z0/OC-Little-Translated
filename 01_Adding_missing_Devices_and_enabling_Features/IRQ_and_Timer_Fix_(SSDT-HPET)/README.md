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
2. **Manual patching** (complicated, aimed at advanced users)</br>
**Advantages**: May not require binary renames, is fully ACPI-compliant and can be applied to macOS only.</br>
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
> - If the HPET device is not controlled via `HPAE` or `HPTE` use Method 2.2 or 2.3 (for ThinkPads)
> - If you have an older Lenovo ThinkPad, try Method 2.3 first!
  
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

### Method 2.2: Patching with ***SSDT-HPET_RTC_TIMR_WNTF_WXPF***

#### If `HPAE/HPTE` does not exist
On a lot of Lenovo ThinkPads with Intel CPUs prior to Kaby Lake, where the original `HPET` device cannot be disabled easily because the preset variable `HPAE/HPTE` to turn it off does not exist. Instead, its on/off state is controlled by **different variables**, namely: `WNTF` and `WXPF`, as shown below (found in Lenovo T430/T530 to T450/550 and T460s): 

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
In this case, `HPET` can’t be disabled simply by setting it to `0x00`. Instead, you have to get rid of the ***conditions*** that enables it first – in this case `WNTF` and `WXPF`. To do so, you can add binary renames to your `config.plist` under `ACPI/Patch` so that the 2 variables are renamed to `XXXX` and `YYYY` so they have no matches any more. There's another, much more elegant (Method 2.3) that doesn't require *any* binary renames, which I will discuss later:

- Rename `WNTF` to `XXXX` in `HPET`:
	```text
	Comment: HPET WNTF to XXXX
	Find: 574E5446
	Replace: 58585858
	Base: \_SB.PCI0.LPC.HPET (adjust LPC bus path accordingly)
	```
- Rename `WXPF` to `YYYY` in `HPET`:
	```text
	Comment: HPET WXPF to YYYY
	Find: 57585046
	Replace: 59595959
	Base: \_SB.PCI0.LPC.HPET (adjust LPC bus path accordingly)
	```
- Next, you need to add `SSDT-HPET_RTC_TIMR_WNTF_WXPF.aml` to fix the RTC, TIMER, HPET restore the 2 variables `WNTF` and `WXPF` for when macOS is NOT running. This is handled by the following bit:

	```asl    
    Scope (\)
    {
        Name (XXXX, One)
        Name (YYYY, Zero)
        If (!_OSI ("Darwin"))
        {
            XXXX = WNTF /* External reference */
            YYYY = WXPF /* External reference */
        }
    } ...
	```

> [!IMPORTANT]
> 
> The "!" in the "If (!_OSI ("Darwin"))" statement is not a typo but a logical NOT operator! It actually means: if the OS *is not* Darwin, use variables `WNTF` instead of `XXXX` and `WXPF` instead of `YYYY`. This restores the 2 variables for any other kernel than Darwin so everything is back to normal.

### Method 2.3: Patching with ***SSDT-IRQ_FIXES_THINK***
This SSDT is a refined and more elegant variant of ***SSDT-HPET_RTC_TIMR_WNTF_WXPF*** that doesn’t require any binary renames. It disables `HPET`, `RTC`, `TIMR` and `PIC` devices and adds fake ones instead. It can be used on older Lenovo ThinkPads (pre Kaby Lake) but It might work on other systems that use `WNTF` and `WXPF` to control the status of `HPET` as well. Adjust LPC/LPCB paths and device names accordingly.

#### If `HPAE/HPTE` does not exist

I was wondering if it would be possible to achieve the same as described in Method 2.2 but *without* using binary renames. Because it feels redundant to rename 2 parameters system-wide just to *restore them for every other OS*, instead of changing their values *for macOS only*. So I disabled the binary renames, swapped the positions of `XXXX` and `YYYY` around and incorporated `If (_OSI ("Darwin"))`. The effect is the same: it changes `WNTF` to `XXXX` and `WXPF` to `YYYY` if macOS is running – no binary renames are required. I named this new SSDTs ***SSDT-IRQ_FIXES_THINK***. This actually works and the relevant code snippet looks like this:

```asl
Scope (_SB.PCI0.LPC.HPET)
{
	Name (XXXX, One)
        Name (YYYY, Zero)
        If (_OSI ("Darwin"))
        {
            WNTF = XXXX 
            WXPF = YYYY
        }
} ...
```

#### Instructions

- Open ***SSDT-IRQ_FIXES_THINK*** and adjust LPC/LPCB paths according to your `DSDT`
- Export the SSDT as .aml
- Add it to `EFI/OC/ACPI` and your config.plist
- Save your config and reboot.

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
- [racka98](https://github.com/racka98) for ***SSDT-HPET_RTC_TIMR_WNTF_WXPF.dsl***
