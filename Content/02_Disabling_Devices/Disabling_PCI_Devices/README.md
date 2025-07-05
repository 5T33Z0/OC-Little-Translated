# Disabling PCI Devices

## About
In some cases you may want to disable a PCI device. For example, the HDMI Audio Device of a discrete GPU or an incompatible SD Card Reader attached via PCIe. There are 2 methods for disabling PCI devices: either by using an SSDT or by blocking the kext which enables the device.

When to use which method depends on the situation. Using an SSDT is preferred but only works if the device in question is a children device on the PCI bus.

## Methods

- **Method 1**: [**via SSDT**](/Content/02_Disabling_Devices/Disabling_PCI_Devices/ACPI) (recommended)
- **Method 2**: [**by blocking Kexts**](/Content/02_Disabling_Devices/Disabling_PCI_Devices/Block_Kexts)
