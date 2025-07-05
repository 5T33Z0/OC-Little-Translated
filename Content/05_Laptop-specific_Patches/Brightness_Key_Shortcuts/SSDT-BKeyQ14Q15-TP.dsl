// BrightKey
// In config ACPI, _Q14 renamed XQ14
// Find:     5F 51 31 34
// Replace:  58 51 31 34

// In config ACPI, _Q15 renamed XQ15
// Find:     5F 51 31 35
// Replace:  58 51 31 35

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "BrightFN", 0)
{
#endif
    External(_SB.PCI0.LPCB.PS2K, DeviceObj)
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.XQ14, MethodObj)
    External(_SB.PCI0.LPCB.EC0.XQ15, MethodObj)
    
    Scope (_SB.PCI0.LPCB.EC0)
    {
        //path:_SB.PCI0.LPCB.EC0._Q14
        Method (_Q14, 0, NotSerialized)//up
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.PS2K, 0x0406)
                Notify(\_SB.PCI0.LPCB.PS2K, 0x10)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC0.XQ14 ()
            }
         }

        //path:_SB.PCI0.LPCB.EC0._Q15
        Method (_Q15, 0, NotSerialized)//down
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.PS2K, 0x0405)
                Notify(\_SB.PCI0.LPCB.PS2K, 0x20)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC0.XQ15 ()
            }
        }
    }
}
//EOF
