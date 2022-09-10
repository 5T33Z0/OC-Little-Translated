# ASUS Special Patch
Most ASUS machines contain the `MSOS` method. The `MSOS` method assigns a value to `OSFG` and returns the current state value, which determines the machine's operating mode.

For example, the ACPI brightness shortcut method works only when `MSOS` >= `0x0100`. In the default state, `MSOS` is locked to `OSME`.

***SSDT-OCWork-asus*** changes `MSOS` by changing `OSME`. See DSDT's `Method (MSOS)` for details on the `MSOS` method. If `MSOS` >= `0x0100` it sets the Operating Mode to Windows 8 and the brightness shortcut works. The return value of `MSOS` depends on the OS itself, if Darwin Kernel is runniing, you must use use **this patch** to meet specific requirements.

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
- Add ***SSDT-OCWork-asus.aml*** to ACPI folder and config
- Add PNLF to XNLF rename if `PNLF` method is present in your DSDT (see "Special Rename" below)
- Rebbot

## Special Rename
Some ASUS machines have the variable `PNLF` in the `DSDT`, which may conflict with the same name as the brightness patch, so use the above name change to avoid it.

```text
Comment: Change PNLF to XNLF
Find: 504E4C46
Replace: 584E4C46
```
