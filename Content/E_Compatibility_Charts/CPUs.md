# CPU Family Codenames for Hackintosh

A quick reference to Intel and AMD CPU codenames relevant to Hackintosh compatibility, OpenCore configuration, kernel patches, and hardware-specific driver development.

> [!IMPORTANT] 
> 
> CPU compatibility does not guarantee graphics acceleration. Integrated graphics, power management, audio, and other platform devices must be evaluated separately. See the [Dortania OpenCore Install Guide — Hardware Limitations](https://dortania.github.io/OpenCore-Install-Guide/macos-limits.html).

## 🟦 Intel

Intel CPUs have the strongest native macOS compatibility because Apple shipped Macs using Intel processors. For modern Hackintosh builds, Coffee Lake and Comet Lake are particularly relevant reference platforms.

| Codename | Architecture /<br>Generation | Example CPUs | macOS Support (without using [**OCLP**](https://github.com/5T33Z0/OCLP4Hackintosh)) |
| --- | ---: | ---: | --- |
| Lynnfield, Nehalem, etc. | Core i, 1st Gen | i7-870, i7-980X | OS X 10.5 – macOS 12 Monterey* |
| Sandy Bridge | 2nd Gen | i7-2600K | OS X 10.6 – macOS 12 Monterey |
| Ivy Bridge | 3rd Gen | i7-3770K | OS X 10.7 – macOS 11 Big Sur |
| Haswell | 4th Gen | i7-4770K | OS X 10.8 – macOS 12 Monterey |
| Broadwell | 5th Gen | i7-5775C | OS X 10.10 – macOS 12 Monterey |
| Skylake | 6th Gen | i7-6700K | OS X 10.11 – macOS 15 Sequoia* |
| Kaby Lake | 7th Gen | i7-7700K | macOS 10.12 Sierra – macOS 15 Sequoia |
| Coffee Lake | 8th Gen | i7-8700K | macOS 10.13.6 High Sierra – macOS 15 Sequoia |
| Coffee Lake Refresh | 9th Gen | i9-9900K | macOS 10.14 Mojave – macOS 15 Sequoia |
| Comet Lake | 10th Gen | i9-10900K | macOS 10.15 Catalina – macOS 26 Tahoe |
| Ice Lake | 10th Gen, mobile | i7-1065G7 | macOS 10.15 Catalina – macOS 26 Tahoe* |
||
| Rocket Lake | 11th generation | i7-11700K | macOS Tahoe 26 (requires Comet Lake CPUID spoofing; iGPU unsupported) |
| Tiger Lake | 11th generation, mobile | i7-1165G7 | macOS Tahoe 26 (requires Comet Lake CPUID spoofing; iGPU unsupported) |
| Alder Lake | 12th generation | i7-12700K | macOS Tahoe 26 (requires Comet Lake CPUID spoofing; iGPU unsupported) |
| Raptor Lake | 13th/14th generation | i7-13700K, i7-14700K | macOS Tahoe 26 (requires Comet Lake CPUID spoofing; iGPU unsupported) |
| Meteor Lake | Core Ultra Series 1, mobile | Core Ultra 7 155H | macOS Tahoe 26 (requires Comet Lake CPUID spoofing; iGPU unsupported) |
| Arrow Lake | Core Ultra Series 2, desktop | Core Ultra 9 285K | macOS Tahoe 26 (requires Comet Lake CPUID spoofing; iGPU unsupported) |

> [!NOTE]
> 
> - These ranges refer to the integrated graphics, not necessarily the maximum macOS version bootable with a compatible discrete GPU.
> - Skylake graphics can be spoofed as Kaby Lake graphics to extend support through Sequoia.
> - Pre-Haswell CPUs lack AVX2, which is required by macOS Ventura and newer without additional workarounds.
> - *Exact support depends on the CPU model and iGPU. Nehalem/Westmere systems have additional CPU and graphics limitations; Ice Lake support is model-specific.*

**Reference**: [Dortania — macOS Limits](https://dortania.github.io/OpenCore-Install-Guide/macos-limits.html), [Dortania — Intel GPU Buyers Guide](https://github.com/dortania/GPU-Buyers-Guide/blob/master/modern-gpus/intel-gpu.md).

---

## 🟥 AMD

AMD Ryzen Hackintosh systems generally require AMD-specific kernel patches. Desktop Ryzen systems with a supported discrete GPU are a different compatibility case from Ryzen laptops, where the integrated GPU and platform devices are often major obstacles.

### Desktop CPUs and APUs

| Codename | Architecture | Example CPUs | Hackintosh relevance |
| --- | --- | --- | --- |
| Bulldozer / Piledriver | AMD Family 15h | FX-8350 | Legacy AMD kernel-patch territory |
| Zen / Summit Ridge | Zen 1 | Ryzen 7 1800X | Early Ryzen Hackintosh platform |
| Zen+ / Pinnacle Ridge | Zen+ | Ryzen 7 2700X | AMD kernel patches required |
| Matisse | Zen 2 | Ryzen 7 3700X | Common Ryzen desktop Gen |
| Vermeer | Zen 3 | Ryzen 7 5800X | Common Ryzen desktop Gen |
| Raphael | Zen 4 | Ryzen 7 7700X | Newer desktop platform; compatibility depends on patches and hardware |
| Granite Ridge | Zen 5 | Ryzen 7 9700X | Newer platform; verify kernel-patch support |
| Raven Ridge | Zen, APU | Ryzen 5 2400G | Integrated Vega graphics are a separate compatibility problem |
| Picasso | Zen+, APU | Ryzen 5 3400G | Integrated Vega graphics are a separate compatibility problem |
| Renoir | Zen 2, APU | Ryzen 7 4700G | Relevant to ACP and other APU-specific driver research |
| Cezanne | Zen 3, APU | Ryzen 7 5700G | Integrated graphics and platform support need separate evaluation |

### Mobile Ryzen APUs

These codenames are particularly useful when researching laptop-specific components such as integrated graphics, audio controllers, Wi-Fi, and power management.

| Codename | Architecture | Example processors | Hackintosh relevance |
| --- | --- | --- | --- |
| Raven Ridge | Zen, Vega | Ryzen 5 2500U | Early Ryzen mobile APUs |
| Picasso | Zen+, Vega | Ryzen 5 3500U | Older AMD laptop platform |
| Renoir | Zen 2, Vega | Ryzen 7 4800U | Relevant to AMD ACP audio-driver research |
| Lucienne | Zen 2, Vega | Ryzen 7 5700U | Related architecture to Renoir, but not identical hardware |
| Cezanne | Zen 3, Vega | Ryzen 7 5800U | Common Ryzen 5000 mobile Gen |
| Barcelo / Barcelo-R | Zen 3, Vega | Ryzen 7 5825U / 7730U | Relevant to Ryzen 5000/7000-series naming and ACP investigations |
| Rembrandt / Rembrandt-R | Zen 3+, RDNA 2 | Ryzen 7 6800U / 7735U | Newer iGPU architecture; not a native macOS graphics platform |
| Phoenix | Zen 4, RDNA 3 | Ryzen 7 7840U | Newer platform; iGPU support is a major obstacle |
| Hawk Point | Zen 4, RDNA 3 | Ryzen 7 8840U | Refresh of Phoenix-class silicon |
| Mendocino | Zen 2, RDNA 2 | Ryzen 5 7520U | Different CPU and GPU combination from other Ryzen 7000 mobile chips |
| Strix Point | Zen 5 / Zen 5c | Ryzen AI 9 HX 370 | Modern platform without native macOS support |

**References**: 

- [Linux kernel AMD hardware list](https://www.kernel.org/doc/html/latest/gpu/amdgpu/amd-hardware-list-info.html)
-  [Dortania — Anti-Hackintosh Buyers Guide](https://dortania.github.io/Anti-Hackintosh-Buyers-Guide/).

---

## 🔎 Identifying a CPU codename

Do not infer the silicon codename from the product series alone. For example, a Ryzen 7 7730U is based on **Barcelo-R**, while a Ryzen 7 7840U is based on **Phoenix**. Both are branded Ryzen 7000-series processors, but their underlying architectures and integrated GPUs differ substantially.

**Useful tools and references**:

- [**Intel ARK**](https://ark.intel.com/) — official Intel processor specifications.
- [**AMD product specifications**](https://www.amd.com/en/products/specifications/processors.html) — official AMD processor information.
- [**Linux kernel AMD GPU hardware list**](https://www.kernel.org/doc/html/latest/gpu/amdgpu/amd-hardware-list-info.html) — useful cross-reference for AMD silicon and GPU IP.
- [**Dortania OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/) — established Intel Hackintosh configuration guidance.

> [!TIP]
> 
> 
**Rule of thumb:** Identify the exact processor first, determine its silicon codename second, and then check the specific macOS components that matter. A CPU codename alone cannot establish that a laptop's iGPU, microphone, sleep, or power management will work.
