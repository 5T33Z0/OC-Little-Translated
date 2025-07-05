// BrightKey
// In config ACPI, _Q11 renamed XQ11
// Find:     5F 51 31 31
// Replace:  58 51 31 31

// In config ACPI, _Q12 renamed XQ12
// Find:     5F 51 31 32
// Replace:  58 51 31 32

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "STZO", "BrightFN", 0)
{
#endif
    External(_SB.PCI0.LPCB.PS2K, DeviceObj)
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.XQ11, MethodObj)
    External(_SB.PCI0.LPCB.EC0.XQ12, MethodObj)
    
    Scope (_SB.PCI0.LPCB.EC0)
    {
        //path:_SB.PCI0.LPCB.EC0._Q11
        Method (_Q11, 0, NotSerialized)//down
        {
            If (_OSI ("Darwin"))
                {
                    Notify(\_SB.PCI0.LPCB.PS2K, 0x0405)
                    Notify(\_SB.PCI0.LPCB.PS2K, 0x20)
                }
            Else
                {
                    \_SB.PCI0.LPCB.EC0.XQ11 ()
                }
        }
        //path:_SB.PCI0.LPCB.EC0._Q12
        Method (_Q12, 0, NotSerialized)//up
        {
            If (_OSI ("Darwin"))
                {
                    Notify(\_SB.PCI0.LPCB.PS2K, 0x0406)
                    Notify(\_SB.PCI0.LPCB.PS2K, 0x10)
                }
            Else
                {
                    \_SB.PCI0.LPCB.EC0.XQ12 ()
                }
         }
    }
}

