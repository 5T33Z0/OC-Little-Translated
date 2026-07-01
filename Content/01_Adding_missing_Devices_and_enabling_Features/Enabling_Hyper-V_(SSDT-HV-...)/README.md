# Preparing an OpenCore EFI for Use with Microsoft Hyper-V

## About Hyper-V

> Hyper-V enables running virtualized computer systems on top of a physical host. These virtualized systems can be used and managed just as if they were physical computer systems, however they exist in virtualized and isolated environment. Special software called a hypervisor manages access between the virtual systems and the physical hardware resources. Virtualization enables quick deployment of computer systems, a way to quickly restore systems to a previously known good state, and the ability to migrate systems between physical hosts.
>
> **Source**: [Microsoft](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/)

> [!NOTE]
> 
> This guide does **not** enable Hyper-V support on a Mac or Hackintosh running macOS as the host OS. It configures an OpenCore EFI for a **macOS guest VM** running under Hyper-V on a Windows host. All files below go into the EFI partition of the macOS VM's virtual disk – not the EFI of the physical machine.

## Required Files

You need the following SSDTs (included in the OpenCore Package under `Docs/AcpiSamples`). Check the .dsl version of these tables for additional comments and instructions.

| File | Purpose |
|---|---|
| **SSDT-HV-DEV.aml** | Disables unsupported devices under macOS. |
| **SSDT-HV-DEV-WS2022.aml** | Disables additional virtual devices incompatible with macOS. Required on Windows 11, Windows Server 2022 and newer. |
| **SSDT-HV-PLUG.aml** | Enables VMPlatformPlugin on Big Sur and newer. Must be loaded **after** `SSDT-HV-DEV.aml`. |
| **SSDT-HV-VMBUS.aml** | Enables ACPI node identification. |

Additionally, you need this kext:

- **MacHyperVSupport.kext** → Download it [here](https://github.com/acidanthera/MacHyperVSupport/releases)

> [!CAUTION]
> 
> These SSDTs and the kext must be placed in the OpenCore EFI on the **virtual disk of the macOS VM**, configured via `config.plist` inside that VM's EFI — not on the Hyper-V host's boot drive.

## Instructions

→ Please follow the detailed OpenCore Configuration instructions on Acidanthera's [**MacHyperVSupport**](https://github.com/acidanthera/MacHyperVSupport) repo.

> [!TIP]
> 
> For instructions on how to setup and run macOS inside Hyper-V check my in-depth guide [**macOS in Hyper-V**](Content/V_Virtualization/macOS_Hyper-V.md)
