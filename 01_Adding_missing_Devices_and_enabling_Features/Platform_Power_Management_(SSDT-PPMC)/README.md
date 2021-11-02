# Add missing parts
Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets.

## About `SSDT-PPMC`

- What it is: Adds Platform Power Management Controller Device
- What it does: Improves Power Management (supposedly)
- Supported CPU Families: Intel 6th Gen and newer (Mobile and Desktop)

## Instructions
In **DSDT**, search for:

- `0x001F0002`, if missing, add `SSDT-PPMC.aml`

**CAUTION**: When using the any of the patches, note that `LPC`/`LPCB` name should be consistent with the name used in the original ACPI.

### Verifying
In IORegistryExplorer search for 'PPMC'. If present, it should look like this:

![ppmc_present](https://user-images.githubusercontent.com/76865553/139706104-f00e641b-40d0-4012-931a-f89276c75949.png)
