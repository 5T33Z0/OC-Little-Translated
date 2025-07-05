// Fic AC Adapter SB PCI0 
DefinitionBlock ("", "SSDT", 2, "hack", "ADP1", 0x00000000)
{
    External (_SB_.PCI0.AC0_, DeviceObj)

    Scope (\_SB.PCI0.AC0)
    {
        If (_OSI ("Darwin"))
        {
            Name (_PRW, Package (0x02)  // _PRW: Power Resources for Wake
            {
                0x18, 
                0x03
            })
        }
    }
}
