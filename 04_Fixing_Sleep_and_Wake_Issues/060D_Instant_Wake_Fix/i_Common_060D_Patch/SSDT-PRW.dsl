// For solving instant wake by hooking _PRW
//
// Add the following rename to your config.plist 
// under ACPI/Patch:
//
// Comment:  change _PRW to XPRW
// Find:     5F505257
// Replace:  58505257

DefinitionBlock("", "SSDT", 2, "5T33Z0", "_PRW", 0)
{
    External (XPRW, MethodObj)

If (_OSI ("Darwin"))
{
    // In DSDT, native _PRW is renamed to XPRW with a binary rename.
    // As a result, calls to _PRW land here.
    // The purpose of this implementation is to avoid "instant wake"
    // by returning 0 for Arg1 (sleep state supported) the return package.
    
    Method (_PRW, 2)
    {
        If (0x6d == Arg0) { Return (Package() { 0x6d, 0, }) }
        If (0x0d == Arg0) { Return (Package() { 0x0d, 0, }) }
        Return (XPRW (Arg0, Arg1))
    }
  }
}