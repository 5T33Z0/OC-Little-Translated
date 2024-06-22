# Enabling AMD Navi GPUs in macOS

## Option 1: using `NootRX.kext`

There's a new kext out called [**NootRX**](https://chefkissinc.github.io/nootrx) to enable unsupported AMD Navi GPUs (Navi 21, 22 and 23) in macOS 11 and newer (check the [**compatibility list**](https://chefkissinc.github.io/nootrx#gpu-compatibility) to find out if your GPU is supprted).

**Instructions**:

1. [**Download**](https://github.com/ChefKissInc/NootRX/releases) and unzip it
2. Mount your EFI
3. Create a backup of your current EFI folder and store it on a FAT32 formatted USB flash drive (just in case something goes wrong, so you can boot from it)
4. Add`NootRX.kext` to your EFI/OC/Kexts folder and `config.plist`
5. Disable `Whatevergreen` and/or `NootedRed` kexts (if present)
6. If you use an SSDT to get your GPU working, disable it
7. Save your config an reboot

Enjoy!

> [!NOTE]
>  
> Curently NootRX cannot be used in recovery or during upgrades due to a misdetection causing a stall at the last stage. For now, have it enabled only *after* installing/updating macOS.

## Option 2: Using `SSDT-NAVI.aml`

This SSDT enables (Big) Navi Cards (RX 5000/6000 series) in macOS. It renames `PEGP` to `EGP0` so the GPU is recognized and adds an HDMI audio device (`HDAU`).

1. Add `SSDT-NAVI.aml`
2. Add the following Kexts to `EFI/OC/Kexts` and config.plist:
    - `Lilu.kext`
    - `Whatevergreen.kext`
3. Add Boot-arg `agdpmod=pikera` to config.plist → Fixes black screen issues on some Navi GPUs.

### Code

```asl
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
### Enabling RX 6900XT Cards

- Cards RX 6900XT from XTXH (device-id: `0x73AF`) is supported with WhateverGreen and spoofing the device-id: use `0x73BF`
- If your RX 6900XT is unsupported, you can follow [this guide](https://github.com/TylerLyczak/Unsupported-6900XT-Hackintosh-Fix) to enable it in macOS.

## AMD and DRM
When using SMBIOS **MacPro7,1** or **iMacPro1,1**, you don't need WhateverGreen and the `agdpmod=pikera` boot-arg. 

This also redirects Quick-Sync Video and Background rendering to the GPU which would otherwise be handled by the iGPU. This can also help to resolves issues with DRM on macOS 11+ as explained in [**WhateverGreen's FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Chart.md#drm-compatibility-on-macos-11). For more in-depth explanations about the `unfairgva` boot-arg and how to use it, [**check this post**](https://www.insanelymac.com/forum/topic/351752-amd-gpu-unfairgva-drm-sidecar-featureunlock-and-gb5-compute-help/).

## Credits & Resources
- **Acidanthera** for `Lilu.kext` and `WhateverGreen.kext`
- **Baio1977** for `SSDT-NAVI.aml`
- **rafale77** for `unfairgva` explanations
- [**Video Bitrate Test Files**](https://jell.yfish.us/) by Jellyfish
- [**XFX RX 6600 XT in macOS Monterey**](https://github.com/perez987/rx6600xt-on-macos-monterey)
- [**AMD Boot Flags**](https://dortania.github.io/GPU-Buyers-Guide/misc/bootflag.html#amd-boot-arguments)
