/*
 * Disables Cool-on-Lap (CQL) / Lapmode throttling on Lenovo ThinkPads
 * Requires DSDT rename: DYTC -> XYTC
 *
 * NOTE: 
 * Verify the ACPI path to 'HKEY' in your original DSDT (search for "Device (HKEY)" or "Method (DYTC").
 * Common path variations:
 * - \_SB.PCI0.LPCB.EC.HKEY  (Standard Intel 8th-10th Gen: T480, T490, X1C6-8, etc.)
 * - \_SB.PC00.LPCB.EC.HKEY  (Intel 11th Gen+: T14 Gen 2, etc. using PC00 root bridge)
 * - \_SB.PCI0.LPCB.HKEY     (Some models where HKEY is located directly under LPCB)
 * - \_SB.PCI0.LPC0.EC0.HKEY (Alternative controller naming)
 *
 * If your path differs, adjust all references below accordingly before compiling!
 */

DefinitionBlock ("", "SSDT", 2, "OCLT", "NO-LAP", 0x00001000)
{
    // External references - adjust path if your system differs
    External (\_SB.PCI0.LPCB.EC.HKEY, DeviceObj)
    External (\_SB.PCI0.LPCB.EC.HKEY.XYTC, MethodObj)

    Scope (\_SB.PCI0.LPCB.EC.HKEY)
    {
        // Replacement DYTC method wrapper
        Method (DYTC, 1, Serialized)
        {
            // Call original renamed method
            Local0 = \_SB.PCI0.LPCB.EC.HKEY.XYTC (Arg0)

            // Check if query command: DYTC_CMD_GET (0x0002)
            Local1 = (Arg0 & 0x01FF)

            If (Local1 == 0x02)
            {
                // Mask out Bit 17 (DYTC_GET_LAPMODE_BIT = 0x00020000)
                // Ensures lapmode always reports 0 (desk mode) to the OS
                Local0 &= ~0x00020000
            }

            Return (Local0)
        }
    }

    // Dedicated initialization device to execute EC CQL reset at boot
    // Avoids colliding with HKEY's existing _INI method
    Scope (\_SB)
    {
        Device (DLAP)
        {
            Name (_HID, "DLAP0000")

            Method (_STA, 0, NotSerialized)
            {
                Return (0x0F) // Present, Enabled, Functioning, Show in UI
            }

            Method (_INI, 0, NotSerialized)
            {
                If (CondRefOf (\_SB.PCI0.LPCB.EC.HKEY.XYTC))
                {
                    // Command 0x000F1001: Set CQL Valid Flag (VCQL) to 0 in EC
                    \_SB.PCI0.LPCB.EC.HKEY.XYTC (0x000F1001)
                }
            }
        }
    }
}