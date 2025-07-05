# Enabling Hyper-V support in macOS

## About Hyper-V

> Hyper-V enables running virtualized computer systems on top of a physical host. These virtualized systems can be used and managed just as if they were physical computer systems, however they exist in virtualized and isolated environment. Special software called a hypervisor manages access between the virtual systems and the physical hardware resources. Virtualization enables quick deployment of computer systems, a way to quickly restore systems to a previously known good state, and the ability to migrate systems between physical hosts.
> 
**Source**: [Microsoft](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/)

## Required Files

You need the following SSDTs (included in the OpenCore Package under `Docs/AcpiSamples`). Check the .dsl version of these tables for additional comments and instructions.

- **SSDT-HV-DEV.aml** &rarr; Disables unsupported devices under macOS.
- **SSDT-HV-DEV-WS2022** &rarr; Disables additional virtual devices incompatible with macOS. Required on Windows 11, Windows Server 2022 and newer.
- **SSDT-HV-PLUG.aml** &rarr; Enables VMPlatformPlugin on Big Sur and newer. Must be loaded after SSDT-HV-DEV.aml!
- **SSDT-HV-VMBUS.aml** &rarr; Enables ACPI node identification.

Additionally, you need this kext:

- **MacHyperVSupport.kext** &rarr; Download it [here](https://github.com/acidanthera/MacHyperVSupport/releases)

## Instructions
&rarr; Please follow the detailed OpenCore Configuration instructions on Acidanthera's [**MacHyperVSupport**](https://github.com/acidanthera/MacHyperVSupport) Repo.
