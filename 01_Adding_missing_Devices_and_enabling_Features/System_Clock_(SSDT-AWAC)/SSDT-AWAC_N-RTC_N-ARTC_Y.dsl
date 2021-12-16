/Disable AWAC , Disable RTC , Disable HPET , Fake ARTC ON. 
* Use on 300-400-500-600 Series Chipset 
*/
DefinitionBlock ("", "SSDT", 2, "STZO", "ARTC", 0x00000000)
{
    External (HPTE, IntObj)
    External (STAS, FieldUnitObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            STAS = 0x02
            HPTE = Zero
        }
    }

    Scope (\)
    {
        Device (ARTC)
        {
            Name (_HID, EisaId ("PNP0B00") /* AT Real-Time Clock */)  // _HID: Hardware ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IO (Decode16,
                    0x0070,             // Range Minimum
                    0x0070,             // Range Maximum
                    0x01,               // Alignment
                    0x02,               // Length
                    )
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
    }
}

