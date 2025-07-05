// Add the following rename rule to your congig.plst under ACPI/Patch:
//
// Comment: Change GPRW to XPRW
// Find:    4750525702
// Replace: 5850525702
//
DefinitionBlock ("", "SSDT", 2, "OCLT", "GPRW", 0)
{
    External(XPRW, MethodObj)
    Method (GPRW, 2, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            If ((0x6D == Arg0))
            {
                Return (Package ()
                {
                    0x6D, 
                    Zero
                })
            }

            If ((0x0D == Arg0))
            {
                Return (Package ()
                {
                    0x0D, 
                    Zero
                })
            }
        }
        Return (XPRW (Arg0, Arg1))
    }
}

