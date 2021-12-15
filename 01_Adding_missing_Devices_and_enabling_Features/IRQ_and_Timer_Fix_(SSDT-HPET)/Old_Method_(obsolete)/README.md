# Sound Card IRQ Patch (manual method, old)

## Description
Below you will find the guide for fixing IRQ issues manually if you don't want to use SSDTTime which can genereate the necessary SSDT-HPET and and patches for you automatically.

- The sound card on earlier machines required part **HPET** **`PNP0103`** to provide interrupt numbers `0` & `8`, otherwise the sound card would not work properly. In reality almost all machines have **HPET** without any interrupt number provided. Usually, interrupt numbers `0` & `8` are occupied by **RTC** **`PNP0B00`**, **TIMR** **`PNP0100`** respectively
- To solve the above problem, we need to fix **HPET**, **RTC** and **TIMR** simultaneously.

### Technical Background
Although mostly older platforms (mobile Ivy Bridge for example) are affected by `IRQ` issues which cause the on-board sound not to work since `AppleHDA.kext` is not loaded (only `AppleHDAController.kext` is), the problem can occur on recent platforms as well. 

This is due to the fact that `HPET` is a legacy device from Intel's 6th Gen platform and is only present for backward compatibility with oder Windows versions. if you use 7th Gen Intel Core CPU or newer with Windows 8.1+, HPET (High Precision Event Timer) is no longer present in Device Manager (the Driver is unloaded).
	
For macOS 10.12 and newer, if the problem occurs on the 6th Gen HPET can be blocked directly to solve the problem. Consult the original DSDT's HPET `_STA` method for specific settings.

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
    
## CAUTION

- This patch cannot be used in conjunction with the following patches:
  - ***SSDT-RTC_Y-AWAC_N*** of Binary Renaming and Preset Variables
  - OC Official ***SSDT-AWAC***
  - Counterfeit Devices" or OC's official ***SSDT-RTC0***
  - ***SSDT-RTC0-NoFlags*** of `CMOS Reset Patch
- The `LPCB` name, **Tri-Part** name, and `IPIC` name should be the same as the original `ACPI` part name.
- If the three-in-one patch does not resolve, try ***SSDT-IPIC*** with the three-in-one patch in place. Disable the ***IPIC*** device as described above for ***HPET***, ***RTC*** and ***TIMR***, then impersonate an ***IPI0*** device with the ***IPIC*** or ***PIC*** device contents in the original `DSDT`, and finally Remove `IRQNoFlags{2}`, refer to the example.
