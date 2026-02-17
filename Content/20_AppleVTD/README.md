# Guide: Enabling `AppleVTD`

## Overview
**AppleVTD** is macOS’s implementation of Intel’s VT-d (Virtualization Technology for Directed I/O), enabling direct memory access (DMA) for specific hardware features. Enabling AppleVTD is often necessary for:

- **Networking**: Support for modern Wi-Fi cards and multi-gigabit NICs (2.5 Gbps+) such as Intel I225-V on Gigabyte boards or third-party adapters (e.g., Fenvi, Aquantia), which depend on DMA.
- **Thunderbolt/USB Hotplug**: Enhancing support for Thunderbolt devices or USB hotplug functionality.
- **GPU Passthrough**: Passing a GPU to a virtual machine (e.g., QEMU/KVM or VMware for macOS or other OSes).

This guide outlines the prerequisites, steps to enable AppleVTD, and the optional use of SSDT-DMAC to address potential issues.

## Prerequisites
To enable AppleVTD, ensure the following conditions are met:

1. **Hardware Support**:
   - Your CPU and chipset must support Intel VT-d (most Intel Core i5/i7 CPUs from 2nd generation onward).
   - Verify VT-d compatibility in your motherboard’s manual or CPU specification.
2. **BIOS Configuration**:
   - Enable **VT-d** or **IOMMU** in the BIOS/UEFI settings.
3. **OpenCore Bootloader**:
   - Use OpenCore for ACPI table modifications and kernel quirks configuration.
4. **Tools for Verification**:
   - Install **IORegistryExplorer** or **Hackintool** to check for `AppleVTD` in the IO Registry after configuration.

## Steps to Enable AppleVTD
Follow these steps to configure your Hackintosh for AppleVTD:

1. **Enable VT-d in BIOS**:
   - Access your motherboard’s BIOS/UEFI.
   - Locate and enable **Intel VT-d** or **IOMMU** (exact naming varies by manufacturer).
   - Save changes and reboot.

2. **Configure OpenCore Kernel Quirk**:
   - In your OpenCore `config.plist`, navigate to `Kernel > Quirks`.
   - Set `DisableIoMapper` to `false` (unchecked) to allow AppleVTD to initialize.

3. **Drop the OEM DMAR Table**:
   - The OEM DMAR (DMA Remapping) table may include reserved memory regions that conflict with AppleVTD.
   - In OpenCore `config.plist`, under `ACPI > Delete`:
     - Add an entry to drop the `DMAR` table.
     - Reference: [Dropping the DMAR Table](/Content/00_ACPI/ACPI_Dropping_Tables#example-1-dropping-the-dmar-table).

4. **Inject a Modified DMAR Table**:
   - Create or obtain a modified DMAR table without reserved memory regions.
   - Add the modified DMAR table to OpenCore under `ACPI > Add`.
   - Reference: [Replacing the DMAR Table](/Content/00_ACPI/ACPI_Dropping_Tables#example-2-replacing-the-dmar-table-by-a-modified-one).

5. **Verify AppleVTD Activation**:
   - Boot into macOS.
   - Open **IORegistryExplorer** and search for `AppleVTD` in the IO Registry.
   - If present, AppleVTD is active, and no further action is needed.
   - Example of successful activation:
     ![AppleVTD in IORegistryExplorer](https://user-images.githubusercontent.com/76865553/173662447-02328900-46a3-445f-aa39-205a8eecdff8.png)

## Optional: Using SSDT-DMAC
If `AppleVTD` is not present in the IO Registry after completing the above steps, your system may lack a DMAC (DMA Controller) definition in its ACPI tables. The **SSDT-DMAC** can address this issue.

### Role of SSDT-DMAC
- **Purpose**: [**SSDT-DMAC**](/Content/01_Adding_missing_Devices_and_enabling_Features/DMA_Controller_(SSDT-DMAC)) injects a fake DMAC device into the ACPI tables, which macOS may expect for AppleVTD initialization.
- **Cosmetic Nature**: In most cases, AppleVTD works without SSDT-DMAC. However, some motherboards (e.g., older Intel chipsets or Gigabyte boards) require this fake device to ensure macOS can access all memory regions for AppleVTD.
- **Limitations**: SSDT-DMAC does not directly enable AppleVTD or interact with physical hardware. It only satisfies macOS’s ACPI requirements.

### When to Use SSDT-DMAC
- Use SSDT-DMAC if:
  - `AppleVTD` is absent from the IO Registry after completing the above steps.
  - Your motherboard’s ACPI tables lack a DMAC device (check using **MaciASL** or **acpidump**).
  - You’re experiencing issues with GPU passthrough, Thunderbolt/USB hotplug, or DMA-dependent networking devices.

### Steps to Implement SSDT-DMAC
1. **Obtain SSDT-DMAC**:
   - Download [SSDT-DMAC.aml](/Content/01_Adding_missing_Devices_and_enabling_Features/DMA_Controller_(SSDT-DMAC)/SSDT-DMAC.aml)
2. **Add it to OpenCore**:
   - Place SSDT-DMAC in your OpenCore `ACPI` folder.
   - Add it to `config.plist` under `ACPI > Add`.
3. **Reboot and Verify**:
   - Boot into macOS.
   - Check **IORegistryExplorer** for `AppleVTD` and confirm DMAC presence under `_SB.PCI0.LPCB`.
   - Test AppleVTD-dependent features (e.g., GPU passthrough or Thunderbolt).

## Troubleshooting
- **AppleVTD Still Not Present**:
  - Verify VT-d is enabled in BIOS.
  - Ensure the modified DMAR table is correctly injected.
  - Check macOS logs (`Console.app` or `dmesg`) for AppleVTD-related errors.
  - Confirm SSDT-DMAC is loaded (use **MaciASL** to inspect ACPI tables).
- **Hardware Compatibility**:
  - If AppleVTD remains unavailable, your CPU or chipset may not support VT-d. Verify using Intel’s processor specification or your motherboard’s documentation.
- **Networking Issues**:
  - If NICs or WiFi cards (e.g., Intel I225-V, Fenvi, Aquantia) fail, ensure AppleVTD is active and test with/without SSDT-DMAC.

## Notes
- **Redundancy**: If your motherboard’s ACPI tables already define a DMAC device, SSDT-DMAC is unnecessary.
- **Safety**: `SSDT-DMAC` is safe to use, as it only modifies ACPI tables for macOS and is ignored by other operating systems.

By following this guide, you should be able to enable AppleVTD for GPU passthrough, Thunderbolt/USB hotplug, or advanced networking in your Hackintosh setup.
