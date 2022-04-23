# NVRAM Variables

## Known GUIDs

|Name |GUID      |Identfier/Description                                                                                                                                                                                                                                       |
|------------|----------|----------------------------------------------------|
|EfiGlobal              |8BE4DF61-93CA-11D2-AA0D-00E098032B8C|EFI_GLOBAL_VARIABLE_GUID, Not an Apple GUID, defined by UEFI spec|
|AppleBoot              |7C436110-AB2A-4BBB-A880-FE41995C9F82|APPLE_BOOT_VARIABLE_GUID, Default GUID, used by nvram -p                                                                                                                                                                                      |
|AppleVendor            |4D1EDE05-38C7-4A6A-9CC6-4BCCA8B38C14|APPLE_VENDOR_VARIABLE_GUID                                                                                                                                                                                                                    |
|ApplePasswordUi        |9EBA2D25-BBE3-4AC2-A2C6-C87F44A1278C|APPLE_PASSWORD_UI_EFI_FILE_NAME_GUID                                                                                                                                                                                                          |
|AppleCoreStorage       |8D63D4FE-BD3C-4AAD-881D-86FD974BC1DF|APPLE_CORE_STORAGE_VARIABLE_GUID                                                                                                                                                                                                              |
|AppleTrbSecureVariable |F68DA75E-1B55-4E70-B41B-A7B7A5B758EA|APPLE_TRB_SECURE_VARIABLE_GUID                                                                                                                                                                                                                |
|AppleTrbSecureCommand  |5D62B28D-6ED2-40B4-A560-6CD79B93D366|APPLE_TRB_STAGING_COMMAND_GUID                                                                                                                                                                                                                |
|AppleEfiPersonalization|FA4CE28D-B62F-4C99-9CC3-6815686E30F9|APPLE_EFI_PERSONALIZATION_VARIABLE_GUID                                                                                                                                                                                                       |
|AppleEfiNetwork        |36C28AB5-6566-4C50-9EBD-CBB920F83843|APPLE_EFI_NETWORK_VARIABLE_GUID                                                                                                                                                                                                               |
|AppleAcpi              |AF9FFD67-EC10-488A-9DFC-6CBF5EE22C2E|APPLE_ACPI_VARIABLE_GUID                                                                                                                                                                                                                      |
|FA4CE28D               |FA4CE28D-B62F-4C99-9CC3-6815686E30F9|                                                                                                                                                                                                                         |
|LiluNormal             |2660DD78-81D2-419D-8138-7B1F363F79A6|Custom GUID for Lilu variable storage                                                                                                                                                                                                         |
|LiluReadOnly           |E09B9297-7928-4440-9AAB-D1F8536FBF0A|Custom GUID for Lilu read-only variable storage (cannot be written from OS), implemented by AptioMemoryFix                                                                                                                                    |
|LiluWriteOnly          |F0B9AF8F-2222-4840-8A37-ECF7CC8C12E1|Custom GUID for Lilu write-only variable storage (cannot be read from OS), implemented by AptioMemoryFix                                                                                                                            

TBC…

**Source**: https://docs.google.com/spreadsheets/d/1HTCBwfOBkXsHiK7os3b2CUc6k68axdJYdGl-TyXqLu0/edit#gid=0