// SSDT to set Arg1 (the 2nd byte of the packet) in _PRW method to 0
// as required by macOS to not wake instantly.
// You need to reference all devices where _PRW needs to be modified.

DefinitionBlock ("", "SSDT", 2, "5T33Z0", "PRW0", 0x00000000)
{
    External (_SB_.PCI0.EHC1._PRW, PkgObj) // External Reference of Device and its _PRW method
    External (_SB_.PCI0.EHC2._PRW, PkgObj) // These References are only examples. Modify them as needed
    External (_SB_.PCI0.HDEF._PRW, PkgObj) // List every device where the 2nd byte of _PRW is not 0
    External (_SB_.PCI0.IGBE._PRW, PkgObj)
    External (_SB_.PCI0.SAT1._PRW, PkgObj)
    External (_SB_.PCI0.XHCI._PRW, PkgObj)
    
    If (_OSI ("Darwin"))
    {
        _SB_.PCI0.EHC1._PRW [One] = 0x00 // Changes second byte in the package to 0
        _SB_.PCI0.EHC2._PRW [One] = 0x00
        _SB_.PCI0.HDEF._PRW [One] = 0x00
        _SB_.PCI0.IGBE._PRW [One] = 0x00
        _SB_.PCI0.SAT1._PRW [One] = 0x00
        _SB_.PCI0.XHCI._PRW [One] = 0x00
    }
}