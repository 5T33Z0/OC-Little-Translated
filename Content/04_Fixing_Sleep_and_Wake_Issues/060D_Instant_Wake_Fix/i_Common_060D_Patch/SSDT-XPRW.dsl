// For solving instant wake by hooking GPRW or UPRW
//
// In DSDT, native GPRW/UPRW is renamed to XPRW with a binary rename
// As a result, calls to GPRW (or UPRW) land here.
//
// The purpose of this SSDT is to avoid "instant wake" by returning 
// 0 in the second position (sleep state supported) of the return 
// package. It covers both methods/cases, GPRW and UPRW.
//
// INSTRUCTIONS:
//
// - Export as .aml, add it to EFI/OC/ACPI and config.plist
// - Add the following rename(s) (depending on the method used in your 
// DSDT) to your config.plist under ACPI/Patch:
//
// Comment:  Change GPRW to XPRW
// Find:     4750525702
// Replace:  5850525702
//
// Comment:  Change UPRW to XPRW
// Find:     5550525702
// Replace:  5850525702

DefinitionBlock("", "SSDT", 2, "5T33Z0", "XPRW", 0)
{
    External (XPRW, MethodObj)

Method (GPRW, 2)
    {
        If (_OSI ("Darwin"))
        {
            If (0x6d == Arg0) { Return (Package() { 0x6d, 0, }) }
            If (0x0d == Arg0) { Return (Package() { 0x0d, 0, }) }}
            Return (XPRW (Arg0, Arg1))
        }

Method (UPRW, 2)
    {
        If (_OSI ("Darwin"))
        {
            If (0x6d == Arg0) { Return (Package() { 0x6d, 0, }) }
            If (0x0d == Arg0) { Return (Package() { 0x0d, 0, }) }}
            Return (XPRW (Arg0, Arg1))
        }
     }  
//EOF