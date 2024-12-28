# Development Containers

## Dotfiles

Choose either

- `Containerfile`

```Containerfile
RUN echo "[ -f /workspaces/.devcontainer/bash_aliases ] && . /workspaces/.devcontainer/bash_aliases" >>~/.bashrc
```

- `postCreateCommand`

```shell
ln -frs ./.devcontainer/bash_aliases ~/.bash_aliases
```

See:

- [Going further with Dev Containers](https://microsoft.github.io/code-with-engineering-playbook/developer-experience/going-further/#allow-some-customization)
- [Lifecycle scripts](https://containers.dev/implementors/json_reference/#lifecycle-scripts)

## Python venv

```Containerfile
ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
```
