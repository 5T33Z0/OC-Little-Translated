# Mapping USB Ports via ACPI

This section covers three approaches to ACPI-based USB port mapping. Unlike conventional USB mapping kexts, ACPI-based methods define the USB port configuration through SSDTs, allowing port availability to be controlled according to the operating system.

## Available Methods

- **Method 1 (recommended): [`XHUB` Method](./XHUB_Method/README.md)**  
  Creates an alternate USB root hub with the required port definitions and makes it available only when macOS is running. This avoids replacing the original USB port definitions and allows the existing ACPI configuration to remain intact.

- **Method 2 (outdated): [SSDT Replacement Method](./Replace_SSDT/README.md)**  
  Replaces the original USB port definition table with a custom `SSDT-PORTS` that enables or disables selected ports when macOS is running. This approach modifies the existing port configuration rather than using an alternate root hub.

- **Method 3 (experimental): [`XUPC` Method](./XUPC_Method/README.md)**  
  Renames `GUPC` to `XUPC` and redefines the method in `SSDT-GUPC` to control USB port availability in macOS. This approach is highly experimental and has not been successfully validated by the author.

## Which Method Should You Use?

For new configurations, start with the **`XHUB` method**. It is the recommended approach in this guide because it uses an alternate root hub instead of replacing the original USB port definitions.

The SSDT replacement method is retained for reference and existing configurations. The `XUPC` method is included for experimentation and further development, not as a recommended solution.
