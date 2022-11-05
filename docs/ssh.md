# SSH

## Forward SSH ports while connected

[Stack Overflow](https://stackoverflow.com/a/5211629/15142953)

If you set your escape character with EscapeChar option in ~/.ssh/config or with the -e option, you can.

Assume that the escape character is `~`:

```shell
~C-L 8000:localhost:9000
```

## ssh_config global settings vs `Host *`

[Unix & Linux Stack Exchange](https://unix.stackexchange.com/a/606837/462475)

Settings in the "top" level can’t be overridden, whereas settings in `Host *` will be overridden by any setting defined before that section (in the "top" level, or in a section matching the target host).

The "top" level should be used for settings which shouldn’t be overridden, and the `Host *` section, which should come last, should be used for default settings.
