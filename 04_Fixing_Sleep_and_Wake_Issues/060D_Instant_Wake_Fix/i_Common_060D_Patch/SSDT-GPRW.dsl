//
// Add the following rename to your config.plist under ACPI/Patch:
//
// Comment:  change GPRW to XPRW
// Find:     4750525702
// Replace:  5850525702
//
DefinitionBlock ("", "SSDT", 2, "OCLT", "GPRW", 0)
{
    External (XPRW, MethodObj)        // External reference to XPRW method
    Method (GPRW, 2, NotSerialized)
    {
        If (_OSI ("Darwin"))          // If the OS is macOS, do the following:
        {
            If ((0x6D == Arg0))       // If the first argument (arg0) is 0x6D,
            {
                Return (Package ()    // return 06D,0x00 end of function
                {
                    0x6D, 
                    Zero
                })
            }

            If ((0x0D == Arg0))        // if the first argument (Arg0) is 0x0D,
            {
                Return (Package ()     // return 0x0D,0x00 end of function
                {
                    0x0D, 
                    Zero
                })
            }
        // Otherwise, the XPRW function is returned directly. Since this function ends with "Return", the "If" stement can't  be followed by an "else" statement.
        // There are only three condition where the ssdt is not applied: 1) the first argument is not 0x6D; 2) the first argument is not 0x0D; 3) the current OS is not macOS
        // XPRW is a renaming of the original GPRW function in DSDT, which actually calls the original GPRW function in the original DSDT
        }
        Return (XPRW (Arg0, Arg1))
    }
}

