# Special patch for Xiaoxin PRO13

## Special renaming

PNLF renamed XNLF

```text
Find: 504E4C46
Replace: 584E4C46
```

The variable `PNLF` exists in the DSDT of XNLF, which may conflict with the name of the brightness patch, so use the above name change to circumvent it.

## Special AOAC patches

- ***SSDT-NameS3-disable*** 
- ***SSDT-NDGP_OFF-AOAC***
- ***SSDT-DeepIdle***
- ***SSDT-PCI0.LPCB-Wake-AOAC***

Note: Please refer to "Fixing AOAC Machines" in chapter 06 for more info

## Other Patches (Reference)

- ***SSDT-PLUG-_SB.PR00*** --see section 03. Enabling Features/How to enabe CPU Power Management (SSDT-PLUG)
- ***SSDT-EC*** --see section 02 "Adding Fake Devices"
- ***SSDT-PNLF-CFL*** --see section 03. Enabling Features/How to enable Brightness Controls (PNLF) 
- ***SSDT-PMCR*** --see section "Adding Missing components"
- ***SSDT-SBUS*** --see section "Adding Missing components"
- ***SSDT-OCBAT1-lenovoPRO13*** --see section 07. Laptop-specific Patches/Battery Patches
- ***SSDT-I2CxConf*** --see section 07. Laptop-specific Patches/I2C TrackPad Patches
- ***SSDT-OCI2C-TPXX-lenovoPRO13*** --see same
- ***SSDT-CB-01_XHC*** --see section 05. USB Fixes/ACPI Custom USB Port
- ***SSDT-GPRW*** --see section 06. Fixing Sleep and Wake Issues/060D Instant Wake Fix
- ***SSDT-RTC_Y-AWAC_N*** --see section 01. Adding Fake Devices/System Clock (AWAC)
- ***SSDT-RMCF-PS2Map-LenovoPRO13*** --see section 07. Laptop-specific Patches/Fixing Keyboard Mappings and Brightness Keys
- ***SSDT-OCPublic-Merge*** -- Patch for this chapter, see **Attachment** Description
- ***SSDT-BATS-PRO13*** --see section 07. Laptop-specific Patches/Battery Patches

**Note**: The name changes required for the above patches are in the comments of the corresponding source code patch files (.dsl).

## Annex: Merging Shared Patches

- To simplify the operation as well as to reduce the number of patches, certain common patches are merged as:***SSDT-OCPublic-Merge*** .

### Merged Patches

- ***SSDT-EC-USBX*** - from the **USBX** section of the official OC patch example
- ***SSDT-ALS0*** - original patch located in Counterfeit Devices - Counterfeit Ambient Light Sensors
- ***SSDT-MCHC*** - the original patch is located in Adding Missing Parts

### Caution

- ***SSDT-OCPublic-Merge*** applies to all machines.
- After using ***SSDT-OCPublic-Merge***, the patches listed above **<u>Merged Patches</u>** no longer apply.
