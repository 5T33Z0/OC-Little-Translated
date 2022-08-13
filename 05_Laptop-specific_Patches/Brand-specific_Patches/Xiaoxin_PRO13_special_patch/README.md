# Special patch for Xiaoxin PRO13

## Special renaming

Rename `PNLF` to `XNLF`

```
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

## Other required Patches (Reference)

- ***SSDT-PLUG-_SB.PR00*** 
- ***SSDT-EC***
- ***SSDT-PNLF-CFL*** 
- ***SSDT-PMCR*** 
- ***SSDT-SBUS***
- ***SSDT-OCBAT1-lenovoPRO13***
- ***SSDT-I2CxConf***
- ***SSDT-OCI2C-TPXX-lenovoPRO13***
- ***SSDT-CB-01_XHC***
- ***SSDT-GPRW***
- ***SSDT-RTC_Y-AWAC_N***
- ***SSDT-RMCF-PS2Map-LenovoPRO13***
- ***SSDT-OCPublic-Merge*** – Patch for this chapter, see **Attachment** Description
- ***SSDT-BATS-PRO13***

**Note**: The name changes required for the above patches are in the comments of the corresponding source code patch files (.dsl).

## Annex: Merging Shared Patches

- To simplify the operation as well as to reduce the number of patches, certain common patches are merged togother within: ***SSDT-OCPublic-Merge***.

### Merged Patches

- ***SSDT-EC-USBX*** - from the **USBX** section of the official OC patch example
- ***SSDT-ALS0*** - original patch located in Counterfeit Devices - Counterfeit Ambient Light Sensors
- ***SSDT-MCHC*** - the original patch is located in Adding Missing Parts

### Caution

- ***SSDT-OCPublic-Merge*** applies to all machines.
- After using ***SSDT-OCPublic-Merge***, the patches listed above **<u>Merged Patches</u>** no longer apply.
