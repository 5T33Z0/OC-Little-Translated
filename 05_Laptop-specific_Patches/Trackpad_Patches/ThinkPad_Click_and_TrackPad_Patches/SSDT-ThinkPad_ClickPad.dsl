// Example overrides for Thinkpad models with ClickPad
DefinitionBlock ("", "SSDT", 2, "ACDT", "ps2", 0)
{
    // Change _SB.PCI0.LPC.KBD if your PS2 keyboard is at a different ACPI path
    External(_SB.PCI0.LPC.KBD, DeviceObj)
    Scope(_SB.PCI0.LPC.KBD)
    {
        // Select specific configuration in VoodooPS2Trackpad.kext
        Method(_DSM, 4)
        {
            If (!Arg2) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                "RM,oem-id", "LENOVO",
                "RM,oem-table-id", "Thinkpad_ClickPad",
            })
        }
        // Overrides (the example data here is default in the Info.plist)
        Name(RMCF, Package()
        {
            "Synaptics TouchPad", Package()
            {
                "HWResetOnStart", ">y",
                "QuietTimeAfterTyping", 500000000,
                "FingerZ", 30,
                "MouseMultiplierX", 2,
                "MouseMultiplierY", 2,
                "MouseDivisorX", 1,
                "MouseDivisorY", 1,
                // Change multipliers to 0xFFFE in order to inverse the scroll direction
                // of the Trackpoint when holding the middle mouse button.
                "TrackpointScrollXMultiplier", 2,
                "TrackpointScrollYMultiplier", 2,
                "TrackpointScrollXDivisor", 1,
                "TrackpointScrollYDivisor", 1
            },
        })
    }
}
//EOF