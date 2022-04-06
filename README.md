# Dotfiles

[![Fedora and Debian](https://github.com/Smithienious/dotfiles/actions/workflows/dotfiles_nix.yml/badge.svg)](https://github.com/Smithienious/dotfiles/actions/workflows/dotfiles_nix.yml)
<!-- [![Windows](https://github.com/Smithienious/dotfiles/actions/workflows/dotfiles_windows.yml/badge.svg)](https://github.com/Smithienious/dotfiles/actions/workflows/dotfiles_windows.yml) -->
[![Development Container](https://github.com/Smithienious/dotfiles/actions/workflows/dotfiles_devcont.yml/badge.svg)](https://github.com/Smithienious/dotfiles/actions/workflows/dotfiles_devcont.yml)

## Disclaimer

You should not clone this repo and use directly, instead create a fork or use this repo as a template to create a new one. ([Comparison](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-on-github/creating-a-repository-from-a-template#about-repository-templates))

Don't blindly use my config unless you know what that entails.
Review the code, remove things you don't want or need, and enjoy.

Use at your own risk!

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

Settings in the "top" level can’t be overridden, whereas settings in `Host *` will be overridden by any setting defined before that section (in the "top" level, or in a section matching the target host).

The "top" level should be used for settings which shouldn’t be overridden, and the `Host *` section, which should come last, should be used for default settings.

[Unix & Linux Stack Exchange Thread](https://unix.stackexchange.com/q/606832)
