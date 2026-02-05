# # Fixing APFS Preboot Volumes Corrupted by macOS High Sierra

## About

macOS High Sierra (10.13) has a known behavior where it can modify the **Preboot partitions of APFS containers**, even when High Sierra itself is installed on an HFS+ volume or on a completely different disk. These modifications can negatively affect newer macOS installations such as Big Sur and later.

When this occurs, systems using OpenCore may exhibit abnormal boot behavior, including missing or incorrect boot entries and, in some cases, an inability to boot modern macOS versions without special boot arguments.

This article explains how to detect whether High Sierra has modified your Preboot partitions and how to recover from it.

## Why This Matters

Each APFS container contains a hidden Preboot volume that stores boot-related metadata for installed macOS systems. Newer macOS versions rely on the integrity of this data.

If High Sierra alters these Preboot entries, newer macOS installations may:

* Appear as **Data volumes** instead of proper system entries in OpenCore
* Won't boot at all (indicated by "Prohibited" sign)

Even if newer macOS versions still boot, corrupted Preboot metadata can cause subtle and persistent issues.

## Detection Method

The most reliable way to verify whether High Sierra modified any Preboot volume is to inspect the `SystemVersion.plist` file stored inside each Preboot partition.

If High Sierra has overwritten the metadata, the file will incorrectly report macOS version **10.13.x** for volumes that actually belong to newer macOS releases.

## Mounting Preboot Volumes and Enumerating `SystemVersion.plist` Files

1. Download the `DiskUtil.sh` script. Leave it there.

2. Execute the following command in Terminal:

```bash
source "~/Downloads/DiskUtil.sh"
mountPrebootPartitions

IFS=$'\n'
for thefile in $(
    {
        find /Volumes/Preboot*/*/System/Library/CoreServices/SystemVersion.plist
        find /System/Volumes/Preboot*/*/System/Library/CoreServices/SystemVersion.plist
    } 2> /dev/null
); do
    theuuid="$(perl -pE "s|.*/([-0-9A-F]{36}).*|\1|" <<< "$thefile")"
    diskutil info "${theuuid}" | perl -nE 'if (/Volume Name:\s+(.*)/) { print $1 . "\n" }'
    echo "$thefile"
    plutil -p "$thefile"
done
```

**Credits**: [**joevt**](https://www.insanelymac.com/forum/topic/358185-is-there-an-opencore-fix-for-this-apfs-issue/?do=findComment&comment=2814230)

## Interpreting the Output

If any Preboot entry shows:

```text
"ProductVersion" => "10.13.6"
```

for a volume that belongs to a *newer* macOS installation, then High Sierra has modified that Preboot partition – and then you have a problem!

## Fix / Recovery

### Option 1 — Temporary Boot Workaround

Add the following boot argument in OpenCore:

```text
-no_compat_check
```

This allows the affected macOS version to boot. Then you can reinstall macOS or fix the Preboot Volume. Don't forget to remove/disable the `-no_compat_check` boot-arg afterwards!

### Option 2 — Proper Fix (Recommended)

Reinstall the affected macOS version **over itself** using **Online Recovery**:

1. Boot into macOS Recovery
2. Choose **Reinstall macOS**
3. Select the existing macOS system volume
4. Complete installation

This regenerates correct Preboot metadata without deleting user data.

After reinstalling, remove `-no_compat_check` and verify that the system boots normally.

## Use Mojave for 32-bit-support instead!

I know being able to run macOS High Sierra might be tempting for those using an NVIDIA Kepler Card since it's the last version that supports NVIDIA WebDrivers, but I strongly advise against it if you want to run macOS Big Sur or newer as well. If you just need 32 bit support, I'd recommend to install macOS Mojave instead.
