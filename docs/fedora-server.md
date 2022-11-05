# Installing Fedora Server

## Preparing the installation image

### Download raw image and decompress

Make sure to download the `Raw image for aarch64` from [the download page](https://getfedora.org/en/server/download/)

### Mount the file system

```shell
kpartx -av Fedora-Server.aarch64.raw
mkdir -p /mnt/raw3
mount /dev/fedora/root /mnt/raw3

dnf install -y qemu-user-static
systemctl restart systemd-binfmt
```

### `chroot` into` the image

```shell
chroot /mnt/raw3 /bin/bash
```

### Disable OOBE

```shell
unlink /etc/systemd/system/multi-user.target.wants/initial-setup.service
unlink /etc/systemd/system/graphical.target.wants/initial-setup.service
```

### Tweak `dnf` for faster downloads

```shell
echo 'max_parallel_downloads=16' >>/etc/dnf/dnf.conf
echo 'fastestmirror=True' >>/etc/dnf/dnf.conf
```

### Users and groups

```shell
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers.d/wheel-nopasswd
groupadd -g 1000 user

# Initially the user has no password to be logged in with
useradd -g user -G wheel -m -u 1000 user
passwd user
```

### Set static IP address, hostname and enable mDNS

```shell
dnf install -y avahi nss-mdns
firewall-cmd --permanent --add-service mdns
hostnamectl hostname raspberrypi.local

nmcli connection add type ethernet ifname <INTERFACE> con-name <NAME> ip4 <ADDRESS> gw4 <GATEWAY> -- +ipv4.dns <DNS> +connection.mdns 2
nmcli connection up <NAME>
```

where:

- `<INTERFACE>` can be obtained with `nmcli device`
- Relevant IPv6 configurations can be added by replacing `4` with `6`

### Change SSHD port

First, enable the new port in SELinux and the firewall

```shell
semanage port -a -t ssh_port_t -p tcp 69420

firewall-cmd --permanent --service ssh --add-port 69420/tcp
#firewall-cmd --permanent --add-port 69420/tcp
#firewall-cmd --runtime-to-permanent
firewall-cmd --reload
```

Then, change revelant `sshd` configs in `/etc/ssh`, then restart `sshd` service

### Set authorized SSH keys

```shell
mkdir -p /home/user/.ssh
touch /home/user/.ssh/authorized_keys # add your public key to this file
chmod 700 /home/user/.ssh
chmod 600 /home/user/.ssh/authorized_keys
```

### Permissions

```shell
chown -R user:user /home/user
```

### Exit `chroot` and unmount the file system

```shell
exit

umount /mnt/raw3
pvscan
vgchange --activate n fedora
kpartx -d Fedora-Server.aarch64.raw
```

### Repack the image

Compress as `xz` using your favorite tool, then use [Raspberry Pi Imager](https://www.raspberrypi.com/software/) or equivalent tools to write the image to your medium

## Post-installation configurations

These tasks cannot be performed during the [preparation step](#preparing-the-installation-image) due to various reasons

### Setting hostname (pretty, static, transient)

```shell
hostnamectl hostname raspberrypi.local
```

### Setting timezone

Since this is a server image, it is recommended to set the timezone to UTC

If your applications require a different time zone, in most cases, it is possible to set a different time zone than the system one for individual applications by setting the `TZ` environment variable

```shell
timedatectl set-timezone UTC
timedatectl set-local-rtc no
```
