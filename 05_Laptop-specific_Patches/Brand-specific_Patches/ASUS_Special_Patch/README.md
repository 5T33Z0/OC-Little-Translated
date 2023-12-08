# ASUS Brightness Keys Patch
Most ASUS machines contain the `MSOS` method. The `MSOS` method assigns a value to `OSFG` and returns the current state value, which determines the machine's operating mode. The ACPI brightness shortcut method only works if `MSOS` ≥ `0x0100`. In the default state, `MSOS` is locked to `OSME` (check your DSDT for details).

***SSDT-OCWork-asus*** changes `MSOS` by setting the value of `OSME` to `0x100` if the Darwin Kernel is running. This changes the Operating Mode to Windows 8 which in return makes the brightness keyboard shortcuts work in macOS.

## Requirements
- In `DSDT`, check for the following:
	- **Method**: `MSOS`
	- **Paramter**: `OSFG`

**Example**:

```asl
Method (MSOS, 0, NotSerialized)
{
    If ((OSYS >= 0x07DC))
    {
        OSFG = OSW8 /* \OSW8 */
    }
    ElseIf ((OSYS == 0x07D9))
    {
        OSFG = OSW7 /* \OSW7 */
    }
    ElseIf ((OSYS == 0x07D6))
    {
        OSFG = OSVT /* \OSVT */
    }
    ElseIf (((OSYS >= 0x07D1) && (OSYS <= 0x07D3)))
    {
        OSFG = OSXP /* \OSXP */
    }
    ElseIf ((OSYS == 0x07D0))
    {
        OSFG = OSME /* \OSME */
    }
    ElseIf ((OSYS == 0x07CE))
    {
        OSFG = OS98 /* \OS98 */
    }
    Else
    {
        OSFG = OSW8 /* \OSW8 */
    }
    Return (OSFG) /* \OSFG */
}
```
## Patching principle
- Add ***SSDT-OCWork-asus.aml*** to the `EFI/OC/ACPI` folder and config.plist.
- If the `PNLF` method is present in your `DSDT`: add `PNLF` to `XNLF` rename (&rarr; check "Special Rename").
- Reboot.

## Special Rename
Some ASUS machines have the variable `PNLF` in the `DSDT`, which may conflict with the brightness patch (SSDT-PNLF) which uses the same variable. If this is the case, add the following binary rename to the `ACPI/Patch` section of your `config.plist` to avoid conflicts:

```text
Comment: Change PNLF to XNLF
Find: 504E4C46
Replace: 584E4C46
```
