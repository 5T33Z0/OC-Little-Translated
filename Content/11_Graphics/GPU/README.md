# GPU Support in macOS

In general, please refer to Dortania's [GPU Buyer's Guide](https://dortania.github.io/GPU-Buyers-Guide/) if you want to know if your GPU is compatible or if you want/need to buy one for hackintoshing.

## AMD GPU Cards Support
- [**AMD Compatibility Chart**](/Content/11_Graphics/GPU/AMD_GPU_Compatbility.md)
- [**Enabling (Big) Navi Cards**](/Content/11_Graphics/GPU/AMD_Navi)
- [**Enabling AMD Vega 56/64 Cards**](/Content/11_Graphics/GPU/AMD_Vega)
- [**AMD Radeon Tweaks**](/Content/11_Graphics/GPU/AMD_Radeon_Tweaks)
- [**Enabling undetected AMD GPUs**](/Content/11_Graphics/GPU/GPU_undetected)
- [**RadeonSensor**](https://github.com/NootInc/RadeonSensor) – Kexts and App for monitoring the teperature of AMD GPUs
- [**GPU BAR Size in OpenCore**](/Content/main/11_Graphics/GPU/GPU-BAR_Size)
- [**Legacy AMD Cards and macOS**](https://web.archive.org/web/20170814210930/http://www.rampagedev.com/guides/graphic-cards-injection/) (ATI 4000 to 7000 and AMD 200/300)

## NVIDIA GPU Support †
It's complicated… well, actually it isn't: just don't buy them! ;)

Although NVIDIA Cards ***were*** officially supported up to macOS High Sierra, you can no longer install Nvidia Web Drivers since [Nvidia revoked the certificates](https://twitter.com/khronokernel/status/1532545973372588033) shortly after Khronokernel figured out how to enable Nvidia Web Drivers in macOS Monterey. I don't know if this also affects previously installed Web Drivers (I guess you have to stay offline to not lose the Certs), but at this stage my advice would be to just move on and switch to AMD.

Even though Kepler Cards are supported up to macOS Big Sur, it's not worth investing in them simply because these old NVIDIA cards start dying. This year alone, my GTX 760 which I had for 4 years died basically doing nothing. The replacement GTX 760 died a month later (while the prices for these old cards are still increasing). So do yourself a favor and don't even bother buying one of these old cards.

And before someone asks: no, current NVIDIA Cards don't work for Hackintoshes. Here's a list of [(un)supported NVIDIA GPUs](https://dortania.github.io/GPU-Buyers-Guide/modern-gpus/nvidia-gpu.html#unsupported-nvidia-gpus).

To install **NVIDIA Web Drivers** with OpenCore Legacy Patcher on macOS Big Sur and newer, [follow this guide](https://elitemacx86.com/threads/how-to-enable-nvidia-webdrivers-on-macos-big-sur-and-monterey.926/).

### Nvidia support via OpenCore Legacy Patcher (OCLP)
GPUs that worked with Nvidia's Web Drivers in High Sierra should work with OCLP. Currently tested GPUs:

- GTX 650 (Kepler – GK104)
- GTX 650 TI Boost (Kepler – GK106)
- GT 710 (Kepler - GK107)
- Quadro K620 (Maxwell - GM107)
- GTX 860M (Maxwell - GM107)
- GT 1030 (Pascal - GP107)
- GTX 1050Ti (Pascal - GP107)

**Source**: [OCLP](https://github.com/dortania/OpenCore-Legacy-Patcher/pull/993)

### Installing NVIDIA Webdrivers in Big Sur and newer

- Using [OpenCore Legacy Patcher](https://elitemacx86.com/threads/how-to-enable-nvidia-webdrivers-on-macos-big-sur-and-monterey.926/) to install Webdrivers on Big Sur and Monterey.
- There's a [**guide**](https://www.reddit.com/r/hackintosh/comments/v960av/nvidia_web_driver_fix_for_high_sierra/) on reddit on how to remove ode-signing from the Webdriver installer, so it doesn't quit.

## Intel on-board Graphics

For fixing current issues, see Chapter &rarr; [Intel iGPU Fixes](/Content/11_Graphics/iGPU)
