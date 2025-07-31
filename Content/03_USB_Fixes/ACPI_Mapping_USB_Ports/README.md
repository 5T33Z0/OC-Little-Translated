# Mapping USB Ports via ACPI (macOS 11.3+)

- **Method 1** (outdated): [SSDT replacement method](/Content/03_USB_Fixes/ACPI_Mapping_USB_Ports/Replace_SSDT/README.md). It utilizes a replacement ACPI table (`SSDT-PORTS`) to enable/disable USB ports when macOS is running.
- **Method 2** (recommended): [`XHUB` Method](/Content/03_USB_Fixes/ACPI_Mapping_USB_Ports/XHUB_Method/README.md). Instead of rewriting the complete USB Port Map, it utilizes an alternate USB Root Hub with required port mappings, which is enabled only when macOS is running.
- **Method 3**: [`XUPC` Method](/Content/03_USB_Fixes/ACPI_Mapping_USB_Ports/XUPC_Method/README.md). Renames `GUPC` to `XUPC` and the redifines the method in `SSDT-GUPC` to enable/disable USB ports in macOS
