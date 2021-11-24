//
// In config ACPI, _Q0E renamed XQ0E
// Find:     5F 51 30 45
// Replace:  58 51 30 45

// In config ACPI, _Q0F renamed XQ0F
// Find:     5F 51 30 46
// Replace:  58 51 30 46

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "STZO", "BrightFN", 0)
{
#endif
    External(_SB.PCI0.LPCB.PS2K, DeviceObj)
    External(_SB.PCI0.LPCB.EC0, DeviceObj)
    External(_SB.PCI0.LPCB.EC0.XQ0E, MethodObj)
    External(_SB.PCI0.LPCB.EC0.XQ0F, MethodObj)

    Scope (_SB.PCI0.LPCB.EC0)
    {
        //path:_SB.PCI0.LPCB.EC0._Q0E
        Method (_Q0E, 0, NotSerialized)//up
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.PS2K, 0x0405)
                Notify(\_SB.PCI0.LPCB.PS2K, 0x20)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC0.XQ0E ()
            }
         }
        //path:_SB.PCI0.LPCB.EC0._Q0F
        Method (_Q0F, 0, NotSerialized)//down
        {
            If (_OSI ("Darwin"))
            {
                Notify(\_SB.PCI0.LPCB.PS2K, 0x0406)
                Notify(\_SB.PCI0.LPCB.PS2K, 0x10)
            }
            Else
            {
                \_SB.PCI0.LPCB.EC0.XQ0F ()
            }
        }
    }
}
//EOF
