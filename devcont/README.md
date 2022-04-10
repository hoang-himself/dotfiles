# Dotfiles for Development Container

## Instructions

[Going further with Dev Containers](https://microsoft.github.io/code-with-engineering-playbook/developer-experience/going-further/#allow-some-customization)

```dockerfile
...
RUN echo "[ -f ~/dotfiles/devcont/runcoms/bash_aliases ] && . ~/dotfiles/devcont/runcoms/bash_aliases" >> ~/.bash_aliases;
...
```
