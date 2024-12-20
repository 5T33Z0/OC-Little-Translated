# How to disable Gatekeeper in macOS Sequoia
![macOS](https://img.shields.io/badge/Supported_macOS:-≤15.3-white.svg)
## Preface

After installing macOS Sequoia beta 3 on a new Volume, I wanted to run Corpnewt's MountEFI script to mount the ESP but it was blocked by Gatekeeper. Right-clicking the file and selecting "Open" does no longer work, which is new. So I decided to disable GateKeeper via Terminal, only to realize that this is no longer possible either:

```shell
sudo spctl --master-disable
Password:
This operation is no longer supported. To disable the assessment subsystem, please use configuration profiles.
```

So, config profiles it is…

## Disabling Gatekeeper with Sentinel (recommended)

The Sentinal app will install a _signed_ config profile to disable Gatekepper.

- Download the latest version of [**Sentinel**](https://github.com/alienator88/Sentinel/releases)
- Unzip and run the app
- Click on the green lock icon
- Enter your admin password
- Click "Okay" in the "Attention" pop-up:<br>![att](https://github.com/user-attachments/assets/9c66a4c7-693f-4eab-9aa6-47ae5c1f5fe7)
- This will open the System Settings >> Privacy & Security
- Scroll down to "Security" and select "Anywhere" from the dropdown menu:<br>![disableGK](https://github.com/user-attachments/assets/16ac2a51-1207-4f7e-b68a-4dbe11291d22)
- Enter your admin pw once again
- Read the note about reduced security when disabling Geatekeeper, press "Allow Anywhere" and go on with your life:<br>![allowanywhere](https://github.com/user-attachments/assets/74d752aa-65a8-411a-b234-2746da424f55)

## Previous Method

This will install an _unsigned_ config profile to disable Gatekepper but it will be unsigned.

- Download [Disable.Gatekeeper.mobileconfig.zip](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/files/Disable.Gatekeeper.mobileconfig.zip) and unzip it
- Go to System Settings >> General >> Device Management and click the <kbd>+</kbd> button
- Navigate to the Disable.Gatekeeper.mobileconfig file and open it
- A new device called "Disable Gatekeeper" should appear:<br>![disablegk](https://github.com/user-attachments/assets/b76ed1c1-77d5-47d7-97f5-622ccf724451)

Afterwards, Gatekeeper will be disabled.

## Credits

- **dhinakg** for the mobileconfig file
- **miliuco** for the [explanations](https://www.insanelymac.com/forum/topic/359530-pre-release-macos-sequoia/?do=findComment&comment=2823334)
