# Fixing Performance Issues After Wake from S3 Sleep Caused by Bi-Directional Processor Hot (BDPROCHOT)

## Introduction

This guide outlines a general fix for performance issues caused by the Bi-Directional Processor Hot (BDPROCHOT) signal on Hackintosh systems, particularly after waking from S3 sleep. The solution uses `DisablePROCHOT.efi` to disable BDPROCHOT at boot and `SimpleMSR.kext` to handle post-wake scenarios, ensuring stable CPU performance across various hardware configurations.

## What is BDPROCHOT?

**BDPROCHOT** (Bi-Directional Processor Hot) is a feature in Intel CPUs that allows the processor and other system components (e.g., GPU, voltage regulators, or thermal sensors) to signal an overheating condition. When activated, it forces the CPU to reduce its frequency and voltage to lower power consumption and heat output, protecting the system from thermal damage.

### Key Aspects

- **Bi-Directional Nature**:
  - **CPU to System**: The CPU triggers BDPROCHOT if its internal thermal sensors detect temperatures exceeding safe thresholds (typically ~95-100°C).
  - **System to CPU**: External components, such as the GPU, Embedded Controller (EC), or Voltage Regulator Modules (VRMs), can assert BDPROCHOT to throttle the CPU, even if the CPU is not overheating.
- **Mechanism**:
  - When active, BDPROCHOT reduces CPU clock speeds to a minimum (e.g., 400-800 MHz) and lowers voltage, significantly impacting performance.
  - It is managed through the Model-Specific Register (MSR) `IA32_THERM_STATUS` and can be influenced by firmware (BIOS/UEFI), ACPI, or software.
- **Purpose**: Protects hardware by preventing thermal runaway in high-load scenarios or when cooling is insufficient (e.g., clogged heatsinks or high ambient temperatures).
- **Hackintosh Context**: BDPROCHOT can be triggered erroneously due to:
  - Incompatible or misconfigured kexts (e.g., YogaSMC, CPUFriend).
  - Incorrect ACPI tables or power management settings in OpenCore.
  - Firmware bugs, such as Lenovo’s Dynamic Platform and Thermal Framework (DPTF), misinterpreting thermal states.

## Symptoms

In Hackintosh systems, particularly on laptops like the [Lenovo T490](https://github.com/5T33Z0/Thinkpad-T490-Hackintosh-OpenCore/issues/44), BDPROCHOT can be triggered inappropriately due to firmware, power management, or kext-related issues, leading to significant performance degradation, especially after waking from S3 sleep. This results in the laptop becoming super-sluggish and unresponsive. You can verify this behavior by:

- **Checking CPU Frequency**: Use Intel Power Gadget to monitor CPU frequency. If BDPROCHOT is active, the CPU frequency will be locked at or near the base frequency (e.g., 400-800 MHz).
- **YogaSMC Profile Switching**: If using YogaSMC, the mode may switch to "Lap" after waking, indicating a low-power state triggered by BDPROCHOT to reduce heat dissipation.
- **General Symptoms**:
  - Sluggish performance post-wake, with slow application launches and lagging multitasking.
  - Unnecessary throttling despite safe CPU temperatures (e.g., 50-70°C), as shown in tools like HWMonitor.
  - Inconsistent power management, with kexts like YogaSMC or CPUFriend conflicting with macOS’s native power management (XCPM).

## Solution

To address BDPROCHOT-related performance issues, disable BDPROCHOT at boot using [**DisablePROCHOT.efi**](https://github.com/arter97/DisablePROCHOT) and prevent it from activating post-wake with [**SimpleMSR.kext**](https://github.com/arter97/SimpleMSR).

### Instructions

1. **Download Required Files**:
   - Obtain the latest `DisablePROCHOT.efi` from [arter97/DisablePROCHOT](https://github.com/arter97/DisablePROCHOT).
   - Obtain the latest `SimpleMSR.kext` from [arter97/SimpleMSR](https://github.com/arter97/SimpleMSR/releases), ensuring compatibility with your macOS version (e.g., Ventura, Sonoma, or Sequoia).

2. **Add Files to OpenCore Configuration**:
   - **Mount the EFI Partition**:
   - **Add `DisablePROCHOT.efi`**:
     - Copy `DisablePROCHOT.efi` to the `EFI/OC/Drivers` directory in your EFI partition.
     - Open your `config.plist` using ProperTree or OpenCore Configurator.
     - Add an entry under `UEFI > Drivers`:
       ```xml
       <dict>
           <key>Arch</key>
           <string>Any</string>
           <key>Comment</key>
           <string>Disable BDPROCHOT at boot</string>
           <key>Enabled</key>
           <true/>
           <key>Path</key>
           <string>DisablePROCHOT.efi</string>
       </dict>
       ```
   - **Add `SimpleMSR.kext`**:
     - Copy `SimpleMSR.kext` to the `EFI/OC/Kexts` directory in your EFI partition.
     - Add an entry in `config.plist` under `Kernel > Add`:
       ```xml
       <dict>
           <key>Arch</key>
           <string>Any</string>
           <key>BundlePath</key>
           <string>SimpleMSR.kext</string>
           <key>Comment</key>
           <string>Disable BDPROCHOT after wake</string>
           <key>Enabled</key>
           <true/>
           <key>ExecutablePath</key>
           <string>Contents/MacOS/SimpleMSR</string>
           <key>MinKernel</key>
           <string>19.0.0</string>
           <key>PlistPath</key>
           <string>Contents/Info.plist</string>
       </dict>
       ```
   - Save the `config.plist`.

3. **Reboot and Reset NVRAM**:
   - Ensure all changes to the EFI partition and `config.plist` are saved.
   - Reboot your system.
   - At the OpenCore picker, select the `ResetNvramEntry.efi` option to clear NVRAM, or press `Space` to access the NVRAM reset option if configured.
   - Boot into macOS.

4. **Rebuild Kext Cache**:
   - Once macOS boots, rebuild the kext cache to ensure `SimpleMSR.kext` is loaded:
     ```bash
     sudo kextcache -i /
     ```
   - Reboot again to apply the kext cache changes.

5. **Verify the Fix**:
   - **Monitor CPU Performance**:
     - Use Intel Power Gadget, HWMonitor, or i7z to confirm CPU frequencies remain stable after waking from S3 sleep.
     - Ensure the CPU does not drop to abnormally low frequencies (e.g., 400-800 MHz).
   - **Check BDPROCHOT Status**:
     - Use `sysctl machdep.xcpm` or a custom script to verify BDPROCHOT is disabled.
     - If dual-booting Windows, use ThrottleStop to confirm BDPROCHOT is off.
   - **Test Sleep/Wake Cycle**:
     - Put the system to sleep (S3) and wake it multiple times to ensure consistent performance.

## Additional Notes

- **Thermal Monitoring**: Disabling BDPROCHOT may increase CPU temperatures. Use HWMonitor or similar tools to ensure temperatures stay within safe limits (e.g., below 85°C under load). Clean cooling systems or adjust fan curves if necessary.
- **Compatibility**: This solution is compatible with most Intel-based Hackintosh systems. For AMD systems, additional research may be needed, as BDPROCHOT behavior differs.
- **Backup EFI**: Always back up your EFI folder before making changes to avoid boot issues.
- **Alternative Tools**: If `SimpleMSR.kext` is incompatible with your macOS version, consider using `one-key-cpufriend` to generate a custom `CPUFriendDataProvider.kext` to disable BDPROCHOT.
- **Community Resources**: Refer to forums like tonymacx86, Reddit’s r/hackintosh, or the EliteMacx86 forum for additional troubleshooting and model-specific advice.

## Conclusion

By adding `DisablePROCHOT.efi` and `SimpleMSR.kext` in a single configuration step, followed by rebooting and resetting NVRAM, Hackintosh systems can maintain stable CPU performance after S3 sleep. This lightweight and broadly compatible solution addresses BDPROCHOT-related throttling across various hardware configurations.

