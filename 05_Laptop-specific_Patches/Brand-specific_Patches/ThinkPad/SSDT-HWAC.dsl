/* Requires Binary Rename:
 *
 * Comment: Change HWAC to XWAC EC Reads, pair with SSDT-HWAC
 * Find: 45435F5F 48574143
 * Replace: 45435F5F 58574143
 * TableSignature: 44534454
 *
 * EXPLANATION
 *
 * On many modern hackintoshed thinkpads there are ofthen accesses to the 16-bit EC-field `HWAC`, which are mostly 
 * not handled by battery-patches (f.e. those currated by @daliansky). Those accesses are (mostly) located in the _OWAK() 
 * and/or _L17-ACPI-methods of the original DSDT.
 *
 * The ACPI-method OWAK() gets called by _WAK() on wake and crashes there on access of the HWAC-field, leaving the 
 * machine in an undefined/unknown hw-state as the regular ACPI-wakeup-method, which re-setups the hardware after S3-sleep, 
 * can't run to its end.
 *
 * Especially this bug is often not clearly visible as the kernel-ringbuffer (msgbuf) is, by default, only 4kb in size and flooded on wake 
 * with many messages. This can be mitigated (up to 16kb) via `msgbuf`-boot-arg or patched by `DebugEnhancer.kext` by @acidanthera.
 * You can check the size of your msgbuf with `sysctl -a kern.msgbuf`.
 *
 * This SSDT is a simple solution for that problem and should be stable accross different Thinkpad models which suffer from this problem
 * as it fixes all accesses to the EC.HWAC-field at once.
 * 
 * It repleaces all reads to HWAC with a call to XWAC(), returning a newly stitched 16-bit-field out of the
 * two overlayed 8-bit-fields `WAC0` & `WAC1`.
 * 
 * Background:
 * `Later releases of AppleACPIPlatform are unable to correctly access fields within the EC (embedded controller). 
 * [...] DSDT must be changed to comply with the limitations of Apple's AppleACPIPlatform.
 * 
 * In particular, any fields in the EC larger than 8-bit, must be changed to be accessed 8-bits at one time. 
 * This includes 16, 32, 64, and larger fields.`
 * - @Rehabman, https://www.tonymacx86.com/threads/guide-how-to-patch-dsdt-for-working-battery-status.116102/
 *
 */

DefinitionBlock ("", "SSDT", 2, "SNIKI", "HWAC", 0x00001000)
{
    External (_SB.PCI0.LPC.EC, DeviceObj)
    External (_SB.PCI0.LPC.EC.HWAC, FieldUnitObj)

    Scope (\_SB.PCI0.LPC.EC)
    {
        /**
         * EC region overlay.
         */
        OperationRegion (ERAM, EmbeddedControl, 0x00, 0x0100)
        Field (ERAM, ByteAcc, NoLock, Preserve)
        {
            Offset (0x36),
            WAC0, 8, WAC1, 8,
        }

        /**
         * Method used for replacing reads to HWAC in _L17() & OWAK().
         */
        Method (XWAC, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Local0 = (WAC1 << 0x08)
                Local0 |= WAC0

                Return (Local0)
            }
            Else
            {
                Return (HWAC)
            }
        }
    }
}
