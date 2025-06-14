# Preparing the installation image

## Download raw image and decompress

Make sure to download the `Raw image for aarch64` from [the download page](https://getfedora.org/en/server/download/)

## Mount the file system

```shell
kpartx -av Fedora-Server.aarch64.raw
mkdir -p /mnt/raw3
mount /dev/fedora/root /mnt/raw3

dnf install -y qemu-user-static
systemctl restart systemd-binfmt
```

## `chroot` into` the image

```shell
chroot /mnt/raw3 /bin/bash
```

## Disable OOBE

```shell
unlink /etc/systemd/system/multi-user.target.wants/initial-setup.service
unlink /etc/systemd/system/graphical.target.wants/initial-setup.service
```

## Users and groups

```shell
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers.d/wheel-nopasswd
groupadd -g 1000 user

# Initially the user has no password to be logged in with
useradd -g user -G wheel -m -u 1000 user
passwd user
```

## Set authorized SSH keys

```shell
mkdir -p /home/user/.ssh
touch /home/user/.ssh/authorized_keys # add your public key to this file
chmod 700 /home/user/.ssh
chmod 600 /home/user/.ssh/authorized_keys
```

## Networking

```shell
firewall-cmd --permanent --add-service mdns
hostnamectl hostname raspberrypi.local

mkdir -p /etc/systemd/resolved.conf.d
tee '/etc/systemd/resolved.conf.d/mdns.conf' <<'__EOF__' >/dev/null
[Resolve]
MulticastDNS=yes
LLMNR=no
__EOF__

tee '/etc/NetworkManager/conf.d/mdns.conf' <<'__EOF__' >/dev/null
[connection]
mdns=2
llmnr=0
__EOF__

nmcli connection add type ethernet ifname <INTERFACE> con-name <NAME> ip4 <ADDRESS> gw4 <GATEWAY> -- +ipv4.dns <DNS> +connection.mdns 2
#nmcli connection modify <ID> +connection.mdns 2
nmcli connection up <NAME>
```

where:

- `<INTERFACE>` can be obtained with `nmcli device`
- Relevant IPv6 configurations can be added by replacing `4` with `6`

## Permissions

```shell
chown -R user:user /home/user
```

## Exit `chroot` and unmount the file system

```shell
exit

umount /mnt/raw3
pvscan
vgchange --activate n fedora
kpartx -d Fedora-Server.aarch64.raw
```

## Repack the image

Compress as `xz` using your favorite tool, then use [Raspberry Pi Imager](https://www.raspberrypi.com/software/) or equivalent tools to write the image to your medium
