# Overview

## About ACPI Renames and Hotpatches

Try to avoid ACPI binary renames and patches such as `HDAS` to `HDEF`, `EC0` to `EC`, `SSDT-OC-XOSI` etc., whenever possible. Especially renaming of underlined `MethodObj`(such as _STA, _OSI, etc.) should be done with caution. 

In general: 

- No OS Patches are required. For parts that do not work properly due to system limitations, customize the patch to fit the ACPI. For special requirements on the operating system, use the `XOSI` Patch.
- For Brightness Control Keys to work, some machines do not require extra patches. Use `PS2 Keyboard Mapping` instead to achieve the same effect.
- For now, the vast majority of machines require the `0D6D Patch` to fix `Instant Wake` issues.
- Laptops require device-specific renames and patches for the Battery Percentage Indicator to work.
- Most ThinkPad Laptops require the `PTSWAKTTS` patch to stop the Power Button LED from pulsing after waking up from sleep.
- For machines with a dedicated Sleep Button: If pressing the Sleep Button crashes the system, use the `PNP0C0E Sleep Correction Method` to fix it.

You may need to disable or enable certain components in order to solve a specific problems. 
 
In general, use:

- `Binary Renames & Preset Variables` – the binary rename method is especially effective for computers running only macOS. On multi-boot systems with different Operating Systems  these patches should be used with **Caution** since binary renames apply to all systems which can cause issues. The best way to avoid such issues is to bypass OpenCore when booting into a different OS altogether, so no patches are injected. Or use Clover instead, since it does not inject patches into other OSes.
- `Fake Devices` since this method is very reliable. **Recommended**. 

## Important Patches

- ***SSDT-RTC0*** – located under`Fake Devices`

	Some systems crash during startup due to the RTC [`PNP0B00`]  being disabled. Use SSDT-RTC0 to fix it.
- ***SSDT-EC*** – Under`Fake EC`

  From **MacOS 10.15** onwards, ***SSDT-EC*** is necessary if the `Embedded Controller` is either not present or not named `EC`. Otherwise the OS may not boot. In Big Sur you get an error message (crossed-out stop sign) instead of the Apple Logo, saying that your system is not compatible with Big Sur, even though it is.
