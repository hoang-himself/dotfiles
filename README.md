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

[Unix & Linux Stack Exchange Question](https://unix.stackexchange.com/q/606832)

Settings in the "top" level can’t be overridden, whereas settings in `Host *` will be overridden by any setting defined before that section (in the "top" level, or in a section matching the target host).

The "top" level should be used for settings which shouldn’t be overridden, and the `Host *` section, which should come last, should be used for default settings.

### How to do ssh port forwarding when already logged in with ssh?

[Stack Overflow Question](https://stackoverflow.com/questions/5211561/can-i-do-ssh-port-forwarding-after-ive-already-logged-in-with-ssh)

If you set your escape character with EscapeChar option in ~/.ssh/config or with the -e option you can.

Assuming an escape of ~: `~C-L 8000:localhost:9000`.
