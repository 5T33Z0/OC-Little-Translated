// For solving instant wake by hooking GPRW or UPRW
//
// In DSDT, native GPRW is renamed to XPRW with a binary rename
// (or UPRW to XPRW). As a result, calls to GPRW (or UPRW) land 
// here.
// The purpose of this implementation is to avoid "instant wake"
// by returning 0 in the second position (sleep state supported)
// of the return package. It covers both methods GPRW and UPRW.
//
// Add the following rename (depending on the method used in your DSDT)
// to your config.plist under ACPI/Patch:
//
// Comment:  change GPRW to XPRW
// Find:     47505257
// Replace:  58505257
//
// Comment:  change UPRW to XPRW
// Find:     55505257
// Replace:  58505257

DefinitionBlock("", "SSDT", 2, "5T33Z0", "XPRW", 0)
{
    External (XPRW, MethodObj)

Method (GPRW, 2)
    {
        If (_OSI ("Darwin"))
        {
            If (0x6d == Arg0) { Return (Package() { 0x6d, 0, }) }
            If (0x0d == Arg0) { Return (Package() { 0x0d, 0, }) }
            Return (XPRW (Arg0, Arg1))
        }
    }   

Method (UPRW, 2)
    {
        If (_OSI ("Darwin"))
        {
            If (0x6d == Arg0) { Return (Package() { 0x6d, 0, }) }
            If (0x0d == Arg0) { Return (Package() { 0x0d, 0, }) }
            Return (XPRW (Arg0, Arg1))
        }
     }
  }
//EOF