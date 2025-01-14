DefinitionBlock ("", "SSDT", 2, "hack", "Darwin", 0x00000000)
{
    Name (KVER, Package (0x13)
    {
        "Darwin 8", 
        "Darwin 9", 
        "Darwin 10", 
        "Darwin 11", 
        "Darwin 12", 
        "Darwin 13", 
        "Darwin 14", 
        "Darwin 15", 
        "Darwin 16", 
        "Darwin 17", 
        "Darwin 18", 
        "Darwin 19", 
        "Darwin 20", 
        "Darwin 21", 
        "Darwin 22", 
        "Darwin 23", 
        "Darwin 24", 
        "Darwin 25", 
        "Darwin 26"
    })
    Method (DARW, 2, NotSerialized)
    {
        Local0 = Zero
        If ((Arg0 >= 0x08))
        {
            Local0 = (Arg0 - 0x08)
        }

        Local1 = 0x12
        If ((Arg1 <= 0x19))
        {
            Local1 = (Arg1 - 0x08)
        }

        Local2 = Local0
        While ((Local2 <= Local1))
        {
            If (_OSI (DerefOf (KVER [Local2])))
            {
                Return (One)
            }

            Local2++
        }

        Return (Zero)
    }
}

