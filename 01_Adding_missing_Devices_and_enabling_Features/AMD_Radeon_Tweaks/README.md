# AMD Radeon Performance Tweaks

## About
This chapter contains two approaches for improving the performance of AMD Radeon Cards when running macOS. The first method is pretty much standard to get the card running under macOS. The 2nd method has to be regarded as experimental. It makes use of modified SSDTs and a Kext which improve the performance of AMD Radeon GPUs in OpenCL and Metal applications and lowers the power consumption as well. This method tries to mimic how the card would operate on a real Mac. Choose either method 1 or 2, not both! 

## Method 1: For Navi GPUs (Recommended)
1. Add `SSDT-NAVI.aml` &rarr; Renames `PEGP` to `EGP0` so the GPU works (required for RX 5000/6000 Series Cards only). Also adds `HDAU` device for audio over HDMI.
2. Add Boot-arg `agdpmod=pikera` to config.plist → Fixes black screen issues on some Navi GPUs.

Contents of `SSDT-NAVI.aml`:

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

## Method 2: Using AMD Radeon Patches by mattystonie
**Disclaimer**: Use at your own risk! In general, these patches have to be regarded as "experimental". They may work as intentend but that's not guaranteed.
 
1. Choose the SSDT matching your GPU model contained in the "mattystonie" Folder and export it as `.aml`.

    - For **RX 580**: Use `SSDT-RX580.aml`
    - For **RX 5500/5500XT**: Use `SSDT-RX5500XT.aml` 
    - For **RX 5600/5700/5700XT**: Use `SSDT-RX5700XT.aml`
    - For **RX Vega 64**: Use `SSDT-RXVega64.aml`
	
2. Add the following Kexts to `/Volumes/EFI/EFI/OC/Kexts` and config.plist:

    - `DAGPM.kext` (dummy kext which will help with power management for the GPU)
    - `Whatevergreen.kext`

3. Add Boot-arg `agdpmod=pikera` (for Navi GPUs only!) &rarr; Fixes black screen issues on some GPUs. 

## Credits
- mattystonie for the SSDTs and original [Guide](https://www.tonymacx86.com/threads/amd-radeon-performance-enhanced-ssdt.296555/)
- Toleda for `DAGPM.kext`
- Acidanthera for `WhateverGreen.kext`
- Baio1977 for `SSDT-NAVI.aml`
 
