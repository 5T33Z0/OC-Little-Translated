# SSDTs for using OpenCore Inside Microsoft Hyper-V

## About Hyper-V

> Hyper-V enables running virtualized computer systems on top of a physical host. These virtualized systems can be used and managed just as if they were physical computer systems, however they exist in virtualized and isolated environment. Special software called a hypervisor manages access between the virtual systems and the physical hardware resources. Virtualization enables quick deployment of computer systems, a way to quickly restore systems to a previously known good state, and the ability to migrate systems between physical hosts. 
>
> **Source**: [Microsoft](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/)

> [!CAUTION]
> 
> These SSDTs apply to a **macOS guest VM** running under Hyper-V on a Windows host — not to a Mac or Hackintosh running macOS as the host OS. They belong in the OpenCore EFI on the VM's virtual disk.

## Required SSDTs

All SSDTs listed below are included in the OpenCore package under `Docs/AcpiSamples`. Check the `.dsl` source of each table for additional comments and load-order notes.

| File | Purpose |
|---|---|
| **SSDT-HV-DEV.aml** | Disables unsupported devices under macOS. |
| **SSDT-HV-PLUG.aml** | Enables VMPlatformPlugin on Big Sur and newer. Must be loaded **after** `SSDT-HV-DEV.aml`. |
| **SSDT-HV-VMBUS.aml** | Enables ACPI node identification. |
| **SSDT-HV-DEV-WS2022.aml** | Disables additional virtual devices incompatible with macOS. Required on Windows 11, Windows Server 2022, and newer. |

**Additionally, you need this kext**:

- **MacHyperVSupport.kext** → Download it [here](https://github.com/acidanthera/MacHyperVSupport/releases)

> [!NOTE]
>
> The latest release also includes an installer package (`MacHyperVSupportTools-x.x.x-Release.mpkg.zip`) for the userspace integration daemons (file copy, shutdown, time sync). Run this once macOS has booted inside the VM. → Please follow the detailed OpenCore Configuration instructions on Acidanthera's [**MacHyperVSupport**](https://github.com/acidanthera/MacHyperVSupport) repo.

> [!TIP]
> 
> For instructions on how to setup and run macOS inside Hyper-V check my in-depth guide [**macOS in Hyper-V**](/Content/V_Virtualization/macOS_Hyper-V.md)
