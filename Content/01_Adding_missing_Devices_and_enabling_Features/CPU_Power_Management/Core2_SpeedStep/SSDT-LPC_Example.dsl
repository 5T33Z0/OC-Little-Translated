/*
 * SSDT-LPC.dsl
 *
 * Purpose: Injects a "device-id" / "name" / "compatible" property set into
 * the existing ISA bridge device (PX40) via _DSM, spoofing it to match one
 * of the LPC controller device IDs bundled in AppleLPC.kext's Info.plist.
 *
 * Why this is needed: AppleLPC.kext only binds to a hardcoded list of PCI
 * device IDs. On most non-Apple chipsets, the real ISA bridge/LPC controller
 * ID isn't in that list, so AppleLPC never loads. This table doesn't change
 * any hardware behavior - it just tells macOS "pretend this device has PCI
 * device ID 3A18" so AppleLPC recognizes and binds to it.
 *
 * Why AppleLPC matters: on pre-XCPM Mac models, AppleLPC is part of the
 * power-management chain alongside AppleIntelCPUPowerManagement. Without it
 * bound correctly, injected CpuPm/CpuCst tables are ignored even if present
 * and correctly formatted, so SpeedStep will not engage.
 *
 * Before using this table:
 *
 * 1. Confirm your board's actual ISA bridge device name and path in your
 *    DSDT (it may not be "PX40" - check with MaciASL/IASL). Update the
 *    External() and Scope() lines below to match.
 * 2. Pick a device ID that AppleLPC.kext actually supports. Check
 *    /System/Library/Extensions/AppleLPC.kext/Contents/Info.plist for the
 *    list of "pci8086,XXXX" IDs it matches against, and use one suited to
 *    your chipset generation.
 * 3. Update both the "device-id" buffer bytes and the "name"/"compatible"
 *    strings below to match the chosen ID - all three must agree.
 *
 * Verify success: after loading this SSDT, AppleLPC should appear bound to
 * this device in IORegistryExplorer.
 */

DefinitionBlock ("", "SSDT", 2, "OCLT", "LPC", 0x00000000)
// Table header: ("", "SSDT" = table signature, 2 = revision, "OCLT" = OEM ID,
// "LPC" = OEM Table ID (arbitrary label), 0x00000000 = OEM revision
{
    External (_SB_.PCI0.PX40, DeviceObj)
    // Forward-declare the ISA bridge device (PX40) so the compiler knows it
    // exists elsewhere in the DSDT - adjust "PX40" to match your board's
    // actual ISA bridge device name (check with IASL/MaciASL against your DSDT)

    Scope (_SB.PCI0.PX40)
    // Reopen the existing ISA bridge device to inject into it, rather than
    // redefining the whole device
    {
        If (_OSI ("Darwin"))
        // Only apply this method when booting macOS - Darwin is macOS's
        // internal OS identifier; other OSes (Windows/Linux) skip this block
        {
            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            // Standard ACPI method for exposing custom (non-standard)
            // properties to the OS. Takes 4 arguments (Arg0-Arg3):
            // Arg0 = UUID, Arg1 = revision, Arg2 = function index, Arg3 = params
            {
                If ((Arg2 == Zero))
                // Function index 0 = "query supported functions" - every
                // _DSM must implement this before returning real data
                {
                    Return (Buffer (One)
                    {
                         0x03                                             // .
                        // Bitmask: bit0 (function 0 itself) + bit1
                        // (function 1, the actual data return) supported
                    })
                }
                Return (Package (0x06)
                // Function 1 (and any other Arg2 value) falls through to here:
                // returns the actual key/value property pairs, 6 entries total
                // (3 key/value pairs)
                {
                    "device-id", 
                    Buffer (0x04)
                    {
                         0x18, 0x3A, 0x00, 0x00                           // .:..
                        // Device ID, little-endian: bytes read 18 3A 00 00
                        // = 0x00003A18 -> PCI device ID 3A18 (paired with
                        // vendor ID 8086 = Intel, implied by the "pci8086,"
                        // prefix below). Replace 0x18, 0x3A with your
                        // target LPC controller's device ID bytes
                        // (low byte first, then high byte)
                    }, 
                    "name", 
                    Buffer (0x0D)
                    {
                        "pci8086,3a18"
                        // Human-readable device name string, format
                        // "pci<vendor-id>,<device-id>" in hex, no 0x prefix -
                        // must match the device-id bytes above
                    }, 
                    "compatible", 
                    Buffer (0x0D)
                    {
                        "pci8086,3a18"
                        // Compatible-device string - this is the value
                        // AppleLPC.kext actually matches against its
                        // IOKitPersonalities in Info.plist. Must exactly
                        // match one of the "pci8086,XXXX" entries AppleLPC
                        // supports, or the kext will not bind
                    }
                })
            }
        }
    }
}