# Sound Card IRQ Patches (`SSDT-HPET`)

## Description

Sound cards of older systems (mobile Ivy Bridge for example) require High Precision Event Timer **HPET** (`PNP0103`) to provide interrupts `0` and `8`, otherwise the sound card won't work, even if `AppleALC.kext` is present and the correct layout-id is used. That's because `AppleHDA.kext` is not loaded (only `AppleHDAController.kext` is).

In most cases, almost all machines have **HPET** without any interrupts. Usually, interrupts `0` & `8` are occupied by **RTC** (`PNP0B00`) or **TIMR** (`PNP0100`) respectively. To solve this issue, we need to fix **HPET**, **RTC** and **TIMR** simultaneously.

But the issue can occur on newer platforms as well. This is due to the fact that `HPET` is a legacy device from Intel's 6th Gen platform and is only present for backward compatibility with older Windows versions. If you use 7th Gen Intel Core CPU or newer with Windows 8.1+, HPET (High Precision Event Timer) is no longer present in Device Manager (the driver is unloaded).

For macOS 10.12 and newer, if the problem occurs on the 6th Gen, `HPET` can be blocked directly to solve the problem. Check the original DSDT's HPET `_STA` method for specific settings.

## Patching Principle

- Disable **HPET**, **RTC**, **TIMR** and **PIC/IPIC** (optional)
- Create fake **HPE0**, **RTC0**, **TIM0**.
- Remove `IRQNoFlags (){8}` from **RTC0** and `IRQNoFlags (){0}` from **TIM0** and add them to **HPE0**.

### Patching Methods

Two methods for fixing **HPET** and **IRQs** exist:

1. **Automated method** using the python script SSDTTime (simple, for novice users).</br>
**Advantage**: No ACPI skills required.</br>
**Disadvantage**: Requires binary renames, so it's not as clean as using method 2, which is completely ACPI-based.
2. **Manual method** (complicated, aimed at advanced users)</br>
**Advantages**: Doesn't require binary renames, is fully ACPI-compliant and can be applied to macOS only.</br>
**Disadvantage**: Requires analysis of the DSDT and adjustments of the SSDT sample.

## 1. Automated Method (using SSDTTime)

The manual patching method described below is rather complicated, because the patching process can now be automated using **SSDTTime** which can generate `SSDT-HPET`.

**HOW TO:**

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Press <kbd>D</kbd>, drag in your system's DSDT and hit and hit <kbd>Enter</kbd>
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside the `SSDTTime-master` Folder along with `patches_OC.plist`.
5. Copy the generated SSDTs to `EFI/OC/ACPI`
6. Open `patches_OC.plist` and copy the included entries to the corresponding section(s) of your `config.plist`.
7. Save and Reboot.

Audio should work now (assuming Lilu and AppleALC kexts are present along with the correct layout-id for your on-board audio card).

**NOTE:**
If you are editing your config with [**OpenCore Auxiliary Tools**](https://github.com/ic005k/QtOpenCoreConfig/releases), you can either drag files into the respective section of the GUI to add them to the EFI/OC folder (.aml, .kext, .efi) and config.plist. Alternatively, you can just copy SSDTs, Kexts, and Drives to the corresponding sections of EFI/OC and the changes will be reflected in the config.plist since OCAT monitors this folder.

## Troubleshooting
Some system's implementations of ACPI can't handle the form the IRQ flags are injected by **SSDT-HPET.aml** generated with SSDTTime which looks like this (for example the Lenovo T530):

```asl
...
{	
	IRQNoFlags ()
	    {0,8,11}
...
```
So if you don't have sound after injecting **SSDT-HPET**, the required binary renames and kexts, change the formatting of this section to:

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

## 2. Manual Method
Below you will find the guide for fixing IRQ issues manually if you don't want to use SSDTTime.

- The sound card on earlier machines require **HPET** (`PNP0103`) to provide interrupts `0` and `8`, otherwise the sound card would not work properly. In reality, almost all machines have **HPET** without any interrupt provided. Usually, interrupts `0` and `8` are occupied by **RTC** (`PNP0B00`), **TIMR** (`PNP0100`) respectively
- To solve the problem, we need to fix **HPET**, **RTC** and **TIMR** simultaneously.

## Patching principle
To fix this issue, we use ***SSDT-HPET_RTC_TIMR-fix***, which does the following:

- Disables original **HPET**, **RTC**, **TIMR** devices,
- Creates fake **HPE0**, **RTC0**, **TIM0** and finally,
- Removes `IRQNoFlags (){8}` from **RTC0** and `IRQNoFlags (){0}` from **TIM0** and adds them to **HPE0**.

## Patching method
Use ***SSDT-HPET_RTC_TIMR-fix*** to disable **HPET**, **RTC** and **TIMR**

### Disable **`HPET`**
Usually, `_STA` exists for HPET, so disabling HPET requires the use of the Preset Variable Method by changing `HPAE`/`HPTE` to `0`:

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
**NOTE**: The `HPAE`/`HPTE` variable within `_STA` may vary from machine to machine.
  
#### If `HPAE/HPTE` does not exist
On a lot of Lenovo ThinkPads with Intel CPUs prior to Skylake, `Device HPET` is disabled by different conditions by default, namely `WNTF` and `WXPF`, as shown below (example from a Lenovo T530): 

```asl
Device (HPET)
{
    Name (_HID, EisaId ("PNP0103") /* HPET System Timer */)  // _HID: Hardware ID
    Method (_STA, 0, NotSerialized)  // _STA: Status
    {
        If ((\WNTF && !\WXPF))
        {
            Return (0x00)
        ...
```    
In this case, you can't disbale `HPET` simply by setting it to `0x00`. Instead, you have to get rid of the conditions that turns it off first – in this case `WNTF` and `WXPF` (or whatever these variables are called in your DSDT). To do so, you need to add binary renames to your `config.plist` under `ACPI/Patch` so that the 2 variabled are renamed and have no matches any more:

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
	> **Note** The "!" in the "If (!_OSI ("Darwin"))" statement is not a typo but a logical NOT operator! It actually means: if the OS *is not* Darwin, use variables WNTF instead of XXXX and WXPF instead of YYYY. This restores the 2 variables for any other kernel than macOS so everything is back to normal.

- Optional: Add `SSDT-IPIC.aml` if sound still doesn't work after rebooting.

### Disable **`RTC`**
Disable the Realtime Clock by changening it's status (`_STA`) to zero if macOS is running:

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
### Disable **`TIMR`**
(same as **Disable `RTC`**)

### Disable **`PIC`**/ **`IPIC`** (optional)

If the three-in-one patch alone does not fix audio, add ***SSDT-IPIC*** as well. It disables an existing `IPIC`/`PIC` device and adds a fake one instead (`IPI0`). It also removes `IRQNoFlags{2}`. Adjust the device names and paths according to the paths used in your `DSDT`.

Tthe Programmable Interrupt Controller (PIC) is a hardware device that is responsible for managing interrupts. The PIC receives these interrupts from various devices and routes them to the CPU, allowing the CPU to efficiently handle multiple events simultaneously.

## NOTES
- The names and paths of the `LPC/LPCB` bus as well as `RTC`, `TMR`, `RTC` and `IPIC` devices used in the hotpatch must match the names and paths used in your system's DSDT `DSDT`.
- The IRQ and RTC fixes used here cannot be combined with other RTC fixes, such as:
  - ***SSDT-AWAC*** and ***SSDT-AWAC-ARTC***
  - ***SSDT-RTC0*** and ***SSDT-RTC0-NoFlags***

## Credits
- CorpNewt for SSDTTime
- [racka98](https://github.com/racka98) for ***SSDT-HPET_RTC_TIMR_WNTF_WXPF.dsl***
