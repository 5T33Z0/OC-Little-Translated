//Fix AC Adapter SB 

DefinitionBlock ("", "SSDT", 2, "hack", "AC__", 0x00000000)
{
    External (_SB_.AC__, DeviceObj)

    Scope (\_SB.AC)
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

