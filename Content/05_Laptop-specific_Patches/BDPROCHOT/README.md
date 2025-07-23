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

## Solution: Disabling BDPROCHOT

To address BDPROCHOT-related performance issues, disable BDPROCHOT at boot using [**DisablePROCHOT.efi**](https://github.com/arter97/DisablePROCHOT) and prevent it from activating post-wake with [**SimpleMSR.kext**](https://github.com/arter97/SimpleMSR).

### ⚠️ Disclaimer

Disabling **BDPROCHOT (Bi-Directional Processor Hot)** bypasses a built-in safety feature designed to protect your CPU from overheating and power-related issues. This modification can increase system performance in Hackintosh environments, but it also **removes a critical hardware safeguard**.

Proceed **only** if:

* Your cooling system is functioning reliably.
* You have verified that BDPROCHOT is being triggered incorrectly (e.g., by faulty firmware or sensors).
* You understand the risks involved.

Potential consequences include:

* Increased CPU temperatures under load
* Reduced hardware lifespan
* System instability or crashes

Use monitoring tools (e.g., Intel Power Gadget, HWMonitorSMC2, iStat Menus) to regularly check temperatures and system behavior. **You proceed at your own risk.**

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

3. **Rebuild Kext Cache**:
   - Once macOS boots, rebuild the kext cache to ensure `SimpleMSR.kext` is loaded:
     ```bash
     sudo kextcache -i /
     ```
   - Reboot again to apply the kext cache changes.

4. **Reboot and Reset NVRAM**:
   - Ensure all changes to the EFI partition and `config.plist` are saved.
   - Reboot your system.
   - At the OpenCore picker, select the `ResetNvramEntry.efi` option to clear NVRAM, or press `Space` to access the NVRAM reset option if configured.
   - Boot into macOS.

5. **Verify the Fix**:
   - **Monitor CPU Performance**:
     - Use Intel Power Gadget, HWMonitor, or i7z to confirm CPU frequencies remain stable after waking from S3 sleep.
     - Ensure the CPU does not drop to abnormally low frequencies (e.g., 400-800 MHz).
   - **Check BDPROCHOT Status**:
     - Use `sysctl machdep.xcpm` or a custom script to verify BDPROCHOT is disabled.
     - If dual-booting Windows, use ThrottleStop to confirm BDPROCHOT is off.
   - **Test Sleep/Wake Cycle**:
     - Put the system to sleep (S3) and wake it multiple times to ensure consistent performance.

## Using VoltageShift instead of SimpleMSR

If you have still witness BDPROCHOT kicking in after waking from sleep, consider using [**VoltageShift**](https://github.com/sicreative/VoltageShift) instead of `SimpleMSR.kext` to disable BDPROCHOT.

### Configuring VoltageShift

- Download the [zip](https://github.com/sicreative/VoltageShift/blob/master/voltageshift_1.25.zip) and extract it
- Add the VoltageShift.kext to EFI/OC/Kexts and your `config.plist`
- Disable `SimpleMSR.kext`, if present
- Reboot macOS
- Run the VolatgeShift CLI tool: 
	```bash
	~/Downloads/voltageshift_1.25/./voltageshift read 0x1fc
	```
- This will return a bit sequence, for example: `000101000000000000011011`
- Change the last bit in the Sequence to 0: `000101000000000000011010`
- Convert the value to Hex, here: 14001A
- Write the Value to MSR:
	```bash
	~/Downloads/voltageshift_1.25/./voltageshift write 0x1fc 14001A
	```
- Automate writing this value after recovering from sleep with an automation tool like [Hammerspoon](https://www.hammerspoon.org/) using a lua script:

	```lua
	local wakeWatcher = hs.caffeinate.watcher.new(function(event)
	    if event == hs.caffeinate.watcher.systemDidWake then
	        hs.execute("~/Downloads/voltageshift_1.25/./voltageshift write 0x1fc 14001A")
	    end
	end)

	wakeWatcher:start()
	```

## Additional Notes

- **Thermal Monitoring**: Disabling BDPROCHOT may increase CPU temperatures. Use HWMonitor or similar tools to ensure temperatures stay within safe limits (e.g., below 85°C under load). Clean cooling systems or adjust fan curves if necessary.
- **Compatibility**: This solution is compatible with most Intel-based Hackintosh systems. For AMD systems, additional research may be needed, as BDPROCHOT behavior differs.
- **Backup EFI**: Always back up your EFI folder before making changes to avoid boot issues.

## Conclusion

By adding `DisablePROCHOT.efi` and `SimpleMSR.kext` in a single configuration step, followed by rebooting and resetting NVRAM, Hackintosh systems can maintain stable CPU performance after S3 sleep. This lightweight and broadly compatible solution addresses BDPROCHOT-related throttling across various hardware configurations.

