# Fixing Performance Issues After Wake from S3 Sleep Caused by Bi-Directional Processor Hot (BDPROCHOT)

## Introduction

This guide outlines a general fix for performance issues caused by the Bi-Directional Processor Hot (BDPROCHOT) signal on Hackintosh systems, particularly after waking from S3 sleep. The solution uses `DisablePROCHOT.efi` to disable BDPROCHOT at boot and `SimpleMSR.kext` to handle post-wake scenarios, ensuring stable CPU performance across various hardware configurations.

> [!NOTE]
> 
> **For Lenovo ThinkPad Users:**  
> On ThinkPads (such as the T480, T490, and X1 Carbon series), BD-PROCHOT is frequently conflated with **DYTC Lap Mode (Cool-on-Lap)**. While BD-PROCHOT locks CPU clock speeds to **400–800 MHz**, Lap Mode caps the power limit (PL1) to **11W–15W**. See [BD-PROCHOT vs. DYTC Lapmode](#bd-prochot-vs-dytc-lapmode) below for details.

---

## What is BDPROCHOT?

**BDPROCHOT** (Bi-Directional Processor Hot) is a feature in Intel CPUs that allows the processor and other system components (e.g., GPU, voltage regulators, or thermal sensors) to signal an overheating condition. When activated, it forces the CPU to reduce its frequency and voltage to lower power consumption and heat output, protecting the system from thermal damage.

### Key Aspects

- **Bi-Directional Nature**:
  - **CPU to System**: The CPU triggers BDPROCHOT if its internal thermal sensors detect temperatures exceeding safe thresholds (typically ~95–100°C).
  - **System to CPU**: External components, such as the GPU, Embedded Controller (EC), or Voltage Regulator Modules (VRMs), can assert BDPROCHOT to throttle the CPU, even if the CPU itself is not overheating.
- **Mechanism**:
  - When active, BDPROCHOT forces CPU clock speeds to their lowest multiplier (e.g., 400–800 MHz) and drops voltage, drastically degrading system responsiveness.
  - It is managed through the Model-Specific Register (MSR) `0x1FC` (`MSR_POWER_CTL`) and can be influenced by firmware (BIOS/UEFI), ACPI, or power delivery spikes.
- **Purpose**: Protects hardware by preventing thermal runaway in high-load scenarios or when cooling is insufficient (e.g., clogged heatsinks or high ambient temperatures).
- **Hackintosh Context**: BDPROCHOT can be triggered erroneously due to:
  - Misbehaving Embedded Controller (EC) firmware asserting the signal after waking from S3 sleep.
  - Power fluctuations from third-party or lower-wattage USB-C chargers.
  - Firmware bugs, such as Lenovo’s Dynamic Platform and Thermal Framework (DPTF), misinterpreting system states.

---

## Symptoms

In Hackintosh systems, particularly on laptops like the [Lenovo T490](https://github.com/5T33Z0/Thinkpad-T490-Hackintosh-OpenCore/issues/44), BDPROCHOT can misfire after waking from S3 sleep, causing severe performance degradation and making the machine sluggish and unresponsive. You can verify this behavior by:

- **Checking CPU Frequency**: Use [**Intel Power Gadget**](https://intel-power-gadget.macupdate.com/) or **HWMonitor** to monitor CPU core frequencies. If BDPROCHOT is active, CPU clocks will be **permanently locked at 400 MHz – 800 MHz** regardless of system load.
- **General Symptoms**:
  - Severe UI lag and stutter post-wake.
  - Applications taking exceptionally long to launch.
  - Throttling occurs despite low, safe CPU temperatures (e.g., 40°C–60°C).

### BD-PROCHOT vs. DYTC Lapmode

It is critical not to confuse **BD-PROCHOT** with **Lenovo DYTC Lapmode (Cool-on-Lap)**:

| Feature | Layer | Mechanism | Symptom | Fix |
| :--- | :--- | :--- | :--- | :--- |
| **BD-PROCHOT** | MSR (`0x1FC`) | Hardware/EC signal | CPU frequency is **hard-locked to 400–800 MHz** (often after S3 sleep). | `DisablePROCHOT.efi` + `SimpleMSR.kext` *(This Guide)* |
| **DYTC Lapmode** | ACPI (`HKEY.DYTC`) | Accelerometer motion sensor | CPU can still boost, but TDP (PL1) is **capped to 11W–15W** when moved off-desk. | [**`SSDT-NO-LAP`**](/Content/05_Laptop-specific_Patches/ThinkPad_Disable_Lapmode/README.md) |

> [!TIP]
> 
> If your CPU boosts to normal frequencies but quickly throttles power down to ~15W when moving or using the laptop off-desk (especially under Linux or Windows), refer to this companion guide:  
> 👉 [**Disabling ThinkPad `DYTC` Lapmode (Cool-on-Lap) Throttling**](/Content/05_Laptop-specific_Patches/ThinkPad_Disable_Lapmode/README.md)

---

## Solution: Disabling BDPROCHOT

To address BDPROCHOT-related performance issues, disable BDPROCHOT at boot using [**DisablePROCHOT.efi**](https://github.com/arter97/DisablePROCHOT) and prevent it from reactivating post-wake using [**SimpleMSR.kext**](https://github.com/arter97/SimpleMSR).

### ⚠️ Disclaimer: You Are Disabling a Safety Feature ⚠️

> [!CAUTION]
> 
> Disabling **BDPROCHOT** removes an external hardware protection mechanism designed to allow the power supply, VRMs, or EC to throttle your CPU.
>
> Proceed **only if** you are certain that your system's throttling is caused by incorrect sensor readings or firmware bugs, not by actual overheating. By following this guide, you accept full responsibility for any potential hardware damage.
>
> **Potential Risks:**
> * Permanently reduced hardware lifespan due to higher operating temperatures.
> * System instability, crashes, or data loss.
> * In worst-case scenarios, permanent damage to your CPU or motherboard.
>
> **Note:** Disabling BD-PROCHOT does **not** disable internal CPU thermal limits (TJMax / core thermal shutdown routines). The silicon will still protect itself from dangerous core temperatures. However, you must actively monitor system temperatures after applying this fix. You proceed at your own risk.

---

### Instructions

1. **Download Required Files**:
   - Obtain the latest `DisablePROCHOT.efi` from [arter97/DisablePROCHOT](https://github.com/arter97/DisablePROCHOT).
   - Obtain the latest `SimpleMSR.kext` from [arter97/SimpleMSR](https://github.com/arter97/SimpleMSR/releases).

2. **Add Files to OpenCore Configuration**:
   - **Mount your EFI Partition**.
   - **Add `DisablePROCHOT.efi`**:
     - Copy `DisablePROCHOT.efi` to the `EFI/OC/Drivers/` directory.
     - Open your `config.plist` using **ProperTree**.
     - Add an entry under `UEFI -> Drivers`:
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
     - Copy `SimpleMSR.kext` to the `EFI/OC/Kexts/` directory.
     - Add an entry in `config.plist` under `Kernel -> Add` (or run **OC Snapshot** via `Cmd + R`):
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
   - Reboot your system.
   - At the OpenCore picker, trigger **Reset NVRAM** once.
   - Boot into macOS.

4. **Verify `SimpleMSR.kext` is Loaded**:
   Run in Terminal:
   ```bash
   kextstat | grep -v com.apple | grep -i SimpleMSR
   ```
   It should return a matching line confirming the kext is active:
   ```text
   73 0 0xffffff800430f000 0x9000 0x9000 com.arter97.SimpleMSR (1) ... <6 3>
   ```

5. **Verify the Fix**:
   - **Monitor CPU Performance:** Open Intel Power Gadget, HWMonitor, or iStat Menus.
   - **Test Sleep/Wake Cycles:** Put the machine to sleep (S3) and wake it multiple times. Confirm that CPU frequencies immediately ramp up under load and do **not** lock to 400–800 MHz.

---

## Alternative: Using VoltageShift instead of SimpleMSR

If `SimpleMSR.kext` is incompatible or doesn't clear the register after waking on your specific setup, **VoltageShift** offers a manual scripting method to write directly to MSR `0x1FC`.

### 1. Prepare VoltageShift
* Download the latest release from the [VoltageShift repository](https://github.com/sicreative/VoltageShift).
* Add `VoltageShift.kext` to `EFI/OC/Kexts/` and your `config.plist`.
* **Disable or remove `SimpleMSR.kext`** from your `config.plist` to avoid conflicting writes.
* Reboot your system.

### 2. Find and Modify the BDPROCHOT Value
* Open Terminal and navigate to the extracted VoltageShift folder:
  ```bash
  cd ~/Downloads/voltageshift
  ```
* Read the current value of the `MSR_POWER_CTL` register (`0x1FC`):
  ```bash
  ./voltageshift read 0x1fc
  ```
* The command outputs a binary string (e.g., `000101000000000000011011`). The bit that controls BDPROCHOT is **Bit 0** (the **rightmost digit**):
  * **`1`** = BDPROCHOT is **enabled**.
  * **`0`** = BDPROCHOT is **disabled**.
* To disable it, flip the last digit from `1` to `0`:
  * **Original Binary:** `000101000000000000011011` (`0x14001B`)
  * **Modified Binary:** `000101000000000000011010` (`0x14001A`)

### 3. Write the Value Manually
Write the modified hex value back to the MSR:
```bash
./voltageshift write 0x1fc 0x14001A
```
The CPU should immediately return to full clock speeds.

### 4. Automate the Fix After Wake via Hammerspoon
Because MSR registers reset after S3 sleep, automate the write using [Hammerspoon](https://www.hammerspoon.org/):

* Add the following Lua script to `~/.hammerspoon/init.lua`:
  ```lua
  -- Automate disabling BDPROCHOT after system wake
  local wakeWatcher = hs.caffeinate.watcher.new(function(event)
      if event == hs.caffeinate.watcher.systemDidWake then
          -- Update the path and hex value to match your system
          hs.execute("/path/to/voltageshift write 0x1fc YOUR_MODIFIED_HEX_VALUE")
      end
  end)

  wakeWatcher:start()
  ```
* Reload your Hammerspoon configuration.

---

## Final Notes

- **Thermal Monitoring**: Disabling BDPROCHOT may lead to higher sustained temperatures under load. Monitor temperatures to ensure they stay within acceptable limits (e.g., below 85°C–90°C during heavy tasks).
- **The Complete ThinkPad Solution**: On modern Lenovo ThinkPads, solving BD-PROCHOT fixes the clock lock bug. To also resolve the 15W motion-triggered power ceiling when dual-booting Linux or Windows, pair this fix with [**`SSDT-NO-LAP`**](/Content/05_Laptop-specific_Patches/ThinkPad_Disable_Lapmode/README.md).
- **Backup EFI**: Always back up your working EFI folder before adding new drivers or kexts.

---

## Conclusion

Combining `DisablePROCHOT.efi` (at boot) with `SimpleMSR.kext` (post-wake) provides a clean, permanent solution to the notorious 400–800 MHz hardware clock clamp on Intel-based Hackintoshes. When paired with `SSDT-NO-LAP` on ThinkPads, all layers of artificial throttling are comprehensively resolved.

---

## Credits and Thanks
- [arter97](https://github.com/arter97) for DisablePROCHOT and SimpleMSR
- [sicreative](https://github.com/sicreative) for VoltageShift
- [medkintos](https://github.com/medkintos) for initial research on Issue #44
