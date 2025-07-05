// Fix AC Adapter SB.PCI0.LPCB.EC0

DefinitionBlock ("", "SSDT", 2, "hack", "ADP0", 0x00000000)
{
    External (_SB_.PCI0.LPCB.EC0_.ADP0, DeviceObj)

    Scope (\_SB.PCI0.LPCB.EC0.ADP0)
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

