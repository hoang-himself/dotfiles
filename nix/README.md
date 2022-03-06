# Dotfiles for *nix

## Disclaimer

You should not clone this repo and use directly, instead create a fork or use this repo as a template to create a new one. ([Comparison](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-on-github/creating-a-repository-from-a-template#about-repository-templates))

Don't blindly use my config unless you know what that entails.
Review the code, remove things you don't want or need, and enjoy.

Using the install script will overwrite your configs if the directories are duplicated.

Use at your own risk!

## How to install this config

```bash
./install.sh -i
```

## FAQ

- What is the `/mnt/wsl` folder?

It is a special folder shared between all running WSL2 machines on your PC.
Microsoft does not have this folder documented for some reason.

The content of this folder is lost if all machines are off, so use it wisely.
