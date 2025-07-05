//Fix AC Adapter SB

DefinitionBlock ("", "SSDT", 2, "Hack", "ACAD", 0x00000000)
{
    External (_SB_.ACAD, DeviceObj)

    Scope (\_SB.ACAD)
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
