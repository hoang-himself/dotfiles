# Dotfiles

[![Linux](https://github.com/Smithienious/dotfiles/actions/workflows/linux.yml/badge.svg)](https://github.com/Smithienious/dotfiles/actions/workflows/linux.yml)
[![Windows](https://github.com/Smithienious/dotfiles/actions/workflows/windows.yml/badge.svg)](https://github.com/Smithienious/dotfiles/actions/workflows/windows.yml)
[![Dev Container](https://github.com/Smithienious/dotfiles/actions/workflows/devcont.yml/badge.svg)](https://github.com/Smithienious/dotfiles/actions/workflows/devcont.yml)

## Disclaimer

You should not clone this repo and use directly, instead create a fork or use this repo as a template to create a new one. ([Comparison](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-on-github/creating-a-repository-from-a-template#about-repository-templates))

Don't blindly use my config unless you know what that entails.
Review the code, remove things you don't want or need, and enjoy.

Use at your own risk!

## Prerequisites

### *nix

- Git-SCM

### Windows only

- [Git for Windows](https://github.com/git-for-windows/git/releases/latest)
- [PowerShell Core](https://github.com/PowerShell/PowerShell/releases/latest)
- [Gpg4win](https://www.gpg4win.org/download.html)

<!-- https://www.gpg4win.org/thanks-for-download.html -->

## Feedback

Suggestions/improvements are [welcome and encouraged](https://github.com/Smithienious/dotfiles/issues)!

## Credits

- [pengwin-setup](https://github.com/WhitewaterFoundry/pengwin-setup)
- [ohmyzsh plugins](https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins)
- [Jay Harris's dotfiles](https://github.com/jayharris/dotfiles-windows)
- [Sharing Git credentials with your container](https://code.visualstudio.com/docs/remote/containers#_sharing-git-credentials-with-your-container)

## FAQ/Notes to self

### SSH keys are not working properly

A typical SSH certificate setup has a private key and a public key.
The private key **must** have Unix line-endings.

In order to achieve this, it is best to use `dos2unix`.
You can find this package on most Linux distros, or use [Dos2Unix for Windows](https://waterlan.home.xs4all.nl/dos2unix.html).

### ssh_config global settings vs `Host *`

[Unix & Linux Stack Exchange Question](https://unix.stackexchange.com/q/606832)

Settings in the "top" level can’t be overridden, whereas settings in `Host *` will be overridden by any setting defined before that section (in the "top" level, or in a section matching the target host).

The "top" level should be used for settings which shouldn’t be overridden, and the `Host *` section, which should come last, should be used for default settings.

### Forward SSH port while connected

[Stack Overflow Question](https://stackoverflow.com/questions/5211561/can-i-do-ssh-port-forwarding-after-ive-already-logged-in-with-ssh)

If you set your escape character with EscapeChar option in ~/.ssh/config or with the -e option you can.

Assuming an escape of `~`: `~C-L 8000:localhost:9000`.

### View all keybindings

```powershell
Get-PSReadLineKeyHandler
```

### Shift args

```powershell
$args = $args | Select-Object -Skip 1

# or

$args[1..$args.Length]
```
