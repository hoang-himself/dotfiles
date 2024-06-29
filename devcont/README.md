# Development Containers

## Dotfiles

There is no cross platform way to copy aliases from machine to dev container yet, so we put the dotfiles in the project then source it.

For Containerfiles, you must use absolute paths.

```Containerfile
RUN echo "[ -f /workspaces/.devcontainer/bash_aliases ] && . /workspaces/.devcontainer/bash_aliases" >>~/.bashrc
```

With a `postCreateCommand` script, you can use relative paths.

```shell
ln -frs ./.devcontainer/bash_aliases ~/.bash_aliases
```

You can copy this file to `$HOME` too, but you have to rebuild the container every time you update your dotfiles.

See:

- [Going further with Dev Containers](https://microsoft.github.io/code-with-engineering-playbook/developer-experience/going-further/#allow-some-customization)
- [Lifecycle scripts](https://containers.dev/implementors/json_reference/#lifecycle-scripts)

## Python venv

```Containerfile
...
ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
...
```
