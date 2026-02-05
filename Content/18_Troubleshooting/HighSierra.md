# Checking if macOS High Sierra modified the Preboot partitions of APFS containers 

macOS High Sierra likes to modify the Preboot partitions of APFS containers – even is installed on an  HFS+ Volune. 

When this happens, Open Core will show the Data volume as the boot item for that macOS version instead of what was in the Preboot volume. So you will still be able to boot the later macOS versions.

You can look at the `SystemVersion.plist` file in each Preboot volume to see if it's been changed to 10.13.:

**Terminal Command**:

```
source "/Volumes/Apps/File Utilities/diskutil pdisk fdisk gpt/DiskUtil.sh"
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

**Output (Example)**:

```
{
  "BuildID" => "25ED886A-846C-11EE-9012-7EEA50669733"
  "iOSSupportVersion" => "17.2"
  "ProductBuildVersion" => "23C5055b"
  "ProductCopyright" => "1983-2023 Apple Inc."
  "ProductName" => "macOS"
  "ProductUserVisibleVersion" => "14.2"
  "ProductVersion" => "14.2"
}
```

If `ProductVersion` has changed to 10.13.6, you have a problem

**Source**: [https://www.insanelymac.com/forum/topic/358185-is-there-an-opencore-fix-for-this-apfs-issue/?do=findComment&comment=2814230](https://www.insanelymac.com/forum/topic/358185-is-there-an-opencore-fix-for-this-apfs-issue/?do=findComment&comment=2814230)