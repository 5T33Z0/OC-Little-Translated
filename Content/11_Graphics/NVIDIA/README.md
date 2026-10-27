# NVIDIA Graphics in macOS

Historically, NVIDIA support in macOS was divided between native Apple drivers (which ended with Kepler in macOS Big Sur) and official NVIDIA Web Drivers (which ceased development after macOS High Sierra 10.13.6). 

Today, running NVIDIA graphics on modern macOS (Big Sur and newer) relies on two community pathways:
1. **Legacy GPUs (Kepler, Maxwell, Pascal):** Kept alive via root patching with [OpenCore Legacy Patcher (OCLP)](https://github.com/dortania/OpenCore-Legacy-Patcher).
2. **Modern GPUs (Turing, Ampere, Ada Lovelace, Blackwell):** Enabled via experimental translation drivers such as [NullMoth's nvidia-macos-driver](https://github.com/nullmoth/nvidia-macos-driver) targeting Metal 3.

> [!NOTE]
> Older OS versions (Mojave and Catalina) relied on standalone patchers by dosdude1, whereas OpenCore Legacy Patcher focuses on **macOS Big Sur (11) and newer**. Earlier architectures (Tesla, Fermi) are considered obsolete and omitted here.

---

## NVIDIA GPU Support Matrix (macOS 11+)

| Architecture | Example GPUs | macOS 11 (Big Sur) | macOS 12 (Monterey) | macOS 13+ (Ventura, Sonoma, Sequoia) | Requirements & Method |
| :--- | :--- | :---: | :---: | :---: | :--- |
| **Kepler** | GTX 650–780 Ti, GT 710/730 *(GK104/GK107/GK208)* | **Native** | **OCLP** | **OCLP** | • Native in macOS 11.<br>• Requires OCLP root patch for macOS 12+.<br>• Metal 2 support. |
| **Maxwell** | GTX 750 / 750 Ti, GTX 950–980 Ti, Titan X *(GM107/GM20x)* | **OCLP** | **OCLP** | ❌ **Unsupported** | • Legacy Web Driver re-injection via OCLP.<br>• macOS 13+ dropped required frameworks (no Metal backend). |
| **Pascal** | GT 1030, GTX 1050–1080 Ti, Titan Xp *(GP10x)* | **OCLP** | **OCLP** | ❌ **Unsupported** | • Legacy Web Driver re-injection via OCLP.<br>• macOS 13+ dropped required frameworks (no Metal backend). |
| **Turing** | GTX 16xx, RTX 2060–2080 Ti, Titan RTX | ❌ | ❌ | 🧪 **Experimental** | • [nvidia-macos-driver](https://github.com/nullmoth/nvidia-macos-driver) (NullMoth).<br>• Requires reduced security / SIP adjustments.<br>• Metal 3 translation layer. |
| **Ampere** | RTX 3050–3090 Ti | ❌ | ❌ | 🧪 **Experimental** | • Same as Turing. |
| **Ada Lovelace** | RTX 4060–4090 | ❌ | ❌ | 🧪 **Experimental** | • Same as Turing. |
| **Blackwell** | RTX 5060–5090 | ❌ | ❌ | 🧪 **Experimental** | • Same as Turing. |

---

## Modern NVIDIA GPUs (RTX / Turing & Newer)

Modern NVIDIA architectures have **no official native drivers** from Apple or NVIDIA. However, community-driven projects have introduced translation-layer drivers that bridge modern hardware to macOS's graphics stack.

### NullMoth's Driver Project

The [**nvidia-macos-driver**](https://github.com/nullmoth/nvidia-macos-driver) developed by NullMoth takes a novel approach:

* **Architecture:** Utilizes modern NVIDIA GSP firmware and translation layers (Vulkan/SPIR-V to Metal) to bring graphics acceleration to Turing through Blackwell cards.
* **Metal Support:** Aims for **Metal 3** support on modern macOS releases.
* **Nature:** This is **not** an NVIDIA Web Driver. It is an independent open-source driver project.

For details, prerequisites, and setup instructions, see &rarr; [**Modern RTX Documentation & Setup**](/Content/11_Graphics/NVIDIA/RTX/README.md)

---

## Legacy NVIDIA GPUs (Kepler, Maxwell, Pascal)

### Kepler (macOS 12+)
Apple removed Kepler graphics drivers in macOS Monterey (12.0). However, because Kepler supports Apple's Metal 2 API, OpenCore Legacy Patcher can reliably restore full acceleration by re-installing the Big Sur driver bundle into newer macOS installations.

### Maxwell & Pascal (macOS 11/12)
NVIDIA Web Drivers originally developed for macOS High Sierra (10.13.6) can be injected via OCLP up to macOS Monterey. However:
* In 2022, NVIDIA revoked the Web Driver certificates. OCLP bypasses this revocation during root patching.
* Maxwell and Pascal cards lack a modern Metal backend in macOS; as a result, starting in macOS 13 (Ventura), Web Driver support is fundamentally broken and not viable for daily use.

### Laptops with Optimus
On dual-GPU laptops (Intel iGPU + NVIDIA dGPU), the discrete NVIDIA card is typically wired through NVIDIA Optimus, which cannot be switched dynamically in macOS. These cards must be disabled via ACPI to save battery and prevent sleep/wake issues.

👉 For legacy patching and laptop disabling guides, see:
* [**Kepler in macOS 12+ (OCLP)**](/Content/11_Graphics/NVIDIA/Legacy/Kepler/README.md)
* [**Disabling Unsupported Laptop GPUs (SSDT-dGPU-Off)**](/Content/11_Graphics/NVIDIA/Legacy/Disabling_unsupported_GPUs/README.md)

> [!TIP]
> 
> If your system is also considered legacy, check out [**OCLP for Hackintosh**](https://github.com/5T33Z0/OCLP4Hackintosh) for step-by-step instructions on using OpenCore Legacy Patcher to revive dropped Intel hardware and Kepler graphics on macOS 12 Monterey and newer.

---

## Troubleshooting & Important Notes

* **SIP & AMFI Restrictions:** Running non-native graphics drivers (whether OCLP root patches or third-party kexts like `nvidia-macos-driver`) requires lowering System Integrity Protection (`csr-active-config`) and disabling/adjusting AMFI (`amfi_get_out_of_my_way=1` or `AMFIPass.kext`).
* **Hardware Fatigue:** Be cautious when purchasing older Kepler cards (such as the GTX 760 or 770). Due to their age, thermal stress, and power draw, they have a high failure rate in modern rigs.
* **Display Output Issues:** On discrete NVIDIA desktop cards, black screen issues on boot are typically solved using the boot argument `agdpmod=pikera` or by testing alternative DisplayPort/HDMI ports.
