# Dotfiles for Development Container

## Instructions

There is no cross platform way to copy aliases from machine to dev container
yet, so we leave the alias file in the project then source it.

[Going further with Dev Containers](https://microsoft.github.io/code-with-engineering-playbook/developer-experience/going-further/#allow-some-customization)

YOU HAVE TO USE ABSOLUTE PATH HERE

```Dockerfile
...
RUN echo "[ -f /workspace/.devcontainer/bash_aliases ] && . /workspace/.devcontainer/bash_aliases" >>~/.bashrc
...
```

You can make Docker copies this file to `$HOME` to, but you have to rebuild
the container every time you update aliases.
