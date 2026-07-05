# DMA Controller (`SSDT-DMAC`)

**INDEX**

- [About](#about)
- [Use case: enabling `AppleVTD`](#use-case-enabling-applevtd)
- [Instructions](#instructions)
- [Verifying that the patch is working](#verifying-that-the-patch-is-working)
- [Related Devices](#related-devices)

--- 

## About 
`SSDT-DMAC` adds a fake **Direct Memory Access Controller** [**(DMAC)**](https://binaryterms.com/direct-memory-access-dma.html) device to IO Registry. Although present in any SMBIOS of intel-based Macs, the necessity for the SSDT on Hackintoshes is uncertain but it can help when trying to enable AppleVTD. 

**DMAC** is present in the following SMBIOS variants:

- **iMac**: 5,1 to 20,x
- **iMacPro1,1**
- **MacBook**: 1,1 to 9,1
- **MacBookAir**: 1,1 to 9,1
- **MacBookPro**: 1,1 to 16,1
- **MacMini**: 1,1 to 8,1
- **MacPro**: 1,1 to 7,1
- **Xserve**: 1,3 to 3,1

> [!NOTE]
> 
> A DMAC/FWHD SSDT was proposed upstream to [acidanthera/OpenCorePkg (PR #121)](https://github.com/acidanthera/OpenCorePkg/pull/121) and was closed. Maintainers argued that Apple using a device in its ACPI doesn't by itself justify replicating it on Hackintoshes without evidence of a functional benefit. This is why DMAC remains a community "Content" hotpatch here rather than something OpenCorePkg ships or recommends by default.

## Use case: enabling `AppleVTD`

&rarr; See [**Enabling AppleVTD**](/Content/20_AppleVTD)

## Instructions

In **DSDT**, search for:

- `PNP0200` or `DMAC`
-  If missing, add ***SSDT-DMAC*** (export as `.aml`)

> [!CAUTION]
> 
> Ensure that the ACPI path of the LPC Bus (`LPC` or `LPCB`) used in the SSDT is identical with the one used in your system's `DSDT`! 

## Verifying that the patch is working
- Incorporate SSDT-DMAC.aml in your EFI's ACPI folder and config.plist.
- Restart your system 
- Open IORegistryExplorer and search for `DMAC`
- If the Device is present, it should look like this. The array "IODeviceMemory" should contain further entries and data:</br>![DMAC](https://user-images.githubusercontent.com/76865553/141217597-78d7dcbb-2a7a-4910-a607-b1ec7e780d35.png)

## Related Devices

| Device | Purpose (claimed) | Status |
|---|---|---|
| [FWHD](/Content/01_Adding_missing_Devices_and_enabling_Features/Fake_Firmware_Hub_(SSDT-FWHD)) (Firmware Hub) | Proposed alongside DMAC in the same upstream PR, same "present in Apple ACPI" rationale | Same as DMAC — cosmetic/unproven |
| B0D4 | Proposed for newer Intel generations where DMAC/FWHD aren't present in the DSDT; claimed to fix DSDT warnings/errors | Rejected upstream ([proposal](https://github.com/5T33Z0/OC-Little-Translated/pull/25)) for lack of documented justification |

> [!CAUTION]
> 
> None of the devices above have a documented functional requirement on Hackintoshes. Treat them as troubleshooting options to try only after the standard AppleVTD prerequisites (VT-d enabled, modified DMAR injected) fail to produce results — not as devices to add preemptively.
