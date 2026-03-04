//enable RTC
//disable AWAC
DefinitionBlock ("", "SSDT", 2, "OCLT", "AWAC", 0x00000000)
{
    External (STAS, FieldUnitObj)
    External (OSDW, MethodObj)    // 0 Arguments

    Scope (\)
    {
        If (OSDW ()
        {
            STAS = One
        }
    }
}

