DefinitionBlock ("", "SSDT", 2, "OCLT", "OSDW", 0x00000000)
{
    Method (OSDW, 0, NotSerialized)
    {
        If (CondRefOf (\_OSI))
        {
            If (_OSI ("Darwin"))
            {
                Return (One)
            }
        }
        Return (Zero)
    }
}
