# Enhanced macOS Version Control with `SSDT-Darwin` and `OSIEnhancer`

## About

As you may know, ACPI specifications allow for OS-specific patches through the `_OSI` (Operating System Interface) method, commonly used in Hackintosh systems via `If (_OSI ("Darwin"))`. However, this basic approach only provides binary detection - either macOS is running or it isn't. For more granular control, you need both **`SSDT-Darwin`** and **`OSIEnhancer.kext`** working together. 

This combination enables version-specific ACPI patches by extending the `_OSI` functionality to recognize specific Darwin/macOS versions. Think of it as bringing the flexibility of `MinKernel`/`MaxKernel` settings from kexts into your ACPI tables. This is particularly valuable when you need to apply different patches based on macOS versions - for example, implementing different `AAPL,ig-platform-id` values and framebuffer patches for an unsupported iGPU across different macOS releases.

Since OSIEnhancer is a relatively new kext, there aren’t many SSDT examples available for reference – some can be find on the repo, though. Its use cases tend to be highly specific and tailored to individual machines, as the patches often depend on unique hardware configurations and the macOS versions in question. This makes it more of a "per-machine" solution, requiring users to create custom SSDTs that address their particular needs. As a result, implementing OSIEnhancer may involve some trial and error, along with a solid understanding of ACPI and system-specific requirements.

## Instructions

- Add the [**`OSIEnhancer`**](https://github.com/b00t0x/OSIEnhancer) kext to your `EFI/OC/Kexts` folder and `config.plist`
- Add [**`SSDT-Darwin.aml`**](https://github.com/b00t0x/OSIEnhancer/blob/main/SSDT/SSDT-Darwin.dsl) to your ACPI tables 
- Add addtional SSDT for the device you want to inject different properties for different versions of macOS (check the OSIEnhancer repo for examples)

Note that this solution typically requires custom SSDT implementation for your specific hardware configuration and macOS version requirements. While example SSDTs are available in the OSIEnhancer repository, you'll likely need to create custom patches tailored to your system's needs.
