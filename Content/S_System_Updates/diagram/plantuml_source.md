```
@startuml

start
:Enable OTA Updates;

if (Using root patches?) then (Yes)
  :Root-patched Hackintosh;
  :Apply Board-ID check skip;
  :Set SecureBootModel = Disabled;
  :Install RestrictEvents.kext + revpatch=sbvmm boot arg;
  :Apply OCLP root patches if needed;
  :Run OTA Update;
  :Update succeeds with Secure Boot disabled;
  note right
    iBridged not applicable
    Board-ID skip required
  end note
  stop

else (No)
  :Vanilla Hackintosh;

  if (SMBIOS supported by macOS?) then (Yes)
    :Set SecureBootModel = Default;
    :Install iBridged.kext;
    :Run OTA Update;
    :Update succeeds with Secure Boot enabled;
    stop

  else (No)
    :Unsupported SMBIOS;

    if (Native SMBIOS is T2-era\nand matches CPU family?) then (Yes)
      :Keep native SMBIOS;
      :Apply Board-ID check skip;
      :Spoof SecureBootModel to a Tahoe-compatible model;
      :Install iBridged.kext;
      :Keep SIP enabled (csr-active-config = 00000000);
      :Run OTA Update;
      :Incremental OTA updates work;
      note right
        Alternative configuration
        Tested on ThinkPad T490
      end note
      stop

   else (No)
      :Set SecureBootModel = Disabled or x86legacy;
      :Install RestrictEvents.kext + revpatch=sbvmm boot arg;
      :Apply Board-ID check skip;
      :Run OTA Update;
      :Update succeeds via RestrictEvents workaround;
      stop
    endif
  endif
endif
@enduml
```
