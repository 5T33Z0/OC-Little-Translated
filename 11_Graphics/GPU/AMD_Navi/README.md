# Enabling AMD Navi GPUs in macOS

This SSDT enables Navi Cards (RX 5000/6000 series) in macOS. It renames `PEGP` to `EGP0` so the GPU is recognized and adds an HDMI audio device (`HDAU`).

1. Add `SSDT-NAVI.aml`
2. Add the following Kexts to `EFI/OC/Kexts` and config.plist:
    - `Lilu.kext`
    - `Whatevergreen.kext`
3. Add Boot-arg `agdpmod=pikera` to config.plist → Fixes black screen issues on some Navi GPUs.

## SSDT-NAVI Content

```swift
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
                        Name (_SUN, One)  // _SUN: Slot User Number
                        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                        {
                            If ((Arg2 == Zero))
                            {
                                Return (Buffer (One)
                                {
                                     0x03                                             // .
                                })
                            }

                            Return (Package (0x02)
                            {
                                "hda-gfx", 
                                Buffer (0x0A)
                                {
                                    "onboard-2"
                                }
                            })
                        }
                    }

                    Device (HDAU)
                    {
                        Name (_ADR, One)  // _ADR: Address
                        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
                        {
                            If ((Arg2 == Zero))
                            {
                                Return (Buffer (One)
                                {
                                     0x03                                             // .
                                })
                            }

                            Return (Package (0x0A)
                            {
                                "AAPL,slot-name", 
                                "Built In", 
                                "device_type", 
                                Buffer (0x13)
                                {
                                    "Controller HDMI/DP"
                                }, 

                                "name", 
                                "High Definition Multimedia Interface", 
                                "model", 
                                Buffer (0x25)
                                {
                                    "High Definition Multimedia Interface"
                                }, 

                                "hda-gfx", 
                                Buffer (0x0A)
                                {
                                    "onboard-2"
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}
```
</details>

# Credits & Resources
- Acidanthera for `Lilu.kext` and `WhateverGreen.kext`
- Baio1977 for `SSDT-NAVI.aml`
- [**Video Bitrate Test Files**](https://jell.yfish.us/) by Jellyfish
guide_polaris_rx_560_580_etc_custom_powerplay/)
- [**XFX RX 6600 XT in macOS Monterey**](https://github.com/perez987/rx6600xt-on-macos-monterey)
