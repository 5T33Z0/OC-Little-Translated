# Method 2: Mapping USB Ports via ACPI

Declaring USB ports via ACPI is the "gold standard" since this method is OS-agnostic (unlike USBPort kexts, which by default only work for the SMBIOS they were defined for). It's aimed at advanced users only who are experienced in working with ACPI tables already. 

Check the → [**Mapping USB Ports via ACPI**](/Content/03_USB_Fixes/ACPI_Mapping_USB_Ports/README.md) section to find out more.

## Advantages of ACPI Method

- **OS-agnostic**: Works across different operating systems and macOS versions
- **SMBIOS-independent**: No need to adjust mappings when changing SMBIOS
- **More permanent**: Integrated at a lower level than kext-based solutions
- **Cleaner approach**: No additional kexts needed for port mapping

## Requirements

- Advanced knowledge of ACPI tables
- Experience with SSDT creation and compilation
- Understanding of ACPI patching methodology
- Ability to identify USB controller addresses in your system

## When to Use This Method

This method is recommended for:
- Users who frequently change SMBIOS configurations
- Advanced users comfortable with ACPI modifications
- Multi-boot setups where OS-agnostic solutions are preferred
- Users seeking the most "native" integration possible

---

[← Previous: Method 1 - Tools](02_method1_tools.md) | [Back to Overview](./README.md) | [Next: Tahoe Compatibility →](04_tahoe_compatibility.md)
