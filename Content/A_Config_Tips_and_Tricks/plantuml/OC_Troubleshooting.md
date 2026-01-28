# OC Troubleshooting

```
@startuml
title OpenCore Configuration Troubleshooting Guide

skinparam activity {
  BackgroundColor<<Success>> #98D8C8
  BackgroundColor<<Failure>> #FF6B6B
  BackgroundColor<<Warning>> #FFE66D
}

start

:OpenCore won't boot macOS;

if (Q: Does OpenCore boot picker show up?) then (no)
  
  partition "Boot Picker Not Showing" {
    :A: Check BIOS/UEFI Settings:\n- Disable Secure Boot\n- Set Boot Mode to UEFI\n- Disable Fast Boot\n- Set SATA Mode to AHCI;
    
    if (Q: Does boot picker show now?) then (yes)
      :Continue to next step; <<Success>>
    else (no)
      :A: Fix config.plist:\n- Set Misc > Boot > HideAuxiliary = false\n- Set Misc > Boot > Timeout = 5\n- Set Misc > Security > ScanPolicy = 0\n- Set Misc > Security > Vault = Optional;
      
      if (Q: Does boot picker show now?) then (yes)
        :Continue to next step; <<Success>>
      else (no)
        :USB creation issue!\nRecreate USB with proper structure; <<Failure>>
        stop
      endif
    endif
  }
  
else (yes)
  :Boot picker working; <<Success>>
endif

if (Q: Is macOS installer/drive visible in picker?) then (no)
  
  partition "Drive Not Visible" {
    if (Q: Are you trying to boot macOS 10.15 or older?) then (yes)
      :A: Fix APFS driver for older macOS:\n- Set UEFI > APFS > MinDate = -1\n- Set UEFI > APFS > MinVersion = -1\n- Ensure OpenRuntime.efi in Drivers;
      
      if (Q: Is drive visible now?) then (yes)
        :Continue; <<Success>>
      else (no)
        :A: Add HfsPlus.efi driver\nfor HFS+ support;
        
        if (Q: Visible now?) then (yes)
          :Continue; <<Success>>
        else (no)
          :Drive may be corrupted; <<Failure>>
          :A: Try reformatting or different USB port;
          stop
        endif
      endif
    else (no)
      :A: Check Drivers section for macOS 11+:\n- Ensure OpenRuntime.efi present and enabled\n- Add HfsPlus.efi or OpenHfsPlus.efi\n- Verify all .efi files are Enabled\n- Set Misc > Security > ScanPolicy = 0;
      
      if (Q: Visible now?) then (yes)
        :Continue; <<Success>>
      else (no)
        :Check USB creation or drive format; <<Failure>>
        stop
      endif
    endif
  }
  
else (yes)
  :Drive visible; <<Success>>
endif

:Select macOS to boot;

if (Q: What happens when you boot?) then (Kernel Panic)
  
  partition "Kernel Panic Troubleshooting" {
    :A: Check verbose boot output\n(boot-args: -v debug=0x100);
    
    if (Q: Error mentions "AppleIntelCPU"?) then (yes)
      :A: Fix CPU configuration:\n- Verify correct SMBIOS for your CPU\n- Check Kernel > Emulate settings\n- Ensure correct Quirks for platform;
    else (no)
      if (Q: Error mentions missing kexts?) then (yes)
        :A: Verify Kernel > Add section:\n- Lilu.kext first (if used)\n- VirtualSMC or FakeSMC\n- WhateverGreen (for graphics)\n- AppleALC (for audio)\n- Ensure all kexts are Enabled\n- Check kext load order;
      else (no)
        if (Q: Error mentions "SecureBoot"?) then (yes)
          :A: Disable SecureBootModel:\n- Set Misc > Security > SecureBootModel = Disabled\n- Set UEFI > Quirks > SecureBootModel = Disabled;
        else (no)
          :A: Common kernel panic fixes:\n- Set Kernel > Quirks > AppleXcpmCfgLock = true\n- Set Kernel > Quirks > DisableIoMapper = true\n- Check for conflicting kexts;
        endif
      endif
    endif
    
    if (Q: Does it boot now?) then (yes)
      :Success!; <<Success>>
      stop
    else (no)
      :Still panicking; <<Failure>>
    endif
  }
  
elseif (Stuck at Apple Logo) then
  
  partition "Apple Logo Hang" {
    :A: Enable verbose mode:\nAdd boot-args: -v in NVRAM section;
    
    :A: Check where it stops:\n- Look for last line in verbose output\n- Common stops: IOConsoleUsers, DSMOS, graphics init;
    
    if (Q: Stops at graphics-related line?) then (yes)
      :A: Fix graphics:\n- Verify DeviceProperties for iGPU/dGPU\n- Check WhateverGreen.kext is loaded\n- Add boot-arg: -igfxvesa (safe mode)\n- Verify SMBIOS matches your hardware;
    else (no)
      :A: Check ACPI patches:\n- Verify SSDT-PLUG for CPU PM\n- Check SSDT-EC for embedded controller\n- Ensure SSDTs are in correct order;
    endif
    
    if (Q: Does it boot now?) then (yes)
      :Success!; <<Success>>
      stop
    else (no)
      :Still stuck; <<Failure>>
    endif
  }
  
elseif (Black Screen) then
  
  partition "Black Screen Issues" {
    :A: Graphics configuration:\n- Check ig-platform-id (Intel iGPU)\n- Verify device-id if needed\n- Check WhateverGreen boot-args\n- Try boot-arg: -wegnoegpu (disable dGPU);
    
    if (Q: Does it boot now?) then (yes)
      :Success!; <<Success>>
      stop
    else (no)
      :Graphics issue persists; <<Failure>>
    endif
  }
  
else (Reboots/Restarts)
  
  partition "Reboot Loop" {
    :A: Check power management:\n- Verify SSDT-PLUG present\n- Set Kernel > Quirks > AppleCpuPmCfgLock = true\n- Check BIOS: Disable CFG Lock if possible;
    
    :A: USB mapping:\n- Use USBInjectAll.kext temporarily\n- Create proper USB map later\n- Check XHCI-unsupported.kext if needed;
    
    if (Q: Does it boot now?) then (yes)
      :Success!; <<Success>>
      stop
    else (no)
      :Still rebooting; <<Failure>>
    endif
  }
  
endif

partition "Final Troubleshooting Round" {
  note right
    **Systematic Config Check:**
    
    **ACPI Section:**
    • Add: All required SSDTs present and enabled?
    • Delete: No unnecessary deletions?
    • Patch: Appropriate renames if needed?
    
    **Booter Section:**
    • Quirks: Match your hardware (check guide)
    • ResizeAppleGpuBars: -1 for most systems
    
    **DeviceProperties:**
    • PciRoot(0x0)/Pci(0x2,0x0): iGPU properties
    • PciRoot(0x0)/Pci(0x1f,0x3): Audio properties
    
    **Kernel Section:**
    • Add: Correct load order (Lilu first)
    • Emulate: Set if needed for CPU
    • Quirks: Platform-specific settings
    
    **Misc Section:**
    • Boot: Timeout, ShowPicker enabled
    • Debug: AppleDebug, Target = 67
    • Security: SecureBootModel, Vault
    
    **NVRAM Section:**
    • boot-args: -v for debugging
    • csr-active-config: Usually 00000000
    • prev-lang:kbd: Language setting
    
    **PlatformInfo:**
    • Generic: Correct SMBIOS for hardware
    • UpdateDataHub, UpdateNVRAM, UpdateSMBIOS: YES
    
    **UEFI Section:**
    • Drivers: OpenRuntime, HfsPlus/OpenHfsPlus
    • APFS: MinDate/MinVersion = -1 ONLY for macOS 10.15 and older
    • Quirks: Platform-specific (check guide)
    • Output: Resolution, TextRenderer settings
  end note
  
  :A: Review checklist above\nand compare with OpenCore Install Guide;
  
  if (Q: Does it boot after fixes?) then (yes)
    :Success! Enjoy macOS!; <<Success>>
    stop
  else (no)
    :Advanced issues detected; <<Failure>>
    
    :A: Gather diagnostic info:\n- EFI folder contents\n- Verbose boot log (-v)\n- Hardware specifications\n- OpenCore version;
    
    :A: Seek community help:\n- r/hackintosh subreddit\n- OpenCore Discord\n- InsanelyMac forums\n- Attach diagnostic info;
    
    stop
  endif
}

@enduml
```