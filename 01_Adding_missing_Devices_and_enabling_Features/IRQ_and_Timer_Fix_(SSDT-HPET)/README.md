# Sound Card IRQ Patches (`SSDT-HPET`) 

## Description

The sound card on earlier machines require High Precision Event Timer **HPET** **`PNP0103`** to provide interrupt numbers `0` & `8`, otherwise the sound card will not work properly. 

In reality, almost all machines have **HPET** without any interrupts. Usually, interrupts `0` & `8` are occupied by **RTC** **`PNP0B00`**, **TIMR** **`PNP0100`** respectively. To solve the above problem, we need to fix **HPET**, **RTC** and **TIMR** simultaneously.

## Patch Principle

- Disable **HPET**, **RTC**, **TIMR**.
- Create faked **HPE0**, **RTC0**, **TIM0**.
- Remove `IRQNoFlags (){8}` of **RTC0** and `IRQNoFlags (){0}` of **TIM0** and add them to **HPE0**.

## Patch Method (NEW)

The old patch method described below is outdated, because the patching process can now be automated using **SSDTTime** which can generate the following SSDTs based on analyzing your system's `DSDT`:

* ***SSDT-AWAC*** – Context-Aware AWAC and Fake RTC
* ***SSDT-EC*** – OS-aware fake EC for Desktops and Laptops
* ***SSDT-PLUG*** – Sets plugin-type to 1 on `CPU0`/`PR00`
* ***SSDT-HPET*** – Patches out IRQ Conflicts
* ***SSDT-PMC*** – Enables Native NVRAM on True 300-Series Boards

**HOW TO:**

1. Download [**SSDTTime**](https://github.com/corpnewt/SSDTTime) and run it
2. Pres "D", drag in your system's DSDT and hit "ENTER"
3. Generate all the SSDTs you need.
4. The SSDTs will be stored under `Results` inside of the `SSDTTime-master`Folder along with `patches_OC.plist`.
5. Copy the generated `SSDTs` to EFI > OC > ACPI
6. Open `patches_OC.plist` and copy the the included patches to your `config.plist` (to the same section, of course).
7. Save your config
8. Download and run [**ProperTree**](https://github.com/corpnewt/ProperTree)
9. Open your config and create a new snapshot to get the new .aml files added to the list.
10. Save. Reboot. Done. Audio should work now (assuming AppleALC.kext is present along wit the correct layout-id for your on-board audio card).

**NOTE**
If you are editng your config using [**OpenCore Auxiliary Tools**](https://github.com/ic005k/QtOpenCoreConfig/releases), OCAT it will update the list of .kexts and .aml files automatically, since it monitors the EFI folder.

<details>
<summary><strong>Old Method </strong>(kept for documentary purposes)</summary>

# Sound Card IRQ Patch (manual method, old)
## About
Below you will find the guide for fixing IRQ issues manually if you don't want to use SSDTTime which can genereate the necessary SSDT-HPET and and patches for you automatically.

### Technical Background 
Although mostly older platforms (mobile Ivy Bridge for example) are affected by `IRQ` issues which cause the on-board sound not to work since `AppleHDA.kext` is not loaded (only `AppleHDAController.kext` is), the problem can occur on recent platforms as well. 

This is due to the fact that `HPET` is a legacy device from Intel's 6th Gen platform and is only present for backward compatibility with oder Windows versions. if you use 7th Gen Intel Core CPU or newer with Windows 8.1+, HPET (High Precision Event Timer) is no longer present in Device Manager (the Driver is unloaded).
	
For macOS 10.12 and newer, if the problem occurs on the 6th Gen HPET can be blocked directly to solve the problem. Consult the original DSDT's HPET `_STA` method for specific settings.

- The sound card on earlier machines required part **HPET** **`PNP0103`** to provide interrupt numbers `0` & `8`, otherwise the sound card would not work properly. In reality almost all machines have **HPET** without any interrupt number provided. Usually, interrupt numbers `0` & `8` are occupied by **RTC** **`PNP0B00`**, **TIMR** **`PNP0100`** respectively
- To solve the above problem, we need to fix **HPET**, **RTC** and **TIMR** simultaneously.

## Patching principle

- Disable **HPET**, **RTC**, **TIMR** three parts.
- Counterfeit three parts, i.e., **HPE0**, **RTC0**, **TIM0**.
- Remove `IRQNoFlags (){8}` of **RTC0** and `IRQNoFlags (){0}` of **TIM0** and add them to **HPE0**.

## Patching method

### Disable **HPET**, **RTC** and **TIMR**

- Disbale **HPET**
  
    Normally `_STA` exists for HPET, so disabling HPET requires the use of the Preset Variable Method. For example:
  
    ```swift
    External (HPAE, IntObj) /* or External (HPTE, IntObj) */
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            HPAE =0 /* or HPTE =0 */
        }
    }
    ```
  
    **NOTE**: The `HPAE` variable within `_STA` may vary from machine to machine.
  
- Disable **RTC**  
  
    Earlier machines have RTCs without `_STA`, disable RTCs by pressing the `_STA` method. e.g.:
  
    ```swift
    Method (_STA, 0, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            Return (0)
        }
        Else
        {
            Return (0x0F)
        }
    }
    ```
  
**TIMR**
  
   Same as **RTC**
  
- Patch file: ***SSDT-HPET_RTC_TIMR-fix***
  
## Caution

- This patch cannot be used in conjunction with the following patches:
  - ***SSDT-RTC_Y-AWAC_N*** of Binary Renaming and Preset Variables
  - OC Official ***SSDT-AWAC***
  - Counterfeit Devices" or OC's official ***SSDT-RTC0***
  - ***SSDT-RTC0-NoFlags*** of `CMOS Reset Patch
- The `LPCB` name, **Tri-Part** name, and `IPIC` name should be the same as the original `ACPI` part name.
- If the three-in-one patch does not resolve, try ***SSDT-IPIC*** with the three-in-one patch in place. Disable the ***IPIC*** device as described above for ***HPET***, ***RTC*** and ***TIMR***, then impersonate an ***IPI0*** device with the ***IPIC*** or ***PIC*** device contents in the original `DSDT`, and finally Remove `IRQNoFlags{2}`, refer to the example.

