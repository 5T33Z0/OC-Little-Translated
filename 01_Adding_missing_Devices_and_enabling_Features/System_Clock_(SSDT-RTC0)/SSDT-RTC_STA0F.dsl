//Enable RTC when "_STA=Zero" is disabled in DSDT Bios.
DefinitionBlock ("", "SSDT", 2, "ACDT", "RTCSTA0F", 0)
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

