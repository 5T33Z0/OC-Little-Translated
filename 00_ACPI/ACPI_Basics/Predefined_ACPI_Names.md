# Predefined ACPI Names for Objects, Methods, and Resources
The table below lists all reserved ACPI names available in ASL. So if you find a word in your `DSDT` starting with an underscore (_) and you want to know what it's for, you can look it up in here.

Name | Description
-----|-----------
`_ACx`|Active Cooling – returns the active cooling policy threshold values.
`_ADR`|Address: (1) returns the address of a device on its parent bus. (2) returns a unique ID for the display output device. (3) resource descriptor field. 
`_AEI`|Designates those GPIO interrupts that shall be handled by OSPM as ACPI events.
`_ALC`|Ambient Light Chromaticity – returns the ambient light color chromaticity.
`_ALI`|Ambient Light Illuminance – returns the ambient light brightness.
`_ALN`|Alignment – base alignment, resource descriptor field.
`_ALP`|Ambient Light Polling – returns the ambient light sensor polling frequency.
`_ALR`|Ambient Light Response – returns the ambient light brightness to display brightness mappings.
`_ALT`|Ambient Light Temperature – returns the ambient light color temperature.
`_ALx`|Active List – returns a list of active cooling device objects.
`_ART`|Active cooling Relationship Table – returns thermal relationship information between platform devices and fan devices.
`_ASI`|Address Space Id – resource descriptor field.
`_ASZ`|Access Size – resource descriptor field.
`_ATT`|Type-Specific Attribute – resource descriptor field.
`_BAS`|Base Address – range base address, resource descriptor field.
`_BBN`|Bios Bus Number – returns the PCI bus number returned by the platform firmware.
`_BCL`|Brightness Control Levels – returns a list of supported brightness control levels.
`_BCM`|Brightness Control Method – sets the brightness level of the display device.
`_BCT`|Battery Charge Time – returns time remaining to complete charging battery.
`_BDN`|Bios Dock Name – returns the Dock ID returned by the platform firmware.
`_BIF`|Battery Information – returns a Control Method Battery information block.
`_BIX`|Battery Information Extended – returns a Control Method Battery extended information block.
`_BLT`|Battery Level Threshold – set battery level threshold preferences.
`_BM`|Bus Master – resource descriptor field.
`_BMA`|Battery Measurement Averaging Interval – Sets battery measurement averaging interval.
`_BMC`|Battery Maintenance Control – Sets battery maintenance and control features.
`_BMD`|Battery Maintenance Data – returns battery maintenance, control, and state data.
`_BMS`|Battery Measurement Sampling Time – Sets the battery measurement sampling time.
`_BPC`|Battery Power Characteristics
`_BPS`|Battery Power State
`_BPT`|Battery Power Threshold
`_BQC`|Brightness Query Current – returns the current display brightness level.
`_BST`|Battery Status – returns a Control Method Battery status block.
`_BTH`|Battery Throttle Limit - specifies the thermal throttle limit of battery for the firmware when engaging charging.
`_BTM`|Battery Time – returns the battery runtime.
`_BTP`|Battery Trip Point – sets a Control Method Battery trip point.
`_CBA`|Configuration Base Address – returns the base address of the MMIO range corresponding to the Enhanced Configuration Access Mechanism for a PCI Express or Compute Express Link host bus. The full description for the `_CBA` object resides in the PCI Firmware Specification. A reference to that specification is found in the “Links to ACPI-Related Documents” (http://uefi.org/acpi) under the heading “PCI SIG”.
`_CBR`|CXL Host Bridge Register Info
`_CCA`|Cache Coherency Attribute – specifies whether a device and its descendants support hardware managed cache coherency.
`_CDM`|Clock Domain – returns a logical processor’s clock domain identifier.
`_CID`|Compatible ID – returns a device’s Plug and Play Compatible ID list.
`_CLS`|Class Code – supplies OSPM with the PCI-defined class, subclass and programming interface for a device. Optional.
`_CPC`|Continuous Performance Control – declares an interface that allows OSPM to transition the processor into a performance state based on a continuous range of allowable values.
`_CRS`|Current Resource Settings – returns the current resource settings for a device.
`_CRT`|Critical Temperature – returns the shutdown critical temperature.
`_CSD`|C State Dependencies – returns a list of C-state dependencies.
`_CST`|C States – returns a list of supported C-states.
`_CWS`|Clear Wake Status – Clears the wake status of a Time and Alarm Control Method Device.
`_DBT`|Debounce Timeout -Debounce timeout setting for a GPIO input connection, resource descriptor field
`_DCK`|Dock – sets docking isolation. Presence indicates device is a docking station.
`_DCS`|Display Current Status – returns status of the display output device.
`_DDC`|Display Data Current – returns the EDID for the display output device.
`_DDN`|Dos Device Name – returns a device logical name.
`_DEC`|Decode – device decoding type, resource descriptor field.
`_DEP`|Operation Region Dependencies – evaluates to a package and designates device objects that OSPM should assign a higher priority in start ordering due to future operation region accesses.
`_DGS`|Display Graphics State – returns the current state of the output device.
`_DIS`|Disable – disables a device.
`_DLM`|Device Lock Mutex- Designates a mutex as a Device Lock.
`_DMA`|Direct Memory Access – returns a device’s current resources for DMA transactions.
`_DOD`|Display Output Devices – enumerate all devices attached to the display adapter.
`_DOS`|Disable Output Switching – sets the display output switching mode.
`_DPL`|Device Selection Polarity - The polarity of the Device Selection signal on a SPISerialBus connection, resource descriptor field
`_DRS`|Drive Strength – Drive strength setting for a GPIO output connection, resource descriptor field
`_DSD`|Device Specific Data– returns device-specific information.
`_DSM`|Device Specific Method – executes device-specific functions.
`_DSS`|Device Set State – sets the display device state.
`_DSW`|Device Sleep Wake – sets the sleep and wake transition states for a device.
`_DTI`|Device Temperature Indication – conveys native device temperature to the platform.
`_Exx`|Edge GPE – method executed as a result of a general-purpose event.
`_EC`|Embedded Controller – returns EC offset and query information.
`_EDL`|Eject Device List – returns a list of devices that are dependent on a device (docking).
`_EJD`|Ejection Dependent Device – returns the name of dependent (parent) device (docking).
`_EJx`|Eject – begin or cancel a device ejection request (docking).
`_END`|Endian-ness – Endian orientation of a UART SerialBus connection, resource descriptor field
`_EVT`|Event Method - Event method for GPIO-signaled events numbered larger than 255.
`_FDE`|Floppy Disk Enumerate – returns floppy disk configuration information.
`_FDI`|Floppy Drive Information – returns a floppy drive information block.
`_FDM`|Floppy Drive Mode – sets a floppy drive speed.
`_FIF`|Fan Information – returns fan device information.
`_FIT`|Firmware Interface Table - returns a list of NFIT Structures.
`_FIX`|Fixed Register Resource Provider – returns a list of devices that implement FADT register blocks.
`_FLC`|Flow Control – Flow Control mechanism for a UART SerialBus connection, resource descriptor field
`_FPS`|Fan Performance States – returns a list of supported fan performance states.
`_FSL` |Fan Set Level – Control method that sets the fan device’s speed level (performance state).
`_FST`|Fan Status – returns current status information for a fan device.
`_GAI`|Get Averaging Interval – returns the power meter averaging interval.
`_GCP`|Get Capabilities – Returns the capabilities of a Time and Alarm Control Method Device
`_GHL`|Get Hardware Limit – returns the hardware limit enforced by the power meter.
`_GL` |Global Lock – OS-defined Global Lock mutex object.
`_GLK`|Global Lock – returns a device’s Global Lock requirement for device access.
`_GPD`|Get Post Data – returns the value of the VGA device that will be posted at boot.
`_GPE`|General Purpose Events: (1) predefined Scope (`_GPE`). (2) Returns the SCI interrupt associated with the Embedded Controller.
`_GRA`|Granularity – address space granularity, resource descriptor field.
`_GRT`|Get Real Time – Returns the current time from a Time and Alarm Control Method Device.
`_GSB`|Global System Interrupt Base – returns the GSB for a I/O APIC device.
`_GTF`|Get Task File – returns a list of ATA commands to restore a drive to default state.
`_GTM`|Get Timing Mode – returns a list of IDE controller timing information.
`_GWS`|Get Wake Status – Gets the wake status of a Time and Alarm Control Method Device.
`_HE`|High-Edge – interrupt triggering, resource descriptor field.
`_HID`|Hardware ID – returns a device’s Plug and Play Hardware ID.
`_HMA`|Heterogeneous Memory Attributes - returns a list of HMAT structures.
`_HOT`|Hot Temperature – returns the critical temperature for sleep (entry to S4).
`_HPP`|Hot Plug Parameters – returns a list of hot-plug information for a PCI device.
`_HPX`|Hot Plug Parameter Extensions – returns a list of hot-plug information for a PCI device. Supersedes `_HPP`.
`_HRV`|Hardware Revision– supplies OSPM with the device’s hardware revision. Optional.
`_IFT`|IPMI Interface Type. See the Intelligent Platform Management Interface Specification at “Links to ACPI-Related Documents” (http://uefi.org/acpi) under the heading “Server Platform Management Interface Table”.
`_INI`|Initialize – performs device specific initialization.
`_INT`|Interrupts – interrupt mask bits, resource descriptor field.
`_IOR`|IO Restriction – IO restriction setting for a GPIO IO connection, resource descriptor field
`_IRC`|Inrush Current – presence indicates that a device has a significant inrush current draw.
`_Lxx`|Level GPE – Control method executed as a result of a general-purpose event.
`_LCK`|Lock – locks or unlocks a device (docking).
`_LEN`|Length – range length, resource descriptor field.
`_LID`|Lid – returns the open/closed status of the lid on a mobile system.
`_LIN`|Lines in Use - Handshake lines in use in a UART SerialBus connection, resource descriptor field
`_LL`|Low Level – interrupt polarity, resource descriptor field.
`_LPI`|Low Power Idle States – returns the list of low power idle states supported by a processor or processor container.
`_LSI`|Label Storage Information – Returns information about the Label Storage Area associated with the NVDIMM object, including its size.
`_LSR`|Label Storage Read – Returns label data from the Label Storage Area of the NVDIMM object.
`_LSW`|Label Storage Write – Writes label data in to the Label Storage Area of the NVDIMM object.
`_MAF`|Maximum Address Fixed – resource descriptor field.
`_MAT`|Multiple Apic Table Entry – returns a list of Interrupt Controller Structures.
`_MAX`|Maximum Base Address – resource descriptor field.
`_MBM`|Memory Bandwidth Monitoring Data – returns bandwidth monitoring data for a memory device.
`_MEM`|Memory Attributes – resource descriptor field.
`_MIF`|Minimum Address Fixed – resource descriptor field.
`_MIN`|Minimum Base Address – resource descriptor field.
`_MLS`|Multiple Language String – returns a device description in multiple languages.
`_MOD`|Mode –Resource descriptor field
`_MSG`|Message – sets the system message waiting status indicator.
`_MSM`|Memory Set Monitoring – sets bandwidth monitoring parameters for a memory device.
`_MTL`|Minimum Throttle Limit – returns the minimum throttle limit of a specific thermal.
`_MTP`|Memory Type – resource descriptor field.
`_NTT`|Notification Temperature Threshold – returns a threshold for device temperature change that requires platform notification.
`_OFF`|Off – sets a power resource to the off state.
`_ON`|On – sets a power resource to the on state.
`_OS`|Operating System – returns a string that identifies the operating system.
`_OSC`|Operating System Capabilities – inform AML of host features and capabilities.
`_OSI`|Operating System Interfaces – returns supported interfaces, behaviors, and features.
`_OST`|Ospm Status Indication – inform AML of event processing status.
`_PAI`|Power Averaging Interval – sets the averaging interval for a power meter.
`_PAR`|Parity – Parity for a UART SerialBus connection, resource descriptor field
`_PCL`|Power Consumer List – returns a list of devices powered by a power source.
`_PCT`|Performance Control – returns processor performance control and status registers.
`_PDC`|Processor Driver Capabilities – inform AML of processor driver capabilities.
`_PDL`|P-state Depth Limit – returns the lowest available performance P-state.
`_PHA`|Clock Phase – Clock phase for a SPISerialBus connection, resource descriptor field
`_PIC`|PIC – inform AML of the interrupt model in use.
`_PIF`|Power Source Information – returns a Power Source information block.
`_PIN`|Pin List – List of GPIO pins described, resource descriptor field.
`_PLD`|Physical Location of Device – returns a device’s physical location information.
`_PMC`|Power Meter Capabilities – returns a list of Power Meter capabilities info.
`_PMD`|Power Metered Devices – returns a list of devices that are measured by the power meter device.
`_PMM`|Power Meter Measurement – returns the current value of the Power Meter.
`_POL`|Polarity – Resource descriptor field
`_PPC`|Performance Present Capabilites – returns a list of the performance states currently supported by the platform.
`_PPE`|Polling for Platform Error – returns the polling interval to retrieve Corrected Platform Error information.
`_PPI`|Pin Configuration – Pin configuration for a GPIO connection, resource descriptor field
`_PR`|Processor – predefined scope for processor objects.
`_PR0`|Power Resources for D0 – returns a list of dependent power resources to enter state D0 (fully on).
`_PR1`|Power Resources for D1 – returns a list of dependent power resources to enter state D1.
`_PR2`|Power Resources for D2 – returns a list of dependent power resources to enter state D2.
`_PR3`|Power Resources for D3hot – returns a list of dependent power resources to enter state D3hot.
`_PRE`|Power Resources for Enumeration - Returns a list of dependent power resources to enumerate devices on a bus.
`_PRL`|Power Source Redundancy List – returns a list of power source devices in the same redundancy grouping.
`_PRR`|Power Resource for Reset – executes a reset on the associated device or devices.
`_PRS`|Possible Resource Settings – returns a list of a device’s possible resource settings.
`_PRT`|Pci Routing Table – returns a list of PCI interrupt mappings.
`_PRW`|Power Resources for Wake – returns a list of dependent power resources for waking.
`_PS0`|Power State 0 – sets a device’s power state to D0 (device fully on).
`_PS1`|Power State 1 – sets a device’s power state to D1.
`_PS2`|Power State 2 – sets a device’s power state to D2.
`_PS3`|Power State 3 – sets a device’s power state to D3 (device off).
`_PSC`|Power State Current – returns a device’s current power state.
`_PSD`|Power State Dependencies – returns processor P-State dependencies.
`_PSE`|Power State for Enumeration
`_PSL`|Passive List – returns a list of passive cooling device objects.
`_PSR`|Power Source – returns the power source device currently in use.
`_PSS`|Performance Supported States – returns a list of supported processor performance states.
`_PSV`|Passive – returns the passive trip point temperature.
`_PSW`|Power State Wake – sets a device’s wake function.
`_PTC`|Processor Throttling Control – returns throttling control and status registers.
`_PTP`|Power Trip Points – sets trip points for the Power Meter device.
`_PTS`|Prepare To Sleep – inform the platform of an impending sleep transition.
`_PUR`|Processor Utilization Request – returns the number of processors that the platform would like to idle.
`_PXM`|Proximity – returns a device’s proximity domain identifier.
`_Qxx`|Query – Embedded Controller query and SMBus Alarm control method.
`_RBO`|Register Bit Offset – resource descriptor field.
`_RBW`|Register Bit Width – resource descriptor field.
`_RDI`|Resource Dependencies for Idle - returns the list of power resource dependencies for system level low power idle states.
`_REG`|Region – inform AML code of an operation region availability change.
`_REV`|Revision – returns the revision of the ACPI specification that is implemented.
`_RMV`|Remove – returns a device’s removal ability status (docking).
`_RNG`|Range – memory range type, resource descriptor field.
`_ROM`|Read-Only Memory – returns a copy of the ROM data for a display device.
`_RST`|Device Reset – executes a reset on the associated device or devices.
`_RT`|Resource Type – resource descriptor field.
`_RTV`|Relative Temperature Values – returns temperature value information.
`_RW`|Read-Write Status – resource descriptor field.
`_RXL`|Receive Buffer Size - Size of the receive buffer in a UART Serialbus connection, resource descriptor field.
`_S0`|S0 System State – returns values to enter the system into the S0 state.
`_S1`|S1 System State – returns values to enter the system into the S1 state.
`_S2`|S2 System State – returns values to enter the system into the S2 state.
`_S3`|S3 System State – returns values to enter the system into the S3 state.
`_S4`|S4 System State – returns values to enter the system into the S4 state.
`_S5`|S5 System State – returns values to enter the system into the S5 state.
`_S1D`|S1 Device State – returns the highest D-state supported by a device when in the S1 state.
`_S2D`|S2 Device State – returns the highest D-state supported by a device when in the S2 state.
`_S3D`|S3 Device State – returns the highest D-state supported by a device when in the S3 state.
`_S4D`|S4 Device State – returns the highest D-state supported by a device when in the S4 state.
`_S0W`|S0 Device Wake State – returns the lowest D-state that the device can wake itself from S0.
`_S1W`|S1 Device Wake State – returns the lowest D-state for this device that can wake the system from S1.
`_S2W`|S2 Device Wake State – returns the lowest D-state for this device that can wake the system from S2.
`_S3W`|S3 Device Wake State – returns the lowest D-state for this device that can wake the system from S3.
`_S4W`|S4 Device Wake State – returns the lowest D-state for this device that can wake the system from S4.
`_SB`|System Bus – scope for device and bus objects.
`_SBS`|Smart Battery Subsystem – returns the subsystem configuration.
`_SCP`|Set Cooling Policy – sets the cooling policy (active or passive).
`_SDD`|Set Device Data – sets data for a SATA device.
`_SEG`|Segment – returns a device’s PCI Segment Group number.
`_SHL`|Set Hardware Limit – sets the hardware limit enforced by the Power Meter.
`_SHR`|Shareable - interrupt share status, resource descriptor field.
`_SI`|System Indicators – predefined scope.
`_SIZ`|Size – DMA transfer size, resource descriptor field.
`_SLI`|System Locality Information – returns a list of NUMA system localities.
`_SLV`|Slave Mode – Slave mode setting for a SerialBus connection, resource descriptor field.
`_SPD`|Set Post Device – sets which video device will be posted at boot.
`_SPE`|Connection Speed – Connection speed for a SerialBus connection, resource descriptor field
`_SRS`|Set Resource Settings – sets a device’s resource allocation.
`_SRT`|Set Real Time – Sets the current time to a Time and Alarm Control Method Device.
`_SRV`|IPMI Spec Revision. See the Intelligent Platform Management Interface Specification at “Links to ACPI-Related Documents” (http://uefi.org/acpi) under the heading “Server Platform Management Interface Table”.
`_SST`|System Status – sets the system status indicator.
`_STA`|Status : (1) returns the current status of a device. (2) Returns the current on or off state of a Power Resource.
`_STB`|Stop Bits - Number of stop bits used in a UART SerialBus connection, resource descriptor field
`_STM`|Set Timing Mode – sets an IDE controller transfer timings.
`_STP`|Set Expired Timer Wake Policy – sets expired timer policies of the wake alarm device.
`_STR`|String – returns a device’s description string.
`_STV`|Set Timer Value – set timer values of the wake alarm device.
`_SUB`|Supplies OSPM with the device’s Subsystem ID. Optional.
`_SUN`|Slot User Number – returns the slot unique ID number.
`_SWS`|System Wake Source – returns the source event that caused the system to wake.
`_T_x`|Temporary – reserved for use by ASL compilers.
`_TC1`|Thermal Constant 1 – returns TC1 for the passive cooling formula.
`_TC2`|Thermal Constant 2 – returns TC2 for the passive cooling formula.
`_TDL`|T-State Depth Limit – returns the _TSS entry number of the lowest power throttling state.
`_TFP`|Thermal Fast Sampling Period - returns the thermal sampling period for passive cooling.
`_TIP`|Expired Timer Wake Policy – returns timer policies of the wake alarm device.
`_TIV`|Timer Values – returns remaining time of the wake alarm device.
`_TMP`|Temperature – returns a thermal zone’s current temperature.
`_TPC`|Throttling Present Capabilities – returns the current number of supported throttling states.
`_TPT`|Trip Point Temperature – inform AML that a devices’ embedded temperature sensor has crossed a temperature trip point.
`_TRA`|Translation – address translation offset, resource descriptor field.
`_TRS`|Translation Sparse – sparse/dense flag, resource descriptor field.
`_TRT`|Thermal Relationship Table – returns thermal relationships between platform devices.
`_TSD`|Throttling State Dependencies – returns a list of T-state dependencies.
`_TSF`|Type-Specific Flags – resource descriptor field.
`_TSN`|Thermal Sensor Device - returns a reference to the thermal sensor reporting a zone temperature
`_TSP`|Thermal Sampling Period – returns the thermal sampling period for passive cooling.
`_TSS`|Throttling Supported States – returns supported throttling state information.
`_TST`|Temperature Sensor Threshold – returns the minimum separation for a device’s temperature trip points.
`_TTP`|Translation Type – translation/static flag, resource descriptor field.
`_TTS`|Transition To State – inform AML of an S-state transition.
`_TXL`|Transmit Buffer Size – Size of the transmit buffer in a UART Serialbus connection, resource descriptor field
`_TYP`|Type – DMA channel type (speed), resource descriptor field.
`_TZ`|Thermal Zone – predefined scope: ACPI 1.0.
`_TZD`|Thermal Zone Devices – returns a list of device names associated with a Thermal Zone.
`_TZM`|Thermal Zone Member – returns a reference to the thermal zone of which a device is a member.
`_TZP`|Thermal Zone Polling – returns a Thermal zone’s polling frequency.
`_UID`|Unique ID – return a device’s unique persistent ID.
`_UPC`|USB Port Capabilities – returns a list of USB port capabilities.
`_UPD`|User Presence Detect – returns user detection information.
`_UPP`|User Presence Polling – returns the recommended user presence polling interval.
`_VEN`|Vendor-defined Data – Vendor-defined data for a GPIO or SerialBus connection, resource descriptor field
`_VPO`|Video Post Options – returns the implemented video post options.
`_WAK`|Wake – inform AML that the system has just awakened.
`_WPC`|Wireless Power Calibration - returns the notifier to wireless power controller.
`_WPP`|Wireless Power Polling - returns the recommended polling frequency
`_Wxx`|Wake Event – method executed as a result of a wake event.

**SOURCE**: [**ACPI Specs**](https://uefi.org/specifications), Chpt. 5.6.8: "Predefined ACPI Names for Objects, Method and Resources"
