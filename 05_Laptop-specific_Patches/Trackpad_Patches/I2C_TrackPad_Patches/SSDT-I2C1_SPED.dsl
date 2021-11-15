//
DefinitionBlock ("", "SSDT", 2, "Hack", "I2C1SPED", 0x00000000)
{
    External (_SB_.PCI0.I2C1, DeviceObj)
    External (FMD0, IntObj)
    External (FMH0, IntObj)
    External (FML0, IntObj)
    External (SSD0, IntObj)
    External (SSH0, IntObj)
    External (SSL0, IntObj)

    Scope (_SB.PCI0.I2C1)
    {
        If (_OSI ("Darwin"))
        {
            Method (PKGX, 3, Serialized)
            {
                Name (PKG, Package (0x03)
                {
                    Zero, 
                    Zero, 
                    Zero
                })
                PKG [Zero] = Arg0
                PKG [One] = Arg1
                PKG [0x02] = Arg2
                Return (PKG) /* \_SB_.PCI0.I2C1.PKGX.PKG_ */
            }
        }

        If (_OSI ("Darwin"))
        {
            Method (SSCN, 0, NotSerialized)
            {
                Return (PKGX (SSH0, SSL0, SSD0))
            }
        }

        If (_OSI ("Darwin"))
        {
            Method (FMCN, 0, NotSerialized)
            {
                Name (PKG, Package (0x03)
                {
                    0x0101, 
                    0x012C, 
                    0x62
                })
                Return (PKG) /* \_SB_.PCI0.I2C1.FMCN.PKG_ */
            }
        }
    }
}

