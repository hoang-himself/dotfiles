# Windows

## SSH keys are not working properly

A typical SSH key-based authentication setup has a private key and a public key.
The private key **must** have Unix line-endings.

In order to achieve this, it is best to use `dos2unix`.
You can find this package on most Linux distros, or use [Dos2Unix for Windows](https://waterlan.home.xs4all.nl/dos2unix.html).

## Windows special folders

- [System special folders](https://docs.microsoft.com/en-us/dotnet/api/system.environment.specialfolder)
- `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\`
