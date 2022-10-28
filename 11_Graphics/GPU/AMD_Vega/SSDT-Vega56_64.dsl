//SSDT ALL AMD GPU RX Series 5000\6000 XT and Vega 56\64
DefinitionBlock ("", "SSDT", 2, "HACK", "NAVI", 0x00000000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.PEG0, DeviceObj)
    External (_SB_.PCI0.PEG0.PEGP, DeviceObj)

    Scope (\_SB)
    {
        Scope (PCI0)
        {
            Scope (PEG0)
            {
                Scope (PEGP)
                {
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        If (_OSI ("Darwin"))
                        {
                            Return (Zero)
                        }
                        Else
                        {
                            Return (0x0F)
                        }
                    }
                }

                Device (EGP0)
                {
                    Name (_ADR, Zero)  // _ADR: Address
                    Method (_STA, 0, NotSerialized)  // _STA: Status
                    {
                        If (_OSI ("Darwin"))
                        {
                            Return (0x0F)
                        }
                        Else
                        {
                            Return (Zero)
                        }
                    }

                    Device (EGP1)
                    {
                        Name (_ADR, Zero)  // _ADR: Address
                        Device (GFX0)
                        {
                            Name (_ADR, Zero)  // _ADR: Address
                        }

                        Device (HDAU)
                        {
                            Name (_ADR, One)  // _ADR: Address
                        }
                    }
                }
            }
        }
    }
}
