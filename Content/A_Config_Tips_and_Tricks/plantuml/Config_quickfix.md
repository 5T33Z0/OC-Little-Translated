Config troubleshooting

```
@startuml
title OpenCore Troubleshooting Workflow (OC 073+)

skinparam activity {
  BackgroundColor<<Success>> #98D8C8
  BackgroundColor<<Failure>> #FF6B6B
}

start
:hackNoBoot!?;
if (Q: macOS disk visible in Boot Picker?) then (no)
  
  if (Q: Are you using macOS older than macOS 11?) then (yes)
    :A: Set UEFI > APFS >\nMinDate and MinVersion to -1;
    
    if (Q: Do you see it now?) then (yes)
      if (Q: Does it boot?) then (yes)
        :Yay!; <<Success>>
        stop
      else (no)
        :Nah!; <<Failure>>
      endif
    else (no)
      :Nah!; <<Failure>>
    endif
  else (no)
  endif
  
  partition "1st Round" {
    :A: Fix UEFI > Drivers section\n(compare with current Sample.plist);
    
    if (Q: Does it boot?) then (yes)
      :Yay!; <<Success>>
      stop
    else (no)
      :Nah!; <<Failure>>
    endif
  }
  
else (yes)
  
  :A: Set SecureBootModel to Disabled,\nset Vault to Optional;
  
  if (Q: Does it boot?) then (yes)
    :Yay!; <<Success>>
    stop
  else (no)
    :Nah!; <<Failure>>
  endif
  
endif
partition "2nd Round - Detailed Check" {
  note right
    **A: Refer to the OpenCore Install Guide**
    **Check the following Settings for your CPU Family:**
    
    • ACPI > All required .aml Files present/enabled?
    • Booter > Quirks set according to guide?
    • DeviceProperties: Correct Framebuffer Patch, etc.?
    • Kernel > Add: All necessary Kexts in correct Order?
    • Kernel > Quirks: All necessary Quirks set?
    • Misc > Security: Set: ScanPolicy = 0,
      SecureBootModel = Disabled, Vault= Optional
    • SMBIOS: check Platforminfo > Generic:
      Correct SystemProductName set?
    • UEFI: ConnectDrivers: YES
    • UEFI > APFS: (Set MinDate: -1, MinVersion: -1)
    • UEFI > Drivers > New structure applied already?
      (Compare with Sample.plist)
  end note
  
  :A: Apply fixes from checklist on the right;
  
  if (Q: Does it boot now?) then (yes)
    :Yay!; <<Success>>
    stop
  else (no)
    :Nah!; <<Failure>>
    :A: Seek Help!;
    stop
  endif
}
@enduml
```
