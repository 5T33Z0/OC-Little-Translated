# Firefox Hardware Acceleration Guide for Intel iGPUs

This guide explains how to enable **reliable hardware video decoding in Firefox on macOS** for **Hackintosh systems using Intel iGPUs from 3rd–10th generation**.

## Background

Firefox on macOS does not always reliably enable hardware video decoding through Apple's **VideoToolbox** framework.

YouTube typically serves videos using modern codecs:

1. **AV1**
2. **VP9**
3. **H264**

Older Intel iGPUs cannot decode **VP9 or AV1** in hardware. When Firefox receives one of these codecs, it falls back to **software decoding**, which causes:

* high CPU usage
* increased system temperature
* dropped frames

To ensure efficient playback, two things are required:

1. Enable **hardware decoding in Firefox**
2. Ensure YouTube serves a **GPU-supported codec**

## Intel iGPU Codec Support

Hardware decoding capability varies by CPU generation.

| CPU Gen | Architecture        | Example iGPU        | H264 | VP9    | HEVC  | AV1 |
| ------- | ------------------- | ------------------- | ---- | ------ | ----- | --- |
| 3rd     | Ivy Bridge          | HD 4000             | ✅    | ❌      | ❌ | ❌   |
| 4th     | Haswell             | HD 4600 / Iris      | ✅    | ❌      | ❌ | ❌   |
| 5th     | Broadwell           | HD 6000 / Iris 6100 | ✅    | ❌      | ❌  | ❌   |
| 6th     | Skylake             | HD 520 / HD 530     | ✅    | ❌      | ⚠️ partial | ❌   |
| 7th     | Kaby Lake           | HD 620 / HD 630     | ✅    | ❌      | ✅  | ❌   |
| 8th     | Coffee Lake         | UHD 620 / UHD 630   | ✅    | ❌ / ⚠️ | ✅  | ❌   |
| 9th     | Coffee Lake Refresh | UHD 630             | ✅    | ⚠️      | ✅  | ❌   |
| 10th    | Ice Lake            | Iris Plus           | ✅    | ✅      | ✅  | ❌   |

**Important**:

* **AV1 hardware decoding is not supported** on Hackintosh-compatible Intel iGPUs.
* VP9 hardware decoding may vary depending on **macOS version and browser implementation**.

---

## Step 1: Enable Hardware Decoding in Firefox

Open:

```
about:config
```

Set the following preferences:

| Preference                                    | Value  |
| --------------------------------------------- | ------ |
| `media.hardware-video-decoding.enabled`       | `true` |
| `media.hardware-video-decoding.force-enabled` | `true` |
| `media.webrtc.hw.h264.enabled`                | `true` |
| `layers.acceleration.force-enabled`           | `true` |

After changing these values:

**Restart Firefox completely.**

Close all Firefox windows. Reloading a tab is not sufficient.

---

## Step 2: Identify Your Intel iGPU

In macOS:

1. Open **About This Mac**
2. Click **System Report**
3. Open **Graphics / Displays**

---

## Step 3: Install `enhanced-h264ify`

Install the Firefox extension:

**enhanced-h264ify**

[https://addons.mozilla.org/en-US/firefox/addon/enhanced-h264ify/](https://addons.mozilla.org/en-US/firefox/addon/enhanced-h264ify/)

This extension allows you to **block specific codecs**, forcing YouTube to deliver formats supported by your iGPU.

---

## Step 4: Configure Codec Blocking

Open the **enhanced-h264ify settings**.

Steps:

1. Click the **Extensions icon** in the Firefox toolbar
2. Select **enhanced-h264ify**
3. Open **Settings / Options**

You will see checkboxes for codecs that can be blocked. The following table shows the CODECS to block based on the used iGPU:


| CPU Generation | Example iGPU        | H264 | VP9        | Strategy |
| -------------- | ------------------- | ---- | ---------- | -------- |
| 3rd Gen        | HD 4000             | ✅    | ❌          | **Force H264** (block VP9 / AV1 / VP8 in enhanced-h264ify) |
| 4th Gen        | HD 4600 / Iris      | ✅    | ❌          | **Force H264**                                             |
| 5th Gen        | HD 6000 / Iris 6100 | ✅    | ❌          | **Force H264**                                             |
| 6th Gen        | HD 520 / HD 530     | ✅    | ❌          | **Force H264**                                             |
| 7th Gen        | HD 620 / HD 630     | ✅    | ❌          | **Force H264**                                             |
| 8th Gen        | UHD 620 / UHD 630   | ✅    | ⚠️ partial | **Force H264** (VP9 may work on some UHD 630)              |
| 9th Gen        | UHD 630             | ✅    | ⚠️         | **Allow VP9**, block AV1                                   |
| 10th Gen       | Iris Plus           | ✅    | ✅          | **Allow VP9**, block AV1                                   |

## Step 5: Verify Hardware Decoding

In Firefox, open:

```
about:support
```

Scroll to the **Media** section.

**Expected entries**:

| Codec | Hardware Decoding               |
| ----- | ------------------------------- |
| H264  | Supported                       |
| VP9   | Supported (if supported by GPU) |

## Step 6: Verify the Codec Used by YouTube

1. Open a YouTube video
2. Right-click the player
3. Select **Stats for nerds**

Look at **Codec**.

| Codec         | Meaning |
| ------------- | ------- |
| `avc1.xxxxxx` | H264    |
| `vp09.xxxxxx` | VP9     |
| `av01.xxxxxx` | AV1     |

Ensure the codec matches your configuration from **Step 5**.

---

## Step 7: Activity Monitor Test

This is the **most reliable test** for hardware decoding.

1. Open **Activity Monitor**
2. Select the **CPU** tab
3. Start a **1080p YouTube video in Firefox**
4. Watch the **Firefox Web Content** process

Expected CPU usage:

| Resolution | Typical CPU Usage |
| ---------- | ----------------- |
| 1080p      | ~5–15%            |
| 1440p      | ~10–20%           |

If CPU usage rises above **30–80%**, decoding is likely happening in software.

---

## Step 8: Safari Baseline Test

Safari uses Apple's native media stack and provides a good **VideoToolbox baseline**.

1. Open the same YouTube video in **Safari**
2. Play at **1080p**
3. Compare CPU usage in **Activity Monitor**

Interpretation:

| Result                           | Meaning                     |
| -------------------------------- | --------------------------- |
| Safari low CPU, Firefox high CPU | Firefox configuration issue |
| Both low CPU                     | Hardware decode working     |
| Both high CPU                    | iGPU acceleration problem   |

If Safari also shows high CPU usage, the issue is likely:

* incorrect framebuffer configuration
* missing iGPU acceleration
* outdated **Lilu / WhateverGreen**

---

## Expected CPU Usage

With working hardware decoding:

| Resolution | Typical CPU Usage |
| ---------- | ----------------- |
| 1080p      | ~5–15%            |
| 1440p      | ~10–20%           |

Higher CPU usage usually indicates **software decoding**.


