# ACPI Power States

**ACPI** (Advanced Configuration and Power Interface) defines standardized power states for both entire systems and individual devices, enabling fine-grained power management across computer hardware.

## Global System States (G-States)

The ACPI specification defines three global states that describe the overall system status:

State | Description
------|------------
**G0 (Working)** | The system is fully operational and running. This corresponds to the S0 system state where the operating system is active and executing tasks.
**G1 (Sleeping)** | The system appears off but maintains context to enable quick resumption. This global state encompasses multiple sleep levels (S1 through S4), each offering different balances between power savings and wake time.
**G2 (Soft Off)** | The system is off from a software perspective but maintains minimal power to certain components. Wake events from devices like keyboards, network adapters, or USB peripherals can trigger system startup. This corresponds to the S5 state.

**G3 (Mechanical Off)** - The system is completely powered down with only residual power for the real-time clock. No context is preserved, and the system cannot wake from external events. This requires manual power-on via the physical power button.

## System Sleep States (S-States)

Within the sleeping global state (G1), ACPI defines graduated sleep levels:

State | Description
------|------------
**S0** | Normal operating state where the system is fully powered and the OS is running.
**S1 (Power on Suspend)** | The processor stops executing instructions and caches are flushed, but power remains supplied to the CPU and RAM. Recovery is very fast.
**S2 (CPU Power Off)** | Similar to S1 but with CPU and cache powered down. This state is rarely implemented in modern systems.
**S3 (Suspend to RAM)** | Commonly known as "Sleep" or "Standby." RAM remains powered to preserve system state, but most other components including the CPU are powered off. This provides significant power savings with reasonably fast wake times.
**S4 (Hibernate)** | System context is written to non-volatile storage (typically the hard drive), allowing all components including RAM to be powered off. Wake time is slower than S3 but power consumption is minimal.
**S5 (Soft Off)** | The system is off but the power supply remains in standby mode. Certain devices can be configured to generate wake events, though no system state is preserved in RAM.

## Device Power States (D-States)

Individual devices have their own power state hierarchy independent of system states:

State | Description
------|------------
**D0 (Fully On)** | The device is fully powered and operational.
**D1 and D2 (Intermediate States)** | Device-specific low-power states that may or may not be implemented. The exact behavior depends on the device class and manufacturer implementation.
**D3 (Off)** | The device is powered off. This state has two variants: <ul><li>**D3hot**: The device is off but still connected to its power source and can signal wake events <li>**D3cold**: The device is completely unpowered with no ability to wake the system

## Modern Implementations

Contemporary systems often implement "Modern Standby" (also called „S0 Low Power Idle“), which keeps the system technically in S0 but transitions individual components to low-power states. This enables smartphone-like behavior where the system can receive notifications and updates while appearing to be asleep.

## Further Ressources
- ACPI Specs, Chapter 8.1: [**Processor Power States**](https://uefi.org/htmlspecs/ACPI_Spec_6_4_html/08_Processor_Configuration_and_Control/processor-power-states.html)
