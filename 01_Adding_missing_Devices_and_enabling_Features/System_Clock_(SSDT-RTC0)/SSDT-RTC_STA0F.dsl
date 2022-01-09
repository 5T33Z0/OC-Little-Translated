// Enables RTC when "_STA=Zero" in system DSDT.
DefinitionBlock ("", "SSDT", 2, "HACK", "RTCSTA0F", 0)
{
    External (_SB_.PCI0.LPCB.RTC_._STA, UnknownObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            \_SB.PCI0.LPCB.RTC._STA = 0x0F
        }        
    }
}

