## SSDTs vs. DeviceProperties: Understanding Property Injection Precedence

In OpenCore, **properties injected via SSDTs (Secondary System Description Tables) typically take precedence over those defined in the `config.plist`**, provided the SSDTs are correctly implemented and loaded. This precedence is due to the hierarchical nature of how macOS processes ACPI tables and device properties during the boot sequence.

### Understanding the Hierarchy

1. **ACPI Level (SSDTs):**
   - **Function:** SSDTs are used to define or override ACPI tables, allowing for low-level hardware configuration and property injection.
   - **Precedence:** Since SSDTs are loaded early in the boot process, they can establish or modify device properties at a fundamental level.

2. **Bootloader Level (`config.plist`):**
   - **Function:** The `config.plist` file in OpenCore is used to configure various bootloader settings, including device property injections.
   - **Precedence:** Properties defined here are applied after the ACPI tables have been processed. If a property has already been set by an SSDT, the `config.plist` may not override it unless explicitly configured to do so.

### Practical Implications

- **USB Power Properties:** Injecting USB power properties via an SSDT (e.g., creating a `USBX` device) is a common practice to ensure proper USB functionality. This method is often preferred over injecting the same properties via `config.plist` because it integrates the properties at a lower level, leading to more reliable behavior. 

- **Device Renaming:** Certain device renaming tasks, such as changing `GFX0` to `IGPU`, are better handled within SSDTs or by using kexts like WhateverGreen, which can perform these renames dynamically. This approach is generally safer and more effective than attempting the same renames via `config.plist`. 

### Recommendations

- **Use SSDTs for Hardware-Level Configurations:** For tasks that require low-level hardware interaction, such as injecting USB power properties or renaming devices, implementing these changes via SSDTs is advisable. This method ensures that the properties are applied early in the boot process, leading to more consistent behavior.

- **Use `config.plist` for Bootloader and High-Level Settings:** For configurations that pertain to the bootloader itself or high-level system settings, the `config.plist` is appropriate. This includes settings like boot arguments, enabling or disabling kexts, and other bootloader-specific options.

### Conclusion

While both SSDTs and the `config.plist` can be used to inject properties in OpenCore, the precedence and timing of their application differ. SSDTs, being part of the ACPI layer, are processed earlier and can override properties set later in the boot process by the `config.plist`. Therefore, for critical hardware-level property injections, SSDTs are generally the preferred method.

For more detailed guidance on configuring OpenCore and the use of SSDTs, you can refer to the [**OpenCore Configuration Documentation**](https://dortania.github.io/docs/latest/Configuration.html).  

[←**Back to Overview**](./README.md) | [**Next: Converting .dsl files to .aml →**](05_DSL2AML.md)


