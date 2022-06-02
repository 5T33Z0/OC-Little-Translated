// In config ACPI, _Q64 renamed XQ64
// Find:     5F513634
// Replace:  58513634

// In config ACPI, _Q65 renamed XQ65
// Find:     5F513635
// Replace:  58513635
//
#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "STZO", "BrightFN", 0)
{
#endif
    External(_SB.PCI0.LPCB.PS2K, DeviceObj)
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(\_SB.PCI0.LPCB.EC0.XQ64, MethodObj)
    External(\_SB.PCI0.LPCB.EC0.XQ65, MethodObj)
   
    Scope (_SB.PCI0.LPCB.EC0)
    {
        //path:_SB.PCI0.LPCB.EC0._Q64
        Method (_Q64, 0, NotSerialized)//down
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.PS2K, 0x0405)
                Notify(\_SB.PCI0.LPCB.PS2K, 0x20)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC0.XQ64 ()
            }

        }
        //path:_SB.PCI0.LPCB.EC0._Q65
        Method (_Q65, 0, NotSerialized)//up
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.PS2K, 0x0406)
                Notify(\_SB.PCI0.LPCB.PS2K, 0x10)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC0.XQ65 ()
            }
        }
    }
}

