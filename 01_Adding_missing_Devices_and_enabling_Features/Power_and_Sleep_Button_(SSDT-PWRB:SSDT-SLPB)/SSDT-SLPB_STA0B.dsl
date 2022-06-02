//When the Device "PNP0C0E" is present in DSDT Origin but STA=0 it is switched off.
//This SSDT activates it on macOS.
DefinitionBlock ("", "SSDT", 2, "HACK", "PNP0C0E", 0x00000000)
{
    External (_SB_.SLPB._STA, UnknownObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            \_SB.SLPB._STA = 0x0B
        }
    }
}

