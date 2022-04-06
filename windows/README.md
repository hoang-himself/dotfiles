# Dotfiles for Windows

## Disclaimer

You should not clone this repo and use directly, instead create a fork or use this repo as a template to create a new one. ([Comparison](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-on-github/creating-a-repository-from-a-template#about-repository-templates))

Don't blindly use my config unless you know what that entails.
Review the code, remove things you don't want or need, and enjoy.

Using the install script might overwrite your configs.

Use at your own risk!

## Prerequisites

This repository currently does not implement the installation of the following programs, thus the user must install these manually:

- [git-scm](https://github.com/git-for-windows/git/releases/latest)
- [PowerShell Core](https://github.com/PowerShell/PowerShell/releases/latest)
- [Gpg4win](https://www.gpg4win.org/download.html)

<!-- https://www.gpg4win.org/thanks-for-download.html -->

## FAQ/Notes for self

### View all keybindings

```powershell
Get-PSReadLineKeyHandler
```

### Shift args

```powershell
$args = $args | Select-Object -Skip 1
```

or pass this instead

```powershell
$args[1..$args.Length]
```

### Get system variables

PowerShell stores a lot of system objects as virtual drives

```powershell
Get-PSDrive
```

Sample: Get environment variables

```powershell
Get-ChildItem -Path Env:
```
