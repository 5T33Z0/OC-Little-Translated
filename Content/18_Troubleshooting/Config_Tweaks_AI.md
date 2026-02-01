# Utilizing AI for Config Analysis and Optimization

## Preface

One question kept coming up while working with OpenCore: how can I tell whether a given configuration is actually *optimal* for a specific system? The Dortania Guide is an excellent resource, but it is intentionally generic. Its purpose is to get systems from various CPU families to boot reliably, not to provide a finely tuned, system-specific configuration.

Once a system is already booting, optimization becomes less straightforward. Trying every possible combination of quirks would be unreasonable, and toggling them one by one with repeated reboots is neither efficient nor particularly insightful. What is needed instead is a more methodical and evidence-based approach.

Such an approach exists in the form of the OpenCore **DEBUG** boot log. Compared to the RELEASE build, it provides significantly more detail about memory handling, MMIO regions, slide calculation, and which workarounds are actually applied during boot. The problem is scale: a typical debug log contains 500–800 lines of highly technical output that many users struggle to interpret meaningfully.

This is where AI becomes useful. It excels at processing large amounts of structured text and identifying patterns and logical relationships. By feeding debug boot logs into an AI model and asking targeted questions, it becomes possible to reason about which quirks are actively used and which are effectively redundant.

Applying this approach to one system allowed me to safely disable several quirks – such as `ProvideCustomSlide`, `EnableSafeModeSlide`, `RebuildAppleMemoryMap`, and `DevirtualiseMmio` (long with MMIO Whitelist entries), without affecting stability. On another system, the LLM identified that the CPU and amount of cores was not detected correctly. After enabling `ProvideCrrentCPpuInfo` this issue was resolved.

Here's a real-life example of [discussing the OC debug bootlog with ChatGPT](https://chatgpt.com/share/697c8d54-1138-8012-a15c-f5af08bcef2c). 

## Scope & Assumptions

This guide is intended for **systems that are already booting macOS successfully** under OpenCore. It focuses exclusively on **analyzing and optimizing configuration settings** (quirks, MMIO entries, debug options) to remove unnecessary workarounds and streamline the boot process.

**Key Assumptions:**

1. The system already boots macOS reliably under OpenCore (desktop or laptop).
2. Users can access and edit the EFI partition (`config.plist`) and restore a backup if needed.
3. Users can perform basic validation tests: cold boots, warm reboots, sleep/wake cycles, and NVRAM resets.
4. AI-assisted analysis complements – but does not replace – user judgment. Any recommendations should be validated **_individually_**.

**Limitations:**

* This guide does **not** cover initial OpenCore setup, hardware troubleshooting, or macOS installation.
* Boot logs reflect a single boot scenario; a quirk that appears unused may still be required in other scenarios.

## General Procedure

Switch to the OpenCore **DEBUG** build → generate a debug boot log → have an LLM analyze the log → address issues or adjust configuration settings **one change at a time** → reboot → analyze the next boot log.
Repeat this process until no further issues or optimization opportunities remain.

## Preparations: Enabling Debug Logging

The fastest way to switch from the **RELEASE** to the **DEBUG** version of OpenCore is by using [OCAT (OpenCore Auxiliary Tools)](https://github.com/ic005k/OCAuxiliaryTools).

### 1. Back up your EFI folder

* Launch OCAT
* Mount your ESP (EFI System Partition) and open `config.plist`
* Copy the entire `EFI` folder to the root of a FAT32-formatted USB flash drive

This USB drive serves as a fallback boot medium in case something goes wrong.

### 2. Switch to the Debug version of OpenCore and enable logging

* In OCAT, select **Edit → OpenCore DEBUG** from the menu bar (enable the checkmark)
* Navigate to `Misc → Debug`
  * Enable `AppleDebug`
  * Enable `ApplePanic`
  * Set `Misc/Debug/Target` to `67`
* Click **Upgrade OpenCore and kexts**
* In the next dialog:
  * Select **Get OpenCore**
  * Once the files are downloaded, click **Start Sync**
* Save `config.plist` and reboot

### 3. Retrieve the boot log

* Launch OCAT again
* Mount your ESP
* Navigate to `EFI/`

The debug boot log will be stored as a text file using the following naming scheme:

```
opencore-YYYY-MM-DD-HHMMSS.txt
```

## Analyzing the Boot Log and Applying Changes

* Open your preferred LLM (ChatGPT and Claude work particularly well)
* Upload the debug boot log
* Use a prompt such as:
  > “Analyze the attached OpenCore debug boot log for potential issues and optimization opportunities.”
* If necessary, provide additional system information:
  * CPU
  * Chipset
  * System type (desktop, laptop, workstation, etc.)
* Address **one** issue or suggestion at a time
* Reboot after each change
* Submit the next boot log for analysis
* Repeat until no further issues or optimizations are identified

## Search terms for analyzing the OC boot log manually

Here's a concise table of common expressions/terms to search for in an OpenCore boot log, grouped by purpose. This is designed for quick diagnostics and spotting issues or confirmations.

| Category | Expressions / Terms | What to Look For |
| -------- |-------------------- |----------------- |
| **Boot flow & ACPI**           | `OC:`, `ACPI`, `SSDT`, `Failed to load table`, `Skipping add ACPI`                                   | Confirm which tables are loaded, which are skipped, and any injection issues     |
| **CPU / Power Management**     | `AppleACPICPU`, `CPU PM`, `PLUG`, `CST`, `P-States`, `EIST`                                          | Check CPU detection, power management, and correct P-State/CPU PM initialization |
| **Memory / MMIO**              | `DevirtualiseMmio`, `Mmio`, `RebuildAppleMemoryMap`, `SetupVirtualMap`, `runtime area`, `allocation` | Spot memory map issues, runtime allocation failures, or unnecessary MMIO quirks  |
| **Graphics / GOP**             | `GOP`, `Framebuffer`, `UIScale`, `Current FB`, `TextRenderer`, `Graphics`                            | Verify framebuffer setup, resolution, and any fallback to text mode              |
| **NVRAM**                      | `Setting NVRAM`, `Deleting NVRAM`, `boot-args`, `csr-active-config`, `prev-lang:kbd`                 | Ensure variables are written, persistent, and no redundant deletion occurs       |
| **Drivers / Kexts**            | `HfsPlus.efi`, `OpenRuntime.efi`, `ResetNvramEntry.efi`, `Driver loaded`                             | Check that essential drivers load and optional ones are not failing              |
| **VT-d / AppleVTD**            | `DMAR`, `AppleVTD`, `DisableIoMapper`, `IOMapper`                                                    | Confirm VT-d table parsing and correct AppleVTD functionality                    |
| **Picker / GUI**               | `OpenCanopy`, `GoldenGate`, `Theme`, `Failed to load image`                                          | Detect UI rendering issues or missing assets                                     |
| **Errors / Warnings / Panics** | `Error`, `Failed`, `Skipped`, `Panic`, `Unsupported`, `Missing`                                      | Critical problems or things that may affect stability                            |
| **Sleep / RTC / Power**        | `RTC`, `Sleep`, `Wake`, `PowerState`                                                                 | Optional: check power transitions for potential issues                           |
| **SMBIOS / Platform info**     | `SMBIOS`, `iMac`, `PlatformInfo`, `ROM`                                                              | Validate correct SMBIOS injection and MAC/ROM settings                           |


## Wrapping Up: Reverting OpenCore to the Release Build

Once optimization is complete, revert OpenCore back to the **RELEASE** build.

* Launch OCAT
* Select **Edit → OpenCore DEBUG** again to **disable** it
* Mount your ESP and open `config.plist`
* Navigate to `Misc → Debug`
  * Disable `AppleDebug`
  * Disable `ApplePanic`
  * Set `Misc/Debug/Target` to `0`
* Click **Upgrade OpenCore and kexts**
* Update OpenCore files and drivers
* Save and reboot

---

## Addendum: When *Not* to Optimize

Optimization is not always the correct goal. Avoid or postpone quirk reduction in the following situations:

* **Production or mission-critical systems**
  If stability is more important than elegance, a working configuration should be left untouched.

* **Systems with unstable or poorly implemented firmware**
  Some UEFI implementations rely on OpenCore workarounds even if they do not appear strictly necessary in every boot log.

* **Frequently changing hardware configurations**
  Regularly swapping GPUs, PCIe devices, or USB peripherals can invalidate previous conclusions.

* **Immediately before macOS or firmware updates**
  Apply optimizations *after* updates, not before, to simplify troubleshooting.

* **When proper validation is not possible**
  If cold boots, sleep tests, NVRAM resets, or recovery boots cannot be performed, changes cannot be validated reliably.

In these cases, a slightly over-configured but stable OpenCore setup is preferable to a minimal one with hidden fragility.
