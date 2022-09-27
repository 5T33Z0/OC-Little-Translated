# Accessing ESP Partition from within Windows

In cases where you can no longer access your EFI folder from within macOS for whatever reason, there is an easy method to access it from within Windows. Usually, mounting the ESP Partition under Windows is a pain in the ass. With OCAT however, it's super easy.

## Instructions

1. Boot into Windows
2. Run [**OCAT**](https://github.com/ic005k/OCAuxiliaryTools/releases)
3. Click on "Mount ESP":</br>![01](https://user-images.githubusercontent.com/76865553/192393152-59932729-a9e1-42e0-b071-10e6eb8e3138.png)
4. From the File Manager, select your EFI Partition from the Dropdown Menu:</br>![02](https://user-images.githubusercontent.com/76865553/192393216-59c8f957-2296-49dd-8553-0948ca28605f.png)
5. Navigate to the config.plist:</br>![03](https://user-images.githubusercontent.com/76865553/192393255-97b7911d-ce0c-4d5e-bf69-64103470419e.png)
6. Open and fix it
7. Save the config.plist and reboot into macOS
