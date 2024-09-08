# Triggering macOS updates manually

## About

If you are having issues with dowloading macOS updates displayed under System Settings, you can use Terminal to do so. Recently, with the way downloading Public/Developer builds of macOS is handled, I've noticed that sometimes downloads won't start or feel unresponsive – especially on legacy sysems patched with OCLP.

Since Apple decided to place the link for donwlonading macOS Sequoia on top of the list (even if you have selected public/dev builds of macOS Sonoma) it might also be helpful to download the update you *actualy* want.

## Instructions

- Open Terminal
- Enter `sudo softwareupdate -i -a -R`
- Enter your Admin Password
- This will trigger downloading the latest update:<br>![](/Users/5t33z0/Desktop/update.png)

Once the download has started, it will be reflected in System Settings > Software Update.
