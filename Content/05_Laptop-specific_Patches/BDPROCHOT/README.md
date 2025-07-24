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

### ⚠️ Disclaimer: You Are Disabling a Safety Feature ⚠️

> [!CAUTION]
>
> Disabling **BDPROCHOT** removes a critical hardware protection mechanism designed to prevent your CPU and other components from overheating.
>
> Proceed **only if** you are certain that your system's throttling is caused by incorrect sensor readings or firmware bugs, not by actual overheating. By following this guide, you accept full responsibility for any potential hardware damage.
>
> **Potential Risks:**
> 
> * Permanently reduced hardware lifespan due to higher operating temperatures.
> * System instability, crashes, or data loss.
> * In a worst-case scenario, permanent damage to your CPU or motherboard.
>
> **You must actively monitor your system temperatures after applying this fix.** You proceed at your own risk.

### Instructions

1. **Download Required Files**:
   - Obtain the latest `DisablePROCHOT.efi` from [arter97/DisablePROCHOT](https://github.com/arter97/DisablePROCHOT).
   - Obtain the latest `SimpleMSR.kext` from [arter97/SimpleMSR](https://github.com/arter97/SimpleMSR/releases), ensuring compatibility with your macOS version (e.g., Ventura, Sonoma, or Sequoia).

2. **Add Files to OpenCore Configuration**:
   - **Mount the EFI Partition**:
   - **Add `DisablePROCHOT.efi`**:
     - Copy `DisablePROCHOT.efi` to the `EFI/OC/Drivers` directory in your EFI partition.
     - Open your `config.plist` using ProperTree
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

4. Verify that the `SimpleMSR.kext` is loaded
  
    ```
    kextstat | grep -v com.apple
    ```
    This lists all the loaded 3rd party kexts (not authored by Apple). It should contain something like this:
    ```
    73 0 0xffffff800430f000 0x9000 0x9000 com.arter97.SimpleMSR (1) 6D9F78A6-6865-342F-8C87-A58A52B90B52 <6 3>
    ```

5. **Verify the Fix**:
   - **Monitor CPU Performance**:
     - Use Intel Power Gadget, HWMonitor, or iStat Menus to confirm CPU frequencies remain stable after waking from S3 sleep.
     - Ensure the CPU does not drop to abnormally low frequencies (e.g., 400-800 MHz).
   - **Test Sleep/Wake Cycle**:
     - Put the system to sleep (S3) and wake it multiple times to ensure consistent performance.

## Using VoltageShift instead of SimpleMSR

If `SimpleMSR.kext` doesn't resolve the issue after waking, **VoltageShift** offers a more direct way to control the MSR register responsible for BDPROCHOT.

### 1. Prepare VoltageShift

*   Download the latest version from the official [VoltageShift repository](https://github.com/sicreative/VoltageShift).
*   Add `VoltageShift.kext` to your `EFI/OC/Kexts` folder and your `config.plist`.
*   **Disable or remove `SimpleMSR.kext`** from your `config.plist` to avoid conflicts.
*   Reboot your system.

### 2. Find and Modify the BDPROCHOT Value

*   Open Terminal and navigate to the extracted VoltageShift folder. For example:
    ```bash
    cd ~/Downloads/voltageshift
    ```
*   Read the current value of the `MSR_POWER_CTL` register (`0x1fc`), which controls BDPROCHOT:
    ```bash
    ./voltageshift read 0x1fc
    ```
* This command will output a long binary string. For example: `000101000000000000011011`. The setting that enables or disables BDPROCHOT is the very first bit (bit 0), which is the **rightmost digit** in the binary string:

	*   If the last digit is **`1`**, BDPROCHOT is **enabled**.
	*   If the last digit is **`0`**, BDPROCHOT is **disabled**.

* In this example, BDPROCHOT is enabled because the first bit is set to `1`. To disable it, you simply change the last digit from `1` to `0`:

 	*   **Original Binary:** `000101000000000000011011`
	*   **Modified Binary:** `000101000000000000011010` (notice the last digit changed)

* Next, you must convert this modified binary string into a **hexadecimal** value, as the `write` command requires hex. You can use Hackintool or the Calculator app (View > Programmer) to do so. In this example, the original value `0x14001B` becomes `0x14001A` after flipping the first bit by subtracting one from the original value.

### 3. Disable BDPROCHOT Manually

Write the new, modified value back to the MSR:

```bash
# Use your modified value here. This is just an example.
./voltageshift write 0x1fc 0x14001A
```
Your CPU should immediately return to full speed. Verify this with Intel Power Gadget.

### 4. Automate the Fix After Wake

This setting resets every time the system sleeps. To automate it, you can use a tool like [Hammerspoon](https://www.hammerspoon.org/).

*   Install Hammerspoon and add the following Lua script to your configuration (located at `~/.hammerspoon/init.lua`):
    ```lua
    -- Automate disabling BDPROCHOT after system wake
    local wakeWatcher = hs.caffeinate.watcher.new(function(event)
        if event == hs.caffeinate.watcher.systemDidWake then
            -- IMPORTANT: Update the path and value to match your system
            hs.execute("/path/to/your/voltageshift write 0x1fc YOUR_MODIFIED_HEX_VALUE")
        end
    end)

    wakeWatcher:start()
    ```
*   **Remember to replace** `/path/to/your/voltageshift` and `YOUR_MODIFIED_HEX_VALUE` with your actual file path and the hex value you calculated.
*   Reload your Hammerspoon configuration to apply the script.

## Final Notes

- **Thermal Monitoring**: Disabling BDPROCHOT may increase CPU temperatures. Use HWMonitor or similar tools to ensure temperatures stay within safe limits (e.g., below 85°C under load). Clean cooling systems or adjust fan curves if necessary.
- **Compatibility**: This solution is compatible with most Intel-based Hackintosh systems. For AMD systems, additional research may be needed, as BDPROCHOT behavior differs.
- **Backup EFI**: Always back up your EFI folder before making changes to avoid boot issues.

## Conclusion

By adding `DisablePROCHOT.efi` and `SimpleMSR.kext` in a single configuration step, followed by rebooting and resetting NVRAM, Hackintosh systems can maintain stable CPU performance after S3 sleep. This lightweight and broadly compatible solution for Intel-based Systems addresses BDPROCHOT-related throttling across various hardware configurations.

## Credits and Thanks
- [arter97](https://github.com/arter97) for DisablePROCHOT and SimpleMSR
- [sicreative](https://github.com/sicreative) for VoltageShift
- [medkintos](https://github.com/medkintos) for the research and instructions
