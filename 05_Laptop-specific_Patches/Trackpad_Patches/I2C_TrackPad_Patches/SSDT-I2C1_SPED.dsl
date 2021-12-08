//
DefinitionBlock ("", "SSDT", 2, "Hack", "I2C1SPED", 0x00000000)
{
    External (_SB_.PCI0.I2C1, DeviceObj)
    External (SSD1, IntObj)
    External (SSH1, IntObj)
    External (SSL1, IntObj)

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
                Return (PKGX (SSH1, SSL1, SSD1))
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

