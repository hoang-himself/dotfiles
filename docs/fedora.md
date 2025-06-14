# Fedora tips

## Setting hostname (pretty, static, transient)

```shell
hostnamectl hostname raspberrypi.local
```

## Setting timezone

```shell
timedatectl set-timezone UTC
timedatectl set-local-rtc no
```

## Change SSHD port

First, enable the new port in SELinux and the firewall

```shell
semanage port -a -t ssh_port_t -p tcp 69420

firewall-cmd --permanent --service ssh --add-port 69420/tcp
#firewall-cmd --permanent --add-port 69420/tcp
#firewall-cmd --runtime-to-permanent
firewall-cmd --reload
```

Then, change revelant `sshd` configs in `/etc/ssh`, then restart `sshd` service
