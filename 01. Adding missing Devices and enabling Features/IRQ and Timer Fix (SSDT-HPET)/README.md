# Sound Card IRQ Patches (`SSDT-HPET`) 

## Description

The sound card on earlier machines require High Precision Event Timer **HPET** **`PNP0103`** to provide interrupt numbers `0` & `8`, otherwise the sound card will not work properly. 

In reality, almost all machines have **HPET** without any interrupts. Usually, interrupts `0` & `8` are occupied by **RTC** **`PNP0B00`**, **TIMR** **`PNP0100`** respectively. To solve the above problem, we need to fix **HPET**, **RTC** and **TIMR** simultaneously.

## Patch Principle

- Disable **HPET**, **RTC**, **TIMR**.
- Create faked **HPE0**, **RTC0**, **TIM0**.
- Remove `IRQNoFlags (){8}` of **RTC0** and `IRQNoFlags (){0}` of **TIM0** and add them to **HPE0**.

## Patch Method (NEW)

The old patch method described below is obsolete, because the patching process can now be automated using **SSDTTime** which can generate the following SSDTs based on analyzing your system's `DSDT`:

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

<details>
<summary><strong>Old Method (kept for documentary purposes)</strong></summary>

## Old Method

- Disable **HPET**, **RTC**, **TIMR**:
  - **HPET**
  
    Normally `_STA` exists for HPET, so disabling HPET requires the use of the Preset Variable Method. For example
  
    ```Swift
    External (HPAE, IntObj) /* or External (HPTE, IntObj) */
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            HPAE =0 /* or HPTE =0 */
        }
    }
    ```
  
    Note: The `HPAE` variable within `_STA` may vary from machine to machine.
  
  - **RTC**  
  
    Earlier machines have RTCs without `_STA`, disable RTCs by pressing the `Method (_STA,` method. e.g.
  
    ```Swift
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
  
  - **TIMR**
  
    Same as **RTC**
  
- Patch file:***SSDT-HPET_RTC_TIMR-fix***

  See **Patch Principle** above for reference examples.
  
  **Topcharge**
  
Although mostly earlier platforms commonly have `IRQ` problems that cause the on-board sound card not to work (especially Ivy Bridge Mobile CPUs), new platforms sometimes can cause problems.

machines also still exist This problem is due to the fact that HPET is already an obsolete device from Intel 6 generation platform and is only reserved as compatible with earlier versions of the system, if you use 6 generation platform or above and the system version Windows 8.1 + HPET (High Precision Event Timer) in Device Manager is already in the unloaded driver state
  macOS 10.12 + version, if the problem occurs in the 6th generation + hardware platform can be directly blocked HPET to solve the problem specific method to consult the original DSDT HPET `_STA` method of specific settings.
    
## Caution

- This patch cannot be used in conjunction with the following patches.

  - ***SSDT-RTC_Y-AWAC_N*** of Binary Renaming and Preset Variables
  - OC Official ***SSDT-AWAC***
  - Counterfeit Devices" or OC's official ***SSDT-RTC0***
  - ***SSDT-RTC0-NoFlags*** of `CMOS Reset Patch
  
- The `LPCB` name, **Tri-Part** name, and `IPIC` name should be the same as the original `ACPI` part name.
- If the three-in-one patch does not resolve, try ***SSDT-IPIC*** with the three-in-one patch in place. Disable the ***IPIC*** device as described above for ***HPET***, ***RTC*** and ***TIMR***, then impersonate an ***IPI0*** device with the ***IPIC*** or ***PIC*** device contents in the original `DSDT`, and finally Remove `IRQNoFlags{2}`, refer to the example.
